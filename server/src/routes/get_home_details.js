const express = require("express");
const {getHomeDetails} = require("../controllers/home_details");

const router = express.Router();

router.get("/", getHomeDetails);

module.exports = router;



