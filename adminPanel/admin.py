from flask import Flask, render_template, request, redirect, render_template_string, make_response, send_file
from xhtml2pdf import pisa
import smtplib
from email.message import EmailMessage
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
            SELECT id, department, district, location, date, description, media, token, status, 
                   credibility_score, device_id, timestamp 
            FROM reports WHERE department = ?
        """, (selected_department,))
    else:
        cursor.execute("""
        SELECT id, department, district, location, date, description, media, token, status, 
               credibility_score, device_id, timestamp 
        FROM reports
    """)
    reports = cursor.fetchall()
    reports.sort(key=lambda x: x[8] if x[8] is not None else 0, reverse=True)

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
    
    plt.figure(figsize=(12, 5))
    bars = plt.bar(district, district_counts, color='#3b82f6', edgecolor='black')

    # Add data labels on top of each bar
    for bar in bars:
        yval = bar.get_height()
        plt.text(bar.get_x() + bar.get_width() / 2, yval + 0.3, yval, ha='center', va='bottom', fontsize=9)

    plt.grid(axis='y', linestyle='--', alpha=0.6)
    plt.xlabel('District', fontsize=12, weight='bold')
    plt.ylabel('Number of Reports', fontsize=12, weight='bold')
    plt.xticks(rotation=45, ha='right', fontsize=10)
    plt.yticks(fontsize=10)
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
    plt.figure(figsize=(12, 5))
    plt.bar(departments, dept_counts, color='orange',edgecolor='black')
    plt.xlabel('Department')
    plt.ylabel('Number of Reports')
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
        SELECT id, department, district, location, date, description, media, token, status, credibility_score, device_id, timestamp 
        FROM reports
        WHERE id = ?
    """, (report_id,))
    report = cursor.fetchone()
    conn.close()

    if not report:
        return "Report not found", 404

    # Load first image and convert to base64
    image_base64 = ""
    if report[6]:  # media
        first_image = report[6].split(",")[0]
        image_path = os.path.abspath(os.path.join("Backend", "media", first_image))
        if os.path.exists(image_path):
            with open(image_path, "rb") as img_file:
                image_base64 = base64.b64encode(img_file.read()).decode("utf-8")

    # HTML template
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
        <p><strong>Date:</strong> {{ r[4] }}</p>
        <p><strong>Description:</strong> {{ r[5] }}</p>
        <p><strong>Status:</strong> {{ r[8] }}</p>
        <p><strong>Timestamp:</strong> {{ r[11] }}</p>
        {% if image_base64 %}
        <p><strong>Attached Media:</strong></p>
        <img src="data:image/jpeg;base64,{{ image_base64 }}">
        {% endif %}
    </body>
    </html>
    """

    rendered_html = render_template_string(html_template, r=report, image_base64=image_base64)

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

@app.route("/report/email/<int:report_id>", methods=["POST"])
def send_report_email(report_id):
    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()
    cursor.execute("""
        SELECT id, department, district, location, date, description, media
        FROM reports
        WHERE id = ?
    """, (report_id,))
    report = cursor.fetchone()
    conn.close()

    if not report:
        return "Report not found", 404

    image_base64 = ""
    if report[6]:  # media
        first_image = report[6].split(",")[0]
        image_path = os.path.abspath(os.path.join("Backend", "media", first_image))
        if os.path.exists(image_path):
            with open(image_path, "rb") as img_file:
                image_base64 = base64.b64encode(img_file.read()).decode("utf-8")

    # Email PDF HTML template
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
        <p><strong>Date:</strong> {{ r[4] }}</p>
        <p><strong>Description:</strong> {{ r[5] }}</p>
        {% if image_base64 %}
        <p><strong>Attached Media:</strong></p>
        <img src="data:image/jpeg;base64,{{ image_base64 }}">
        {% endif %}
    </body>
    </html>
    """

    rendered_html = render_template_string(html_template, r=report, image_base64=image_base64)
    pdf_buffer = io.BytesIO()
    pisa.CreatePDF(rendered_html, dest=pdf_buffer)
    pdf_buffer.seek(0)

    EMAIL_ADDRESS = "bhrastabusters@gmail.com"
    EMAIL_PASSWORD = "evnt auip hqrj gybn"  # Use environment variables in production
    TO_EMAIL = "abhitml4@gmail.com"

    msg = EmailMessage()
    msg['Subject'] = f"Corruption Report ID {report[0]}"
    msg['From'] = EMAIL_ADDRESS
    msg['To'] = TO_EMAIL
    msg.set_content("Please find the attached corruption report submitted via BhrastaBusters.")

    msg.add_attachment(pdf_buffer.read(), maintype='application', subtype='pdf', filename=f'report_{report_id}.pdf')

    try:
        with smtplib.SMTP_SSL('smtp.gmail.com', 465) as smtp:
            smtp.login(EMAIL_ADDRESS, EMAIL_PASSWORD)
            smtp.send_message(msg)
        return f" Report {report_id} emailed to {TO_EMAIL}!"
    except Exception as e:
        return f"Failed to send email: {str(e)}", 500

if __name__ == '__main__':
    app.run(debug=True, port=5001)  
