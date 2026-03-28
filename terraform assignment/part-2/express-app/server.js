const express = require("express");
const app = express();

// Middleware
app.use(express.json());

// Routes
app.get("/", (req, res) => {
  res.send("Express Frontend is Running 🚀");
});

app.get("/api", (req, res) => {
  res.json({ message: "Hello from Express API" });
});

// Start server
app.listen(3000, "0.0.0.0", () => {
  console.log("Server running on port 3000");
});