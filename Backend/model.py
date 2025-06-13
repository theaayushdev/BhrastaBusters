import sqlite3

conn = sqlite3.connect("Backend/db.sqlite3", check_same_thread=False)
cursor = conn.cursor()

cursor.execute(""" 
CREATE TABLE IF NOT EXISTS reports (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            department TEXT,
            location TEXT,
            description TEXT,
            media TEXT,
            token TEXT,
            status TEXT,
            credibility_score REAL,
            device_id TEXT,
            timestamp TEXT
 )
""")

conn.commit()