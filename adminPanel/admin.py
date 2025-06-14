from flask import Flask, render_template, request, redirect, render_template_string, make_response, send_file
from xhtml2pdf import pisa
import base64
import io
import base64
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
    selected_department = request.args.get("department")

    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()

    # Get all department names for dropdown
    cursor.execute("SELECT DISTINCT department FROM reports WHERE department IS NOT NULL")
    all_departments = [row[0] for row in cursor.fetchall()]
    if selected_department and selected_department != "All":
        cursor.execute("""
            SELECT id, department, district, location, description, media, token, status, 
                   credibility_score, device_id, timestamp 
            FROM reports WHERE department = ?
        """, (selected_department,))
    else:
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
    district_data = cursor.fetchall()

    filtered_district_data = [(loc, count) for loc, count in district_data if loc is not None]
    district = [loc for loc, _ in filtered_district_data]
    district_counts = [count for _, count in filtered_district_data]

    graph_dir = os.path.join(os.path.dirname(__file__), 'static', 'graph')
    os.makedirs(graph_dir, exist_ok=True)

    loc_graph_path = os.path.join(graph_dir, 'location_graph.png')
    plt.figure(figsize=(10, 4))
    plt.bar(district, district_counts, color='skyblue')
    plt.xlabel('Location')
    plt.ylabel('Number of Reports')
    plt.title('Reports by district')
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

    filtered_dept_data = [(dept, count) for dept, count in dept_data if dept is not None]
    departments = [dept for dept, _ in filtered_dept_data]
    dept_counts = [count for _, count in filtered_dept_data]

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
    return render_template(
        'index.html',
        reports=reports,
        departments=all_departments,
        selected_department=selected_department
    )

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


@app.route("/report/pdf/<int:report_id>")
def generate_pdf(report_id):
    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()
    cursor.execute("""
        SELECT id, department, district, location, description, media, token, status, 
               credibility_score, device_id, timestamp 
        FROM reports
        WHERE id = ?
    """, (report_id,))
    report = cursor.fetchone()
    conn.close()

    if not report:
        return "Report not found", 404

    # Load first image and convert to base64
    image_base64 = ""
    if report[5]:
        first_image = report[5].split(",")[0]
        image_path = os.path.abspath(os.path.join("Backend", "media", first_image))
        if os.path.exists(image_path):
            with open(image_path, "rb") as img_file:
                image_base64 = base64.b64encode(img_file.read()).decode("utf-8")

    # Inline HTML with base64 image
    html_template = """
    <html>
    <head>
        <style>
            body { font-family: DejaVu Sans, sans-serif; }
            h1 { color: #1d4ed8; }
            p { line-height: 1.5; }
            img { max-width: 500px; margin-top: 20px; }
        </style>
    </head>
    <body>
        <h1>BhrastaBusters Report</h1>
        <p><strong>Report ID:</strong> {{ r[0] }}</p>
        <p><strong>Department:</strong> {{ r[1] }}</p>
        <p><strong>District:</strong> {{ r[2] }}</p>
        <p><strong>Location:</strong> {{ r[3] }}</p>
        <p><strong>Description:</strong> {{ r[4] }}</p>
        <p><strong>Status:</strong> {{ r[7] }}</p>
        <p><strong>Credibility Score:</strong> {{ r[8] }}</p>
        <p><strong>Device ID:</strong> {{ r[9] }}</p>
        <p><strong>Timestamp:</strong> {{ r[10] }}</p>
        {% if image_base64 %}
        <p><strong>Attached Media:</strong></p>
        <img src="data:image/jpeg;base64,{{ image_base64 }}">
        {% endif %}
    </body>
    </html>
    """

    rendered_html = render_template_string(html_template, r=report, image_base64=image_base64)

    # ➕ Create PDF in memory
    pdf_buffer = io.BytesIO()
    result = pisa.CreatePDF(rendered_html, dest=pdf_buffer)

    if result.err:
        return "Error generating PDF", 500

    pdf_buffer.seek(0)
    return send_file(
        pdf_buffer,
        download_name=f"report_{report_id}.pdf",
        as_attachment=True,
        mimetype='application/pdf'
    )

if __name__ == '__main__':
    app.run(debug=True, port=5001)  
