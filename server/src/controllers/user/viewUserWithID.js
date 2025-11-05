
const user = (req ,res ) =>{
    console.log("User details endpoint hit");

    res.status(200).json({ message: "User details endpoint is under construction." });
}

module.exports ={user}