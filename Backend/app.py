from flask import Flask, request, jsonify
from flask_cors import CORS
from flask_limiter import Limiter
import sqlite3
from credibility import score_text
import uuid
from datetime import datetime

app = Flask(__name__)   
CORS(app)  # Enable CORS for all routes

limiter = Limiter(
    app=app,
    key_func=lambda: request.json.get("device_id", "unknown"),  # Use device_id from request
    default_limits=[]
)

conn = sqlite3.connect("Backend/db.sqlite3", check_same_thread=False)
cursor = conn.cursor()


@app.route("/")
def index():
    return "BhrastaBuster API is running!"

#report submisstion 
@app.route("/score", methods=["POST"])
@limiter.limit("3 per day") 
def submit_report():
    data = request.get_json()

    device_id = data.get("device_id")
    if not device_id:
        return jsonify({"error": "Missing device_id"}), 400
    
    departmnt = data.get("department", "")
    location = data.get("location", "")
    description = data.get("description", "")
    media = data.get("media", "")
    token = str(uuid.uuid4())
    status = "pending"
    timestamp = datetime.now().isoformat()

    credibility = score_text(description)