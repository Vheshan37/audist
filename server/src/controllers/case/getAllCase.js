const { PrismaClient } = require("@prisma/client");
const { user } = require("../user/viewUserWithID");
const e = require("express");
const prisma = new PrismaClient();

const cases = async (req, res) => {
  console.log("All Case details endpoint hit");

  const { userID } = req.body;
  try {
    const cases = await prisma.cases.findMany({
      where: {
        AND: [{ user_id: userID }, { case_status: { status: "Pending" } }],
      },
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
          lte: endOfToday, // less than or equal to 23:59:59 today
        },
      },
    });

    res
      .json({
        cases,
        todayCount,
        totalCase: cases.length,
      })

      .status(200);
  } catch (err) {
    console.error("Error fetching cases:", err);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

const caseswithDate = async (req, res) => {
  const { userID, date } = req.body;

  if (!date || date.trim() === "") {
    return res.status(400).json({
      error: "date is required in request body",
    });
  } else {
    console.log("date:", date);
    const selectedDate = new Date(date);

    const casesWithDate = await prisma.cases.findMany({
      where: {
        AND: [
          { user_id: userID },
          { case_status: { status: "Pending" } },
          { case_date: selectedDate },
        ],
      },
      include: {
        user: {
          include: {
            division: true, 
          },
        },
        case_status: true, 
      },
    });
    res.json({ casesWithDate }).status(200);
  }
};

const addCase = async (req, res) => {
  const { refereeNum, caseNumb, name, organization, value, caseDate, image, nic, userID } = req.body;
  const case_date = new Date(caseDate);

  try {
    const pendingStatus = await prisma.case_status.findFirst({
      where: { status: "Pending" }
    });

    if (!pendingStatus) {
      return res.status(500).json({ error: "Pending status not found in database" });
    }
    const newCase = await prisma.cases.create({
      data: {
        referee_no: refereeNum,
        case_number: caseNumb,
        name: name,
        organization: organization,
        value: value,
        case_date: case_date,
        image: image,
        user_id: userID,
        nic: nic,
        case_status_id: pendingStatus.id, 
      },
    });
    res.status(201).json({ newCase });
  } catch (err) {
    console.error("Error adding case:", err);
    res.status(500).json({ error: "Internal Server Error" });
  }

 
};

const updateCase = async (req, res) => {
  const { caseID, updateData,userID } = req.body;
  
    try {   
    const updatedCase = await prisma.cases.update({
      where: {
        id: caseID,
        user_id: userID
      },
        data: updateData,

    });
    res.status(200).json({ updatedCase });
  } catch (err) {
    console.error("Error updating case:", err);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

const updatecaseDate = async (req, res) => {
  const { caseID, date,userID } = req.body;
  const case_date = new Date(date);  
    try {   
    const updatedCase = await prisma.cases.update({
      where: {
        case_number: caseID,
        user_id: userID
      },
      data: { case_date: case_date },
    });
    res.status(200).json({ updatedCase });

  } catch (err) {
    console.error("Error updating case date:", err);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

const caseDetails = async (req, res) => {
  const { caseID,userID } = req.body;
    try {   
    const caseDetail = await prisma.cases.findUnique({
      where: {
        case_number: caseID,
        user_id: userID
      },
      
    });
    res.status(200).json({ caseDetail });

  } catch (err) {
    console.error("Error updating case date:", err);
    res.status(500).json({ error: "Internal Server Error" });
  }
};


module.exports = { cases, caseswithDate, addCase, updateCase, updatecaseDate,caseDetails };
