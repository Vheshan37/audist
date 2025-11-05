const express = require("express");
const {payment} = require("../controllers/payment/viewPaymentWithID");

const router = express.Router();

router.get("/getdetaliswithid", payment);

module.exports = router;