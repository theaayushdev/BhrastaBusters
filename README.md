# BhrastaBusters

**BhrastaBusters** is a mobile application built using **Flutter** that allows users to report corruption anonymously and securely.  
It features:

- 📝 Corruption report submission with images
- 📍 Department and district selector
- 📞 Emergency contact info
- 🧠 Awareness resources
- 🛠️ Admin panel (built using Python & Flask) to view reports and stats

---

## ⚙️ Getting Started

Follow these simple steps to run the Flutter app and Python backend locally.

---

🔧 1. Clone the Repository

```bash
git clone https://github.com/theaayushdev/BhrastaBusters.git
cd BhrastaBusters
```
###  Set up Flutter app
```bash
flutter pub get
flutter run
```
### Set Up the Python Backend (Admin Panel)
cd Backend
# For Linux/macOS
```bash
python3 -m venv venv
source venv/bin/activate
```
```bash
# For Windows
python -m venv venv
venv\Scripts\activate
```

```bash
pip install -r requirements.txt
```

```bash
python admin.py
```
