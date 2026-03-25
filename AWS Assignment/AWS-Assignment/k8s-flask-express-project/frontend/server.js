const express = require("express");
const app = express();

app.get("/", (req, res) => {
  res.send("Hello from Express App 🚀");
});

// 🔥 THIS IS THE MOST IMPORTANT LINE
app.listen(5000, "0.0.0.0", () => {
  console.log("Server running on port 5000");
});