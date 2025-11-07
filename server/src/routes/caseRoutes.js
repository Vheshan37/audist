const express = require("express");
const {cases,caseswithDate,addCase,updateCase,updatecaseDate,caseDetails} = require("../controllers/case/getAllCase");

const router = express.Router();

router.post("/getAll", cases);
router.post("/add", addCase);
router.post("/getdetaliswithdate", caseswithDate);
router.post("/viewDetails", caseDetails);

router.put("/updateDate", updatecaseDate);
router.post("/updateDetails", updateCase);

module.exports = router; 