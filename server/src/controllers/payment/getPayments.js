const { PrismaClient } = require("@prisma/client");
const { payment } = require("../payment/getPayments.js");
const prisma = new PrismaClient();

const PDFDocument = require("pdfkit");
const puppeteer = require("puppeteer");

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
          status: { not: "pending" },
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
      return res
        .status(404)
        .json({ message: "No case found with that number" });
    }

    let totalPaid = 0;
    let remaining = caseWithCaseNumb.value;

    // ➤ Add remaining_after_payment inside each payment
    if (includePayments && caseWithCaseNumb.cash_collection.length > 0) {
      let runningTotal = 0;

      caseWithCaseNumb.cash_collection = caseWithCaseNumb.cash_collection.map(
        (pay) => {
          runningTotal += pay.payment;

          return {
            ...pay,
            remaining_after_payment: caseWithCaseNumb.value - runningTotal,
          };
        }
      );

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
      error: "case_number, payment, payment_date, and userID are required.",
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

// ----------------------------------------------------
// Fetch Ledger Data
// ----------------------------------------------------
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

// ----------------------------------------------------
// Create HTML Template
// ----------------------------------------------------
const renderLedgerHtml = (data) => {
  return `
  <html>
  <head>
    <style>
      body {
        font-family: "Arial", sans-serif;
        padding: 40px 45px;
        color: #222;
      }

      h1 {
        text-align: center;
        font-size: 26px;
        letter-spacing: 1px;
        margin-bottom: 10px;
        padding-bottom: 5px;
        border-bottom: 2px solid #333;
      }

      h3, h4 {
        margin-top: 30px;
        margin-bottom: 10px;
        color: #333;
        font-weight: 700;
      }

      /* Details Box */
      .detailsBox {
        display: flex;
        justify-content: space-between;
        gap: 40px;
        margin-top: 25px;
        flex-wrap: wrap;
      }

      .detailsBox div {
        flex: 1 1 260px;
      }

      .detailsBox p {
        margin: 8px 0;
        display: flex;
        justify-content: space-between;
        font-size: 14px;
      }

      .detailsBox b {
        min-width: 140px;
        font-weight: 700;
      }

      .value {
        font-weight: 500;
      }

      /* Table */
      table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 10px;
        font-size: 13px;
      }

      th {
        background: #e8e8e8;
        padding: 10px;
        border: 1px solid #ccc;
        text-align: center;
        font-weight: 700;
      }

      td {
        padding: 8px;
        border: 1px solid #ddd;
      }

      tbody tr:nth-child(even) {
        background: #fafafa;
      }

      tbody tr:hover {
        background: #f3f3f3;
      }

      td:last-child, td:nth-last-child(2) {
        text-align: right;
      }

      /* Footer */
      .footer {
        margin-top: 40px;
        text-align: center;
        font-size: 11px;
        color: #666;
        border-top: 1px solid #ccc;
        padding-top: 12px;
      }
    </style>
  </head>

  <body>

    <h1>LOAN LEDGER</h1>

    <div class="detailsBox">
      <div>
        <p><b>නඩු අංකය:</b> <span class="value">${data.case_number}</span></p>
        <p><b>තීරක අංකය:</b> <span class="value">${data.referee_no}</span></p>
        <p><b>නම:</b> <span class="value">${data.name}</span></p>
        <p><b>සමිතිය:</b> <span class="value">${data.organization}</span></p>
      </div>

      <div>
        <p><b>වටිනාකම:</b> <span class="value">රු. ${data.case_value.toFixed(
          2
        )}</span></p>
        <p><b>ගෙවා අවසන් මුදල:</b> <span class="value">රු. ${data.totals.total_paid.toFixed(
          2
        )}</span></p>
        <p><b>ගෙවීමට ඉතිරි මුදල:</b> <span class="value">රු. ${data.totals.remaining_amount.toFixed(
          2
        )}</span></p>
      </div>
    </div>

    <h4>Payment History</h4>

    <table>
      <thead>
        <tr>
          <th>දිනය</th>
          <th>විස්තරය</th>
          <th>අයවීම (රු.)</th>
          <th>ඉතිරි (රු.)</th>
        </tr>
      </thead>
      <tbody>
        ${data.ledger
          .map(
            (row) => `
          <tr>
            <td>${new Date(row.date).toLocaleDateString()}</td>
            <td>${row.description}</td>
            <td>${row.payment.toFixed(2)}</td>
            <td>${row.remaining.toFixed(2)}</td>
          </tr>`
          )
          .join("")}
      </tbody>
    </table>

    <div class="footer">
      © 2025 Techknow Lanka Engineers (Pvt) Ltd. All rights reserved.
    </div>

  </body>
</html>

  `;
};

// ----------------------------------------------------
// Main PDF Generator API
// ----------------------------------------------------
const generateLoanLedgerPDF = async (req, res) => {
  const { caseNumb, userID } = req.body;

  if (!caseNumb || !userID) {
    return res.status(400).json({ error: "caseNumb and userID are required" });
  }

  try {
    const data = await fetchLedgerData(caseNumb, userID);
    if (!data) return res.status(404).json({ error: "Case not found" });

    const html = renderLedgerHtml(data);

    // const browser = await puppeteer.launch({ headless: "new" });
    const browser = await puppeteer.launch({
      headless: true,
      args: ["--no-sandbox", "--disable-setuid-sandbox"],
    });
    const page = await browser.newPage();
    await page.setContent(html, { waitUntil: "networkidle0" });

    const pdfBuffer = await page.pdf({
      format: "A4",
      printBackground: true,
      margin: { top: "20px", bottom: "20px" },
    });

    await browser.close();

    res.set({
      "Content-Type": "application/pdf",
      "Content-Disposition": `attachment; filename=LoanLedger_${caseNumb}.pdf`,
      "Content-Length": pdfBuffer.length,
    });

    return res.send(pdfBuffer);
  } catch (err) {
    console.error("PDF generation error:", err);
    return res.status(500).json({ error: "Failed to generate PDF" });
  }
};

module.exports = { caseWithCaseNumb, addPayment, generateLoanLedgerPDF };
