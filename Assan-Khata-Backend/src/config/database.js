require('dotenv').config();
const mongoose = require("mongoose");
mongoose.set("strictQuery", true);

const dbURI = process.env.MONGO_URI;

// Connect to MongoDB
mongoose.connect(dbURI);


const db = mongoose.connection;
db.on("error", console.error.bind(console, "connection error:"));
db.once("open", function () {
    console.log(`Connected to database`);
});

module.exports = db;