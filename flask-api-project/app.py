from flask import Flask, jsonify, render_template, request
from pymongo import MongoClient
import json
import os

app = Flask(__name__)

# ---------------- MongoDB Local Connection ----------------
client = MongoClient("mongodb://localhost:27017/")
db = client["assignment_db"]
collection = db["users"]

# ---------------- API Route ----------------
@app.route("/api")
def api():
    base_dir = os.path.dirname(os.path.abspath(__file__))
    file_path = os.path.join(base_dir, "data.json")

    with open(file_path, "r") as file:
        data = json.load(file)

    return jsonify(data)

# ---------------- Frontend Form ----------------
@app.route("/", methods=["GET", "POST"])
def index():
    error = None
    if request.method == "POST":
        try:
            name = request.form["name"]
            email = request.form["email"]

            collection.insert_one({
                "name": name,
                "email": email
            })

            return render_template("success.html")

        except Exception as e:
            error = str(e)

    return render_template("index.html", error=error)

if __name__ == "__main__":
    app.run(debug=True)
