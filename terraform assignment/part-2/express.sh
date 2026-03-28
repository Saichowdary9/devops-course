#!/bin/bash
apt update -y
apt install -y nodejs npm

mkdir /home/ubuntu/express-app

cat <<EOF > /home/ubuntu/express-app/server.js
const express = require("express");
const app = express();

app.get("/", (req, res) => {
  res.send("Express Frontend (EC2-2) 🚀");
});

app.listen(3000, "0.0.0.0");
EOF

cd /home/ubuntu/express-app
npm init -y
npm install express
nohup node server.js &