# 🚨 BhrastaBusters

**BhrastaBusters** is a mobile application built using **Flutter** that allows users to report corruption anonymously and securely. It includes features like report submission with images, department and district selection, emergency contacts, and an admin panel built using **Python (Flask)** for visualizing reports.

---

## ⚙️ Installing Dependencies

### 🔹 1. Clone the Repository

```bash
git clone https://github.com/theaayushdev/BhrastaBusters.git
cd BhrastaBusters

flutter pub get

flutter run

cd Backend

python3 -m venv venv
source venv/bin/activate  # For Linux/macOS
venv\Scripts\activate     # For Windows

pip install -r requirements.txt

python admin.py
