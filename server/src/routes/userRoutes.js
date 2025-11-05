const express = require("express");
const {user} = require("../controllers/user/viewUserWithID");

const router = express.Router();

router.get("/getdetaliswithid", user);


module.exports = router;

