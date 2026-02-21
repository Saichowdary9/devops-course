const express = require("express");
const bodyParser = require("body-parser");
const axios = require("axios");

const app = express();

app.set("view engine", "ejs");
app.set("views", "./views");
app.use(bodyParser.urlencoded({ extended: true }));

// Home page
app.get("/", (req, res) => {
    res.render("index", { result: null });
});

// Form submission
app.post("/submit", async (req, res) => {
    const name = req.body.name;

    try {
        const response = await axios.post("http://backend:5000/process", {
            name: name
        });

        res.render("index", { result: response.data.message });
    } catch (error) {
        res.render("index", { result: "Error connecting to backend" });
    }
});

app.listen(3000, () => {
    console.log("Frontend running on port 3000");
});