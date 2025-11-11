const { PrismaClient } = require("@prisma/client");
const { user } = require("../user/viewUserWithID");
const e = require("express");
const prisma = new PrismaClient();

// Helper function to validate update case request
const validateUpdateCaseRequest = (data) => {
  const errors = [];

  if (!data.userID || data.userID.trim() === "") {
    errors.push("userID is required");
  }

  if (!data.caseID || data.caseID.trim() === "") {
    errors.push("caseID is required");
  }

  // Validate nextCaseDate if provided
  if (data.nextCaseDate && data.nextCaseDate.trim() !== "") {
    const date = new Date(data.nextCaseDate);
    if (isNaN(date.getTime())) {
      errors.push("Invalid nextCaseDate format");
    }
  }

  // Validate judgement fields if provided
  if (data.judgement) {
    if (
      data.judgement.settlementFee &&
      data.judgement.settlementFee.toString().trim() !== ""
    ) {
      const fee = Number(data.judgement.settlementFee);
      if (isNaN(fee) || fee < 0) {
        errors.push("settlementFee must be a valid positive number");
      }
    }

    if (
      data.judgement.todayPayment &&
      data.judgement.todayPayment.toString().trim() !== ""
    ) {
      const payment = Number(data.judgement.todayPayment);
      if (isNaN(payment) || payment < 0) {
        errors.push("todayPayment must be a valid positive number");
      }
    }

    if (
      data.judgement.nextSettlementDate &&
      data.judgement.nextSettlementDate.trim() !== ""
    ) {
      const date = new Date(data.judgement.nextSettlementDate);
      if (isNaN(date.getTime())) {
        errors.push("Invalid nextSettlementDate format");
      }
    }
  }

  return errors;
};

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

  // 🧾 Validation
  if (
    !refereeNum ||
    !caseNumb ||
    !name ||
    !organization ||
    !value ||
    !caseDate ||
    !nic ||
    !userID
  ) {
    return res.status(400).json({
      error: "All required fields must be provided.",
      required_fields: [
        "refereeNum",
        "caseNumb",
        "name",
        "organization",
        "value",
        "caseDate",
        "nic",
        "userID",
      ],
    });
  }

  // 💡 Optional validation checks
  if (typeof value !== "number" && isNaN(parseFloat(value))) {
    return res.status(400).json({ error: "Value must be a number." });
  }

  // Check date format
  const case_date = new Date(caseDate);
  if (isNaN(case_date.getTime())) {
    return res.status(400).json({ error: "Invalid caseDate format." });
  }

  // Check NIC length (example for SL NIC)
  if (nic.length < 10 || nic.length > 12) {
    return res.status(400).json({ error: "Invalid NIC number format." });
  }

  try {
    // 🔍 Check for duplicate case number
    const existingCase = await prisma.cases.findUnique({
      where: { case_number: caseNumb },
    });
    if (existingCase) {
      return res
        .status(409)
        .json({ error: "Case with this case number already exists." });
    }

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



const updateCase = async (req, res) => {
  const { userID, caseID, respondent, nextCaseDate, judgement, other } =
    req.body;

  try {
    // Input validation using helper function
    const validationErrors = validateUpdateCaseRequest(req.body);
    if (validationErrors.length > 0) {
      return res.status(400).json({
        error: "Validation failed",
        details: validationErrors,
      });
    }

    // Check if case exists
    const existingCase = await prisma.cases.findUnique({
      where: {
        case_number: caseID,
      },
    });

    if (!existingCase) {
      return res.status(404).json({
        error: "Case not found",
      });
    }

    // Verify user ownership
    if (existingCase.user_id !== userID) {
      return res.status(403).json({
        error: "Unauthorized to update this case",
      });
    }

    // Update case date and status if provided
    if (nextCaseDate && nextCaseDate.trim() !== "") {
      console.log("nextCaseDate:", nextCaseDate);

      // Validate date format
      const nextCaseDateObj = new Date(nextCaseDate);
      if (isNaN(nextCaseDateObj.getTime())) {
        return res.status(400).json({
          error: "Invalid date format for nextCaseDate",
        });
      }

      let caseStatusId = null;

      // Determine case status based on other fields
      if (other && other.withdraw) {
        const caseStatus = await prisma.case_status.findFirst({
          where: { status: "complete" },
        });
        if (!caseStatus) {
          return res.status(500).json({
            error: "Complete status not found in database",
          });
        }
        caseStatusId = caseStatus.id;
      } else if (other && other.testimony) {
        const caseStatus = await prisma.case_status.findFirst({
          where: { status: "hold" },
        });
        if (!caseStatus) {
          return res.status(500).json({
            error: "Hold status not found in database",
          });
        }
        caseStatusId = caseStatus.id;
      } else {
        const caseStatus = await prisma.case_status.findFirst({
          where: { status: "pending" },
        });
        if (!caseStatus) {
          return res.status(500).json({
            error: "Pending status not found in database",
          });
        }
        caseStatusId = caseStatus.id;
      }

      await prisma.cases.update({
        where: {
          case_number: caseID,
        },
        data: {
          case_date: nextCaseDateObj,
          case_status_id: caseStatusId,
        },
      });

      const isWithdraw = other?.withdraw === true;
      const isTestimony = other?.testimony === true;

      if (isWithdraw || isTestimony) {
        await prisma.case_information.updateMany({
          where: { cases_case_number: caseID },
          data: { phase: 3 },
        });
      }
    }

    // Handle case information (update or create)
    const searchCaseInfo = await prisma.case_information.findFirst({
      where: {
        cases_case_number: caseID,
      },
      include: {
        case_person: true,
      },
    });

    if (searchCaseInfo) {
      // Update existing case information
      console.log("Case information found, updating existing record");

      // Update case_person if respondent data is provided
      if (
        respondent &&
        (respondent.person1 || respondent.person2 || respondent.person3)
      ) {
        const updateData = {};

        if (respondent.person1) {
          const status1 = await prisma.case_person_status.findFirst({
            where: { status: respondent.person1 },
          });
          if (status1) updateData.person_1 = status1.id;
        }

        if (respondent.person2) {
          const status2 = await prisma.case_person_status.findFirst({
            where: { status: respondent.person2 },
          });
          if (status2) updateData.person_2 = status2.id;
        }

        if (respondent.person3) {
          const status3 = await prisma.case_person_status.findFirst({
            where: { status: respondent.person3 },
          });
          if (status3) updateData.person_3 = status3.id;
        }

        if (Object.keys(updateData).length > 0) {
          await prisma.case_person.update({
            where: { id: searchCaseInfo.case_person_id },
            data: updateData,
          });
        }
      }

      // Update case_information if judgement data is provided
      const caseInfoUpdateData = {};

      if (
        judgement &&
        judgement.settlementFee &&
        judgement.settlementFee.toString().trim() !== ""
      ) {
        const settlementFee = Number(judgement.settlementFee);
        if (!isNaN(settlementFee) && settlementFee >= 0) {
          caseInfoUpdateData.settlement_fee = settlementFee;
        }
      }

      if (
        judgement &&
        judgement.nextSettlementDate &&
        judgement.nextSettlementDate.trim() !== ""
      ) {
        const nextSettlementDateObj = new Date(judgement.nextSettlementDate);
        if (!isNaN(nextSettlementDateObj.getTime())) {
          caseInfoUpdateData.next_settlment_date = nextSettlementDateObj;
        }
      }

      if (other && other.image && other.image.trim() !== "") {
        caseInfoUpdateData.image_path = other.image;
      }

      if (Object.keys(caseInfoUpdateData).length > 0) {
        await prisma.case_information.update({
          where: { id: searchCaseInfo.id },
          data: caseInfoUpdateData,
        });
      }
    } else {
      // Create new case information
      console.log("Case information not found, creating new record");

      if (
        !respondent ||
        !respondent.person1 ||
        !respondent.person2 ||
        !respondent.person3
      ) {
        return res.status(400).json({
          error:
            "Respondent information (person1, person2, person3) is required for new case information",
        });
      }

      // Validate person statuses
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

      // Create case_person record
      const newCasePerson = await prisma.case_person.create({
        data: {
          person_1: status1.id,
          person_2: status2.id,
          person_3: status3.id,
        },
      });

      // Create case_information if required fields are provided
      // Build required fields
      const dataObj = {
        phase: 1,
        case_person_id: newCasePerson.id,
        cases_case_number: caseID,
      };

      // Optional: settlement_fee
      if (
        judgement &&
        judgement.settlementFee &&
        judgement.settlementFee.toString().trim() !== ""
      ) {
        const settlementFee = Number(judgement.settlementFee);
        if (isNaN(settlementFee) || settlementFee < 0) {
          return res
            .status(400)
            .json({ error: "Invalid settlement fee amount" });
        }
        dataObj.settlement_fee = Number(settlementFee);
      }

      // Optional: next_settlment_date
      if (
        judgement &&
        judgement.nextSettlementDate &&
        judgement.nextSettlementDate.trim() !== ""
      ) {
        const nextSettlementDateObj = new Date(judgement.nextSettlementDate);
        if (isNaN(nextSettlementDateObj.getTime())) {
          return res
            .status(400)
            .json({ error: "Invalid next settlement date format" });
        }
        dataObj.next_settlment_date = nextSettlementDateObj;
      }

      // Optional: image_path
      if (other && other.image && other.image.trim() !== "") {
        dataObj.image_path = other.image;
      }

      // Save the record
      await prisma.case_information.create({
        data: dataObj,
      });
    }

    // Handle payment if provided
    if (
      judgement &&
      judgement.todayPayment &&
      judgement.todayPayment.toString().trim() !== ""
    ) {
      const paymentAmount = Number(judgement.todayPayment);

      if (!isNaN(paymentAmount) && paymentAmount > 0) {
        const addpayment = await prisma.cash_collection.create({
          data: {
            case_number: caseID,
            payment: paymentAmount,
            collection_date: new Date(),
            description: "Case details updated",
          },
        });

        if (addpayment) {
          const ongoingStatus = await prisma.case_status.findFirst({
            where: { status: "ongoing" },
          });

          if (ongoingStatus) {
            await prisma.cases.update({
              where: {
                case_number: caseID,
              },
              data: { case_status_id: ongoingStatus.id },
            });
            await prisma.case_information.updateMany({
              where: {
                cases_case_number: caseID,
              },
              data: {
                phase: 2,
              },
            });
          }
        }
      } else if (paymentAmount < 0) {
        return res.status(400).json({
          error: "Payment amount cannot be negative",
        });
      }
    }

    res.status(200).json({
      message: "Case updated successfully",
      caseID: caseID,
    });
  } catch (err) {
    console.error("Error updating case:", err);

    // Handle specific Prisma errors
    if (err.code === "P2002") {
      return res.status(400).json({ error: "Duplicate entry found" });
    } else if (err.code === "P2025") {
      return res.status(404).json({ error: "Record not found" });
    } else if (err.code === "P2003") {
      return res
        .status(400)
        .json({ error: "Foreign key constraint violation" });
    }

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

const getAllCasesByStatus = async (req, res) => {
  try {
    const { userID } = req.body;

    if (!userID || userID.trim() === "") {
      return res.status(400).json({ error: "User ID is required" });
    }

    // 🔍 Fetch all cases that belong to this user
    const allCases = await prisma.cases.findMany({
      where: {
        user_id: userID,
      },
      select: {
        case_number: true,
        referee_no: true,
        name: true,
        organization: true,
        value: true,
        case_date: true,
        image: true,
        nic: true,
        user: {
          select: {
            name: true,
            division: true,
          },
        },
        case_status: {
          select: { status: true },
        },
        case_information: true,
      },
      orderBy: {
        case_date: "desc",
      },
    });

    // Initialize empty arrays
    const pending = [];
    const ongoing = [];
    const complete = [];
    const testimony = [];

    // Group cases by status
    allCases.forEach((caseItem) => {
      const status = caseItem.case_status.status.toLowerCase();

      if (status === "pending") pending.push(caseItem);
      else if (status === "ongoing") ongoing.push(caseItem);
      else if (status === "complete") complete.push(caseItem);
      else if (status === "testimony") testimony.push(caseItem);
    });

    // Send grouped response
    res.status(200).json({
      pending,
      ongoing,
      complete,
      testimony,
    });
  } catch (err) {
    console.error("Error fetching cases:", err);
    res.status(500).json({
      error: "Internal Server Error",
      message: err.message,
    });
  }
};

const allCaseDetails = async (req, res) => {
  const { caseID, userID } = req.body;

  try {
    const caseDetail = await prisma.cases.findUnique({
      where: { case_number: caseID },
      include: {
        case_status: true,
        case_information: {
          include: {
            case_person: {
              include: {
                case_person_status_case_person_person_1Tocase_person_status: true,
                case_person_status_case_person_person_2Tocase_person_status: true,
                case_person_status_case_person_person_3Tocase_person_status: true,
              }
            }
          }
        },
        cash_collection: true
      }
    });

    if (!caseDetail) {
      return res.status(404).json({ error: "Case not found" });
    }

    if (caseDetail.user_id !== userID) {
      return res.status(403).json({ error: "Unauthorized" });
    }

    const info = caseDetail.case_information[0];
    const person = info?.case_person;

    const output = {
      case: {
        caseNumber: caseDetail.case_number,
        refereeNo: caseDetail.referee_no,
        name: caseDetail.name,
        organization: caseDetail.organization,
        value: caseDetail.value,
        date: caseDetail.case_date,
        status: {
          id: caseDetail.case_status.id,
          label: caseDetail.case_status.status
        }
      },

      respondent: {
        person1: {
          statusId: person?.person_1,
          status: person?.person1Status?.status
        },
        person2: {
          statusId: person?.person_2,
          status: person?.person2Status?.status
        },
        person3: {
          statusId: person?.person_3,
          status: person?.person3Status?.status
        }
      },

      information: info
        ? {
          phase: info.phase,
          settlementFee: info.settlement_fee,
          nextSettlementDate: info.next_settlment_date,
          image: info.image_path
        }
        : null,

      payments: caseDetail.cash_collection.map((p) => ({
        payment: p.payment,
        date: p.collection_date,
        description: p.description
      }))
    };

    return res.status(200).json(output);

  } catch (err) {
    console.error("Error:", err);
    return res.status(500).json({ error: "Internal Server Error" });
  }
};



module.exports = {
  cases,
  caseswithDate,
  addCase,
  updateCase,
  updatecaseDate,
  caseDetails,
  getAllCasesByStatus,
  allCaseDetails,
};
