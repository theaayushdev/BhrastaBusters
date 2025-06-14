from flask import Flask, render_template, request, redirect
import sqlite3
import os

# Flask app with HTML template directory
app = Flask(__name__, template_folder='templates')

# Absolute path to the database inside Backend
DB_PATH = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', 'Backend', 'db.sqlite3'))

# Home page - show all reports
@app.route('/')
def view_reports():
    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()
    cursor.execute("""
        SELECT id, department, location, description, media, token, status, 
               credibility_score, device_id, timestamp 
        FROM reports
    """)
    reports = cursor.fetchall()
    conn.close()
    return render_template('index.html', reports=reports)

# Endpoint to update status
@app.route('/update/<int:report_id>', methods=['POST'])
def update_status(report_id):
    new_status = request.form['status']
    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()
    cursor.execute("UPDATE reports SET status = ? WHERE id = ?", (new_status, report_id))
    conn.commit()
    conn.close()
    return redirect('/')

if __name__ == '__main__':
    app.run(debug=True, port=5001)  # Run on a different port if needed
