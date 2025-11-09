const express = require("express");
  
const {cases,caseswithDate,addCase,updateCase,updatecaseDate,caseDetails ,getAllCasesByStatus,allCaseDetails} = require("../controllers/case/getAllCase");

const router = express.Router();

router.post("/getAll", cases);
router.post("/add", addCase);
router.post("/getdetaliswithdate", caseswithDate);
router.post("/viewDetails", caseDetails);
router.post("/viewAllCaseDetails", allCaseDetails);

router.put("/updateDate", updatecaseDate);
router.post("/updateDetails", updateCase);
router.post("/viewallcases", getAllCasesByStatus);

module.exports = router; 