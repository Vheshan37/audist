const express = require("express");
const {cases,caseswithDate,addCase,updateCase,updatecaseDate} = require("../controllers/case/getAllCase");

const router = express.Router();

router.post("/getAll", cases);
router.post("/add", addCase);
router.post("/getdetaliswithdate", caseswithDate);

router.put("/updateDate", updatecaseDate);
router.put("/updateDetails", updateCase);

module.exports = router; 