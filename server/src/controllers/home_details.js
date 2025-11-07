const {PrismaClient} = require("@prisma/client");
const prisma = new PrismaClient();

const getHomeDetails = (req ,res ) =>{
    console.log("Home details endpoint hit");

    res.status(200).json({ message: "Home details endpoint is under construction." });
}

module.exports ={getHomeDetails}