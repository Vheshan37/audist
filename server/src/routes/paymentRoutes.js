const express = require("express");
const {payment} = require("../controllers/payment/viewPaymentWithID");
const { caseWithCaseNumb , addPayment ,generateLoanLedgerPDF } = require("../controllers/payment/getPayments");

const router = express.Router();

router.get("/getdetaliswithid", payment);

router.post("/getdetails", caseWithCaseNumb);
router.post("/addpayment", addPayment);
router.post("/generateLedger", generateLoanLedgerPDF);

module.exports = router;