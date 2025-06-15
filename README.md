### BhrastaBusters
BhrastaBuster* is an anonymous corruption reporting tool that allows users to securely submit reports with descriptions, images/videos, and department details. Reports are analyzed for credibility using a machine learning model, and admins can monitor, update, and export reports via a dashboard.



## 🚀 Features

### 🧑‍💻 User (Flutter App)
- Generate a unique report token.
- Submit corruption reports anonymously.
- Attach image or video evidence.
- Check report status using the token.
- 
### 🖥️ Admin (Flask Web App)
- View all reports in a clean table.
- Filter reports by department.
- View and download attached media.
- Update status of reports (e.g. pending, reviewed, solved).
- Generate PDF reports.
- Email individual report PDFs.
- View department/district-wise report graphs.

### 🧠 Machine Learning
- Logistic Regression model trained on a labeled dataset.
- TF-IDF vectorization using unigrams + bigrams.
- Reports are scored for *credibility* (0–1).
- Score is saved but hidden from users.

## Getting Started

Follow these simple steps to run the Flutter app and Python backend locally.

---

###1. Clone the Repository

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
```bash
cd Backend
```
### For Linux/macOS
```bash
python3 -m venv venv
source venv/bin/activate
```
### For Windows
```bash

python -m venv venv
venv\Scripts\activate
```

```bash
pip install -r requirements.txt
```

```bash
python admin.py
```
