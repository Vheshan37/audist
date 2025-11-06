const { PrismaClient } = require("@prisma/client");
const { payment } = require("../payment/getPayments.js");
const prisma = new PrismaClient();




const caseWithCaseNumb = async (req, res) => {
    const { caseNumb, userID } = req.body;
    const includePayments = req.query.includePayments === "true";

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
                    cash_collection: {
                        select: { payment: true },
                    },
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



// const addPyment = async (req, res) => {

// }


module.exports = { caseWithCaseNumb };