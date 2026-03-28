provider "aws" {
  region = var.region
}

resource "aws_security_group" "app_sg" {
  name = "flask-express-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "app_server" {
  ami                    = "ami-0f5ee92e2d63afc18"
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  user_data = <<-EOF
#!/bin/bash

# Update
yum update -y

# Install dependencies
yum install -y python3 nodejs npm

# Install Flask
pip3 install flask

# =========================
# FLASK APP
# =========================
cat <<EOT > /home/ec2-user/app.py
from flask import Flask
app = Flask(__name__)

@app.route('/')
def home():
    return "Flask Backend Running 🚀"

app.run(host='0.0.0.0', port=5000)
EOT

cat <<EOT > /etc/systemd/system/flask.service
[Unit]
Description=Flask App
After=network.target

[Service]
User=ec2-user
WorkingDirectory=/home/ec2-user
ExecStart=/usr/bin/python3 /home/ec2-user/app.py
Restart=always

[Install]
WantedBy=multi-user.target
EOT

# =========================
# EXPRESS APP
# =========================
mkdir -p /home/ec2-user/express-app
cd /home/ec2-user/express-app

npm init -y
npm install express

cat <<EOT > /home/ec2-user/express-app/server.js
const express = require('express');
const app = express();

app.get('/', (req, res) => {
  res.send('Express Frontend Running 🚀');
});

app.listen(3000);
EOT

cat <<EOT > /etc/systemd/system/express.service
[Unit]
Description=Express App
After=network.target

[Service]
User=ec2-user
WorkingDirectory=/home/ec2-user/express-app
ExecStart=/usr/bin/node /home/ec2-user/express-app/server.js
Restart=always

[Install]
WantedBy=multi-user.target
EOT

# Enable & Start services
systemctl daemon-reexec
systemctl daemon-reload
systemctl enable flask
systemctl start flask
systemctl enable express
systemctl start express

EOF

  tags = {
    Name = "Flask-Express-Single-EC2"
  }
}