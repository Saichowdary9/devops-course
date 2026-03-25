from flask import Flask, request, jsonify
from pymongo import MongoClient

app = Flask(__name__)

client = MongoClient("mongodb://localhost:27017/")
db = client.todo_db
collection = db.items

@app.route('/submittodoitem', methods=['POST'])
def submit_todo_item():
    data = request.json

    collection.insert_one({
        "itemName": data['itemName'],
        "itemDescription": data['itemDescription']
    })

    return jsonify({"message": "To-Do item stored successfully"})
