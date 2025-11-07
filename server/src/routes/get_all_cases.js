const express = require("express");
const {PrismaClient} = require("@prisma/client");
const prisma = new PrismaClient();

const router = express.Router();

router.post("/", async (req, res) => {
    try {
        const {userID} = req.body;

        const cases = await prisma.cases.findMany({
            where: { user_id: userID },
            include: {
                user: {
                    include: {
                        division: true, // include the division inside the user
                    },
                },
                case_status: true, // include case_status
            },
        });

        // Get today's date (midnight to midnight)
        const startOfToday = new Date();
        startOfToday.setHours(0, 0, 0, 0);

        const endOfToday = new Date();
        endOfToday.setHours(23, 59, 59, 999);

        // Count cases created today
        const todayCount = await prisma.cases.count({
            where: {
                user_id: userID,
                case_date: {
                    gte: startOfToday, // greater than or equal to midnight today
                    lte: endOfToday,   // less than or equal to 23:59:59 today
                },
            },
        });

        res.json({
            cases,
            todayCount,
            totalCase: cases.length,
        });
    } catch (err) {
        console.error("Error fetching cases:", err);
        res.status(500).json({error: "Internal Server Error"});
    }
});

module.exports = router;