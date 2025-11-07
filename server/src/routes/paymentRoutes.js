const express = require("express");
const {payment} = require("../controllers/payment/viewPaymentWithID");
const { caseWithCaseNumb , addPayment } = require("../controllers/payment/getPayments");

const router = express.Router();

router.get("/getdetaliswithid", payment);

router.post("/getdetails", caseWithCaseNumb);
router.post("/getpayment", addPayment);

module.exports = router;