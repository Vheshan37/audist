
const caseDetails = (req ,res ) =>{
    console.log("Case details endpoint hit");

    res.status(200).json({ message: "Case details endpoint is under construction. 001" });
}

module.exports ={caseDetails}