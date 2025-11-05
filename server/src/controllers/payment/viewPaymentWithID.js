
const payment = (req ,res ) =>{
    console.log("Payment details endpoint hit");

    res.status(200).json({ message: "Payment details endpoint is under construction." });
}

module.exports ={payment}