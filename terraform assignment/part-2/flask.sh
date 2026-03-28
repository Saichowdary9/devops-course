#!/bin/bash
apt update -y
apt install -y python3 python3-pip

mkdir /home/ubuntu/flask-app

cat <<EOF > /home/ubuntu/flask-app/app.py
from flask import Flask
app = Flask(__name__)

@app.route("/")
def home():
    return "Flask Backend (EC2-1) 🚀"

app.run(host="0.0.0.0", port=5000)
EOF

pip3 install flask
cd /home/ubuntu/flask-app
nohup python3 app.py &