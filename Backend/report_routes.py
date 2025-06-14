from flask import Blueprint, jsonify
import sqlite3

report_routes = Blueprint('report_routes', __name__)

# Connect to your DB (adjust path as needed)
conn = sqlite3.connect("Backend/db.sqlite3", check_same_thread=False)
cursor = conn.cursor()

@report_routes.route("/report-summary", methods=["GET"])
def report_summary():
    try:
        cursor.execute("""
            SELECT location, COUNT(*) as count
            FROM reports
            GROUP BY location
        """)
        rows = cursor.fetchall()
        summary = []

        location_coords = {
            "Kathmandu": {"lat": 27.7172, "lng": 85.3240},
            "Pokhara": {"lat": 28.2096, "lng": 83.9856},
            "Biratnagar": {"lat": 26.4525, "lng": 87.2718},
            "Lalitpur": {"lat": 27.6644, "lng": 85.3188},
            "Butwal": {"lat": 27.7000, "lng": 83.4500},
            "Nepalgunj": {"lat": 28.0500, "lng": 81.6167},
            "Dharan": {"lat": 26.8121, "lng": 87.2832},
            "Bharatpur": {"lat": 27.6833, "lng": 84.4333},
            "Janakpur": {"lat": 26.7281, "lng": 85.9214},
            "Hetauda": {"lat": 27.4287, "lng": 85.0322}
        }

        for location, count in rows:
            coords = location_coords.get(location.strip(), {"lat": None, "lng": None})
            summary.append({
                "location": location,
                "count": count,
                "lat": coords["lat"],
                "lng": coords["lng"]
            })

        return jsonify(summary), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500
