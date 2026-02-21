from flask import Flask, request, jsonify

app = Flask(__name__)

@app.route('/')
def home():
    return "Backend is running 🚀"
@app.route('/process', methods=["POST"])
def process():
    data = request.get_json()
    name = data.get("name")

    return jsonify({
        "message": f"Hello {name}, response from Flask backend!"
    })

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)