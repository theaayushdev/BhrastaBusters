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

@app.route("/GenerateToken", methods=["GET"])
def generate_token():
    token = str(uuid.uuid4())
    return jsonify({"token": token})

#report submisstion 
@app.route("/score", methods=["POST"])
@limiter.limit("3 per day") 
def submit_report():
    try:
        data = request.get_json()

        device_id = data.get("device_id")
        if not device_id:
            return jsonify({"error": "Missing device_id"}), 400
        
        departmnt = data.get("department")
        location = data.get("location")
        date  = data.get("date")
        description = data.get("description")
        media = data.get("media", "")
        token = data.get("token")

        if not all([departmnt, location, date, description, media]):
            return jsonify({"error": "Missing required fields"}), 400

        status = "pending"
        timestamp = datetime.now().isoformat()
        credibility = score_text(description)

        cursor.execute("""
            INSERT INTO reports (department, location, date, description, media, token, status, credibility_score, device_id, timestamp)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """, (departmnt, location, date, description, media, token, status, credibility, device_id, timestamp))
        conn.commit()

        print(f"Report submitted by device {device_id} with token {token}")
        return jsonify({
            "message": "Report submitted successfully",
            "token": token,
            "credibility_score": credibility
        }), 200
    
    except Exception as e:
        print("Error in /report:", e)
        return jsonify({"error": str(e)}), 500

if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=5000)
