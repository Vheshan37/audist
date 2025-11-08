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
  const {
    case_number,
    payment,
    payment_date,
    next_payment_date,
    description,
    userID,
  } = req.body;

  // 🧾 Validate required fields
  if (!case_number || !payment || !payment_date || !next_payment_date || !userID) {
    return res.status(400).json({
      error:
        "case_number, payment, payment_date, next_payment_date, and userID are required.",
    });
  }

  try {
    // 🔍 1️⃣ Validate that the case_number belongs to the given user_id
    const existingCase = await prisma.cases.findFirst({
      where: {
        case_number: case_number,
        user_id: userID,
      },
    });

    if (!existingCase) {
      return res.status(404).json({
        error: "Case not found or does not belong to the given user.",
      });
    }

    // 💰 2️⃣ Add new payment record
    const newPayment = await prisma.cash_collection.create({
      data: {
        case_number,
        payment: parseFloat(payment),
        collection_date: new Date(payment_date),
        description: description || null,
      },
    });

    // 📅 3️⃣ Update the next settlement date in related case_information
    const updatedCaseInfo = await prisma.case_information.updateMany({
      where: { cases_case_number: case_number },
      data: { next_settlment_date: new Date(next_payment_date) },
    });

    // ✅ 4️⃣ Respond with success
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