const { PrismaClient } = require("@prisma/client");
const { payment } = require("../payment/getPayments.js");
const prisma = new PrismaClient();

const PDFDocument = require("pdfkit");
// const { prisma } = require("../path/to/prisma"); // adjust path



const caseWithCaseNumb = async (req, res) => {
  const { caseNumb, userID, includePayments } = req.body;

  if (!caseNumb || caseNumb.trim() === "") {
    return res.status(400).json({ error: "Case number is required" });
  }

  try {
    const caseWithCaseNumb = await prisma.cases.findFirst({
      where: {
        case_number: caseNumb,
        user_id: userID,
        case_status: {
          status: { not: "pending" }
        },
      },
      select: {
        case_number: true,
        referee_no: true,
        name: true,
        organization: true,
        value: true,
        user: {
          include: {
            division: true,
          },
        },
        case_status: {
          select: { status: true },
        },
        ...(includePayments && {
          cash_collection: {
            orderBy: { id: "asc" }, // ensure correct sequence
            select: {
              id: true,
              payment: true,
              collection_date: true,
            },

          },
        }),
      },
    });

    if (!caseWithCaseNumb) {
      return res.status(404).json({ message: "No case found with that number" });
    }

    let totalPaid = 0;
    let remaining = caseWithCaseNumb.value;

    // ➤ Add remaining_after_payment inside each payment
    if (includePayments && caseWithCaseNumb.cash_collection.length > 0) {
      let runningTotal = 0;

      caseWithCaseNumb.cash_collection = caseWithCaseNumb.cash_collection.map((pay) => {
        runningTotal += pay.payment;

        return {
          ...pay,
          remaining_after_payment: caseWithCaseNumb.value - runningTotal,
        };
      });

      totalPaid = runningTotal;
      remaining = caseWithCaseNumb.value - totalPaid;
    }

    res.status(200).json({
      case: {
        ...caseWithCaseNumb,
        ...(includePayments && {
          total_paid: totalPaid,
          remaining,
        }),
      },
    });

  } catch (err) {
    console.error("Error fetching case by number:", err);
    res.status(500).json({ error: "Internal Server Error" });
  }
};




const addPayment = async (req, res) => {
  const {
    case_number,
    payment,
    payment_date,
    next_payment_date,
    description,
    userID,
  } = req.body;

  // 🧾 Validate required fields
  if (!case_number || !payment || !payment_date || !userID) {
    return res.status(400).json({
      error:
        "case_number, payment, payment_date, and userID are required.",
    });
  }

  try {
    // 🔍 1️⃣ Check that case exists and belongs to the given user
    const existingCase = await prisma.cases.findFirst({
      where: {
        case_number,
        user_id: userID,
        case_status: {
          is: { status: "ongoing" },
        },
      },
      include: {
        cash_collection: true,
        case_status: true,
      },
    });

    if (!existingCase) {
      return res.status(404).json({
        error: "Ongoing case not found or does not belong to the given user.",
      });
    }

    // 💰 2️⃣ Add the new payment
    const newPayment = await prisma.cash_collection.create({
      data: {
        case_number,
        payment: parseFloat(payment),
        collection_date: new Date(payment_date),
        description: description || null,
      },
    });

    // 📊 3️⃣ Calculate total paid after this new payment
    const totalPaid =
      existingCase.cash_collection.reduce(
        (sum, record) => sum + record.payment,
        0
      ) + parseFloat(payment);

    const remaining = existingCase.value - totalPaid;

    // 📅 4️⃣ Update the next settlement date
    await prisma.case_information.updateMany({
      where: { cases_case_number: case_number },
      data: { next_settlment_date: new Date(next_payment_date) },
    });

    // 🔄 5️⃣ Update case status if fully paid
    if (remaining <= 0) {
      const completedStatus = await prisma.case_status.findFirst({
        where: { status: "complete" },
      });

      if (completedStatus) {
        await prisma.cases.update({
          where: { case_number },
          data: { case_status_id: completedStatus.id },
        });
      }
    }

    // ✅ 6️⃣ Respond with success info
    res.status(200).json({
      message:
        remaining <= 0
          ? "Payment added successfully. Case marked as Completed."
          : "Payment added successfully and next settlement date updated.",
      payment: newPayment,
      total_paid: totalPaid,
      remaining: remaining > 0 ? remaining : 0,
      case_status: remaining <= 0 ? "complete" : "ongoing",
    });
  } catch (err) {
    console.error("Error adding payment:", err);
    res.status(500).json({ error: err.message });
  }


};




