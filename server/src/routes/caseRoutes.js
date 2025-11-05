const express = require("express");
const {caseDetails} = require("../controllers/case/viewCaseWithID");

const router = express.Router();

router.get("/getdetaliswithid", caseDetails);

module.exports = router;