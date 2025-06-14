from flask import Flask, render_template, request, redirect
import sqlite3
import os
import matplotlib
matplotlib.use('Agg') 
import matplotlib.pyplot as plt

# Flask app with HTML template directory
app = Flask(__name__, template_folder='templates')

# Absolute path to the database inside Backend
DB_PATH = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', 'Backend', 'db.sqlite3'))

#  all reports
@app.route('/')
def view_reports():
    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()
    cursor.execute("""
        SELECT id, department, district, location, description, media, token, status, 
               credibility_score, device_id, timestamp 
        FROM reports
    """)
    reports = cursor.fetchall()

    #Generate district Graph
    cursor.execute("""
        SELECT district, COUNT(*) as count
        FROM reports
        GROUP BY district
        ORDER BY count DESC
    """)
    location_data = cursor.fetchall()

    locations = [row[0] for row in location_data]
    location_counts = [row[1] for row in location_data]

    graph_dir = os.path.join(os.path.dirname(__file__), 'static', 'graph')
    os.makedirs(graph_dir, exist_ok=True)

    loc_graph_path = os.path.join(graph_dir, 'location_graph.png')
    plt.figure(figsize=(10, 4))
    plt.bar(locations, location_counts, color='skyblue')
    plt.xlabel('Location')
    plt.ylabel('Number of Reports')
    plt.title('Reports by Location')
    plt.xticks(rotation=45, ha='right')
    plt.tight_layout()
    plt.savefig(loc_graph_path)
    plt.close()

    # Generate Department Graph 
    cursor.execute("""
        SELECT department, COUNT(*) as count
        FROM reports
        GROUP BY department
        ORDER BY count DESC
    """)
    dept_data = cursor.fetchall()

    departments = [row[0] for row in dept_data]
    dept_counts = [row[1] for row in dept_data]

    dept_graph_path = os.path.join(graph_dir, 'department_graph.png')
    plt.figure(figsize=(10, 4))
    plt.bar(departments, dept_counts, color='orange')
    plt.xlabel('Department')
    plt.ylabel('Number of Reports')
    plt.title('Reports by Department')
    plt.xticks(rotation=45, ha='right')
    plt.tight_layout()
    plt.savefig(dept_graph_path)
    plt.close()

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
