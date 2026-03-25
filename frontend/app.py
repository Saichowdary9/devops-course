from flask import Flask
import requests

app = Flask(__name__)

@app.route('/')
def home():
    try:
        response = requests.get("http://express-backend-service:5000")
        message = response.text
    except:
        message = "Backend not reachable"

    return f"""
    <h1>Flask Frontend</h1>
    <h2>Message from Backend:</h2>
    <p>{message}</p>
    """

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=3000)