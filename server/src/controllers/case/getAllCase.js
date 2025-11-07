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
  const {
    refereeNum,
    caseNumb,
    name,
    organization,
    value,
    caseDate,
    image,
    nic,
    userID,
  } = req.body;
  const case_date = new Date(caseDate);

  try {
    const pendingStatus = await prisma.case_status.findFirst({
      where: { status: "Pending" },
    });

    if (!pendingStatus) {
      return res
        .status(500)
        .json({ error: "Pending status not found in database" });
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

// {
//     "case-id": "12kj3hg",
//     "respondent": {
//         "person1":"pending",
//         "person2":"newAddress",
//         "person3":"summans"
//     },
//     "next-case-date":"2025-11-10",
//     "judgement":{
//         "today-payment":"50,000.00",
//         "settlement-fee":"50,000.00",
//         "next-settlement-date":"2026-11-10"
//     },
//     "other":{
//         "withdraw": false,
//         "testimony":false,
//         "image":"image_path"
//     }
// }
const updateCase = async (req, res) => {
  const { userID, caseID, respondent, nextCaseDate, judgement, other } =
    req.body;

  try {
    if (nextCaseDate && nextCaseDate.trim() !== "") {
      console.log("nextCaseDate:", nextCaseDate);
      const nextCaseDateObj = new Date(nextCaseDate);

       
      let caseStatusId = null;
      if(other.withdraw){
        const caseStatus = await prisma.case_status.findFirst({
          where: { status: "complete" },
        });
        caseStatusId = caseStatus.id;
      }else if(other.testimony){
        const caseStatus = await prisma.case_status.findFirst({
          where: { status: "hold" },
        });
        caseStatusId = caseStatus.id;

      }else{
        const caseStatus = await prisma.case_status.findFirst({
          where: { status: "pending" },
        });
        caseStatusId = caseStatus.id;
      }
    
      const updatedCaseDate = await prisma.cases.update({
        where: {
          case_number: caseID,
          user_id: userID,
        },
        data: { case_date: nextCaseDateObj, case_status_id: caseStatusId },
      });
    }

    const searchCaseInfo = await prisma.case_information.findFirst({
      where: {
        cases_case_number: caseID,
      },
    });

    if (searchCaseInfo && searchCaseInfo !== null) {
      // const updatedCase = await prisma.case_information.update({
      //   where: { cases_case_number: caseID },
      //   data: {
      //     respondent: respondent,
      //     next_settlement_date: nextCaseDateObj,
      //     judgement: judgement,
      //     other: other,
      //   },
      // });
      console.log(
        "Case information found, update logic can be implemented here."
      );
    } else {
      const status1 = await prisma.case_person_status.findFirst({
        where: { status: respondent.person1 },
      });

      const status2 = await prisma.case_person_status.findFirst({
        where: { status: respondent.person2 },
      });

      const status3 = await prisma.case_person_status.findFirst({
        where: { status: respondent.person3 },
      });

      if (!status1 || !status2 || !status3) {
        return res.status(400).json({
          error: "Invalid status for one of the persons",
        });
      }

      const newCasePerson = await prisma.case_person.create({
        data: {
          person_1: status1.id,
          person_2: status2.id,
          person_3: status3.id,
        },
      });

      if (judgement.settlementFee && judgement.settlementFee.trim() !== "" && other.image && other.image.trim() !== "") {
        
        const newCase = await prisma.case_information.create({
          data: {
            phase: 1,
            settlement_fee: Number(judgement.settlementFee),
            next_settlment_date: new Date(judgement.nextSettlementDate),
            image_path: other.image,
            case_person_id: newCasePerson.id,
            cases_case_number: caseID,
          },
        });
      }
    }

    if (judgement.todayPayment && judgement.todayPayment.trim() !== "" && Number(judgement.todayPayment) > 0) {
      const addpayment = await prisma.cash_collection.create({
        data: {
          case_number: caseID,
          payment: Number(judgement.todayPayment),
          collection_date: new Date(),
          description: "Case details updated",
         
        },
      });

      if(addpayment){
        const caseStatus = await prisma.case_status.findFirst({
          where: { status: "ongoing" },
        });
        const updatedCase = await prisma.cases.update({
          where: {
            case_number: caseID,
            user_id: userID,
          },
          data: { case_status_id: caseStatus.id }, 
        });
      }
    }else{
      console.log("No payment to add");
    }


    res.status(200).json({ message: "Case updated successfully" });
  } catch (err) {
    console.error("Error updating case:", err);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

const updatecaseDate = async (req, res) => {
  const { caseID, date, userID } = req.body;
  const case_date = new Date(date);
  try {
    const updatedCase = await prisma.cases.update({
      where: {
        case_number: caseID,
        user_id: userID,
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
  const { caseID, userID } = req.body;
  try {
    const caseDetail = await prisma.cases.findUnique({
      where: {
        case_number: caseID,
        user_id: userID,
      },
    });
    res.status(200).json({ caseDetail });
  } catch (err) {
    console.error("Error updating case date:", err);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

module.exports = {
  cases,
  caseswithDate,
  addCase,
  updateCase,
  updatecaseDate,
  caseDetails,
};
