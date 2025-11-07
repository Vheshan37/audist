const { PrismaClient } = require("@prisma/client");
const { payment } = require("../payment/getPayments.js");
const prisma = new PrismaClient();




const caseWithCaseNumb = async (req, res) => {
    const { caseNumb, userID , includePayments } = req.body;
    // const includePayments = req.query.includePayments === "true";

    if (!caseNumb || caseNumb.trim() === "") {
        return res.status(400).json({ error: "Case number is required" });
    }

    try {
        const caseWithCaseNumb = await prisma.cases.findFirst({
            where: {
                case_number: caseNumb,
                user_id: userID,
                case_status: {
                    is: { status: "Ongoing" },
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
                // Only include cash_collection when needed
                ...(includePayments && {
                    cash_collection: true,
                }),
            },
        });

        if (!caseWithCaseNumb) {
            return res.status(404).json({ message: "No case found with that number" });
        }

        let totalPaid = 0;
        let remaining = caseWithCaseNumb.value;

        // Calculate payments only if included
        if (includePayments && caseWithCaseNumb.cash_collection) {
            totalPaid = caseWithCaseNumb.cash_collection.reduce(
                (sum, record) => sum + record.payment,
                0
            );
            remaining = caseWithCaseNumb.value - totalPaid;
        }

        // Build response dynamically
        const responseData = {
            ...caseWithCaseNumb,
            ...(includePayments && {
                total_paid: totalPaid,
                remaining,
            }),
        };

        res.status(200).json({ case: responseData });



    } catch (err) {
        console.error("Error fetching case by number:", err);
        res.status(500).json({ error: err.message });
    }
};



const addPayment = async (req, res) => {
  const { case_number, payment, payment_date, next_payment_date, description } = req.body;

  // 🧾 Validate required fields
  if (!case_number || !payment || !payment_date || !next_payment_date) {
    return res.status(400).json({
      error: "case_number, payment, payment_date, and next_payment_date are required.",
    });
  }

  try {
    // 🔹 1️⃣ Insert payment record into `cash_collection`
    const newPayment = await prisma.cash_collection.create({
      data: {
        case_number,
        payment: parseFloat(payment),
        collection_date: new Date(payment_date),
        description: description || null,
      },
    });

    // 🔹 2️⃣ Update next settlement date in `case_information`
    const updatedCaseInfo = await prisma.case_information.updateMany({
      where: { cases_case_number: case_number },
      data: { next_settlment_date: new Date(next_payment_date) },
    });

    // ⚙️ 3️⃣ Response back to client
    res.status(200).json({
      message: "Payment added and next settlement date updated successfully.",
      payment: newPayment,
      case_update: updatedCaseInfo,
    });
  } catch (err) {
    console.error("Error adding payment:", err);
    res.status(500).json({ error: err.message });
  }
};

module.exports = { caseWithCaseNumb , addPayment };