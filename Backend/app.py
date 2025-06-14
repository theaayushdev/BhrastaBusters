from flask import Flask, request, jsonify, send_from_directory
from flask_cors import CORS
from flask_limiter import Limiter
from flask import send_from_directory
from werkzeug.utils import secure_filename
import os
import sqlite3
from credibility import score_text
import uuid
from datetime import datetime


app = Flask(__name__)   
CORS(app)  # Enable CORS for all routes

def get_device_id():
    return (
        request.form.get("device_id") or
        request.args.get("device_id") or
        request.headers.get("device_id") or
        request.remote_addr
    )

limiter = Limiter(
    app=app,
    key_func=get_device_id,
    default_limits=[]
)

# File Upload Setup 
UPLOAD_FOLDER = os.path.join(os.path.dirname(__file__), "media")
os.makedirs(UPLOAD_FOLDER, exist_ok=True)
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
app.config['MAX_CONTENT_LENGTH'] = 10 * 1024 * 1024  # 10 MB max file size

@app.route('/media/<path:filename>')
def serve_media(filename):
    return send_from_directory(app.config['UPLOAD_FOLDER'], filename)


conn = sqlite3.connect("Backend/db.sqlite3", check_same_thread=False)
cursor = conn.cursor()


@app.route("/")
def index():
    return "BhrastaBuster API is running!"

@app.route("/GenerateToken", methods=["GET"])
def generate_token():
    token = str(uuid.uuid4())[:9]
    return jsonify({"token": token})


@app.route("/report", methods=["POST"])
# @limiter.limit("3 per day") 
def submit_report():
    try:
        # Get uploaded image from form 
        files = request.files.getlist("media")
        filenames = []

        for file in files:
            if file and file.filename:  # ✅ Check each individual file
                filename = secure_filename(file.filename)
                filepath = os.path.join(app.config['UPLOAD_FOLDER'], filename)
                file.save(filepath)
                filenames.append(filename)

        media_filename = ",".join(filenames)

        device_id = request.form.get("device_id") 
        if not device_id:
            return jsonify({"error": "Missing device_id"}), 400
    
        departmnt = request.form.get("department", "")
        district = request.form.get("district", "")
        location = request.form.get("location", "")
        description = request.form.get("description", "")
        date = request.form.get("date", "")
        token = str(uuid.uuid4())
        status = "pending"
        timestamp = datetime.now().isoformat()

        credibility = score_text(description)

        cursor.execute("""
                INSERT INTO reports (department, district, location, date, description, media, token, status, credibility_score, device_id, timestamp)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?,?)
            """, (departmnt, district, location, date, description, media_filename, token, status, credibility, device_id, timestamp))
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
    
@app.route("/status/<token>", methods=["GET"])
def get_status(token):
    try:
        cursor.execute("SELECT status, credibility_score FROM reports WHERE token = ?", (token,))
        report = cursor.fetchone()

        if report:
            return jsonify({
                "token": token,
                "status": report[0],
            }), 200

        else:
            return jsonify({"error": "Report not found"}), 404
        
    except Exception as e:
        return jsonify({
            "error": "An error occurred while retrieving the report.",
            "details": str(e)
        }), 500
    
@app.route('/external-static/<path:filename>')
def external_static(filename):
    return send_from_directory('../adminPanel/static', filename)

if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=5000)

