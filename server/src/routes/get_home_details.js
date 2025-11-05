const express = require("express");
const {PrismaClient} = require("@prisma/client");
const prisma = new PrismaClient();

const getHomeDetails = require("../controllers/home_details");

const router = express.Router();