// Helper function to fetch ledger data
const fetchLedgerData = async (caseNumb, userID) => {
  const caseData = await prisma.cases.findFirst({
    where: {
      case_number: caseNumb,
      user_id: userID,
    },
    include: {
      user: { include: { division: true } },
      case_status: true,
      cash_collection: { orderBy: { id: "asc" } },
    },
  });

  if (!caseData) return null;

  let runningTotal = 0;
  const ledger = caseData.cash_collection.map((pay) => {
    runningTotal += pay.payment;
    return {
      date: pay.collection_date,
      description: pay.description || "-",
      payment: pay.payment,
      remaining: caseData.value - runningTotal,
    };
  });

  return {
    case_number: caseData.case_number,
    referee_no: caseData.referee_no,
    name: caseData.name,
    organization: caseData.organization,
    case_value: caseData.value,
    status: caseData.case_status.status,
    officer: {
      name: caseData.user.name,
      division: caseData.user.division.division,
    },
    ledger,
    totals: {
      total_paid: runningTotal,
      remaining_amount: caseData.value - runningTotal,
    },
  };
};

// Main API
const generateLoanLedgerPDF = async (req, res) => {
  const { caseNumb, userID } = req.body;

  if (!caseNumb || !userID) {
    return res.status(400).json({ error: "caseNumb and userID are required" });
  }

  try {
    const data = await fetchLedgerData(caseNumb, userID);
    if (!data) return res.status(404).json({ error: "Case not found" });

    const doc = new PDFDocument({ size: "A4", margin: 50 });
    let buffers = [];
    doc.on("data", buffers.push.bind(buffers));
    doc.on("end", () => {
      const pdfData = Buffer.concat(buffers);
      res.writeHead(200, {
        "Content-Type": "application/pdf",
        "Content-Disposition": `attachment; filename=LoanLedger_${caseNumb}.pdf`,
        "Content-Length": pdfData.length,
      });
      res.end(pdfData);
    });

    // ----------------------------
    // TITLE
    // ----------------------------
    doc.fontSize(20).text("LOAN LEDGER", { align: "center", underline: true });
    doc.moveDown(1);

    // ----------------------------
    // CASE DETAILS (left) & VALUE INFO (right)
    // ----------------------------
    const startX = doc.x;
    doc.fontSize(12);

    // Left
    doc.text(`Case Number: ${data.case_number}`, { continued: true, width: 250 });
    doc.text(`Case Value: Rs. ${data.case_value}`, { align: "right" });
    doc.text(`Referee No: ${data.referee_no}`, { continued: true, width: 250 });
    doc.text(`Installment Value: Rs. -`, { align: "right" }); // Replace '-' with actual installment if you have
    doc.text(`Name: ${data.name}`, { continued: true, width: 250 });
    doc.text(``, { align: "right" });
    doc.text(`Organization: ${data.organization}`, { continued: true, width: 250 });
    doc.text(``, { align: "right" });
    doc.moveDown(1);

    // ----------------------------
    // PAYMENT HISTORY TABLE
    // ----------------------------
    doc.fontSize(14).text("Payment History", { underline: true });
    doc.moveDown(0.5);

    // Table Header
    doc.fontSize(12).text("Date", startX, doc.y, { width: 100, bold: true });
    doc.text("Description", startX + 100, doc.y, { width: 200 });
    doc.text("Payment (Rs.)", startX + 300, doc.y, { width: 100, align: "right" });
    doc.text("Remaining (Rs.)", startX + 400, doc.y, { width: 100, align: "right" });
    doc.moveDown(0.5);

    // Divider
    doc.moveTo(startX, doc.y).lineTo(500, doc.y).stroke();
    doc.moveDown(0.2);

    // Table Rows
    data.ledger.forEach((row) => {
      doc.text(new Date(row.date).toLocaleDateString(), startX, doc.y, { width: 100 });
      doc.text(row.description, startX + 100, doc.y, { width: 200 });
      doc.text(row.payment.toFixed(2), startX + 300, doc.y, { width: 100, align: "right" });
      doc.text(row.remaining.toFixed(2), startX + 400, doc.y, { width: 100, align: "right" });
      doc.moveDown(0.5);
    });

    doc.moveDown(2);

    // ----------------------------
    // TOTALS
    // ----------------------------
    doc.fontSize(12).text(`Total Paid: Rs. ${data.totals.total_paid.toFixed(2)}`);
    doc.text(`Remaining Balance: Rs. ${data.totals.remaining_amount.toFixed(2)}`);
    doc.moveDown(3);

    // ----------------------------
    // COPYRIGHT
    // ----------------------------
    doc.fontSize(10).text(
      "© 2025 Techknow Lanka Engineers (Pvt) Ltd. All rights reserved.",
      { align: "center" }
    );

    doc.end();
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Failed to generate PDF" });
  }
};




module.exports = { caseWithCaseNumb, addPayment , generateLoanLedgerPDF};