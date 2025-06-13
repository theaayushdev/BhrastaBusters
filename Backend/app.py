from flask import Flask, request, jsonify
from flask_cors import CORS
from flask_limiter import Limiter
from flask_limiter.util import get_remote_address
import sqlite3
from ml.credibility import score_text
import uuid
from datetime import datetime

app = Flask(__name__)   
CORS(app)  # Enable CORS for all routes

@app.route("/")
def index():
    return "BhrastaBuster API is running!"

@app.route("/score", methods=["POST"])
def submit_report():
    data = request.get_json()

    token = str(uuid.uuid4())[:8]
    print("Received data:", data)

    return jsonify({
        "message": "Report submitted successfully",
        "token": token
    })

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)