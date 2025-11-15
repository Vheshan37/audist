const { PrismaClient } = require("@prisma/client");
const { payment } = require("../payment/getPayments.js");
const prisma = new PrismaClient();



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




module.exports = { caseWithCaseNumb, addPayment };