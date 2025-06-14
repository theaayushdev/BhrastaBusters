import joblib
import re 
from langdetect import detect
from googletrans import Translator
from indic_transliteration.sanscript import transliterate, ITRANS, DEVANAGARI
import csv

vectorizer = joblib.load("Backend/ml/vectorizer.pkl")
model = joblib.load("Backend/ml/model.pkl")
translator = Translator()

common_nepali_words = [
    "paisa","rupiya", "paise", "rupaye", "rupiya", "rupaiya", "rupaiye","ghus","ghuskhori","le","diyo","diye","sarkari",
    "sarkari kaam","sarkari karyalaya","sarkari karmachari","sarkari adhikari","karmachari","adhikari","karyalaya","karyalayama",
    "karyalayako","karyalayama ko","karyalayako kaam","maghcha","magchha","magyo","maghdai","kaam","kaam","khayo","lagyo","lagcha",
    "ghatana","ghatna","hunchha","huncha","hunechha","ghhus","ghus khori","loksewa","prahari"
]

def load_common_names(csv_file="Backend/ml/common_names.csv"):
    name = set()
    try:
        with open(csv_file, 'r', encoding='utf-8') as file:
            reader = csv.DictReader(file)
            for row in reader:
                if row:  
                    name.add(row["name"].strip().lower())

    except Exception as e:
       print("Error loading names:", e)
       
    return name
    
common_names = load_common_names()


def is_romanized_nepali(text):
    count = sum(1 for word in common_nepali_words if word in text.lower())
    return count >= 2

def smart_translate(text):
    try:
        lang = detect(text)
        if lang == "ne":
            translated = translator.translate(text, dest="en").text
            return translated

        # If English but contains Nepali words
        if lang == "en" and is_romanized_nepali(text):
            try:
                devanagari = transliterate(text, ITRANS, DEVANAGARI)
                translated = translator.translate(devanagari, dest="en").text
                return translated
            except Exception :
                 pass

        # If just English 
        return translator.translate(text, dest="en").text

    except Exception:
        return text  
    
def extract_money_amount(text):
    text = text.lower().replace(",", "")
    matches = []

    # Match Rs. 1000, Rs 50000
    rs_amounts = re.findall(r'rs\.?\s?(\d{3,8})', text)
    matches += [int(a) for a in rs_amounts]

    # Match raw numbers like 5000 or 10000
    raw_numbers = re.findall(r'\b(\d{4,8})\b', text)
    matches += [int(n) for n in raw_numbers]

    units = {
        "crore": 10000000,
        "lakh": 100000,
        "thousand": 1000,
        "million": 1000000
    }

    for unit, multiplier in units.items():
        pattern = rf'\b(\d+)\s*{unit}\b'
        found = re.findall(pattern, text)
        matches += [int(num) * multiplier for num in found]

    return max(matches) if matches else 0

def calculate_money_bonus(amount):
    if amount == 0:
        return 0.0
    return min(amount / 1_000_000, 0.2)  


def detect_name(text):
    text = text.lower()
    return any(name in text for name in common_names)

def clean_text(text):
    text = text.lower()
    text = re.sub(r'\d+', '<num>', text)  
    text = re.sub(r'[^a-zA-Z\s]', '', text)
    return text.strip()

def score_text(text):
    original = text
    text = smart_translate(text)
    cleaned = clean_text(text)
    vec = vectorizer.transform([cleaned])

    if vec.nnz == 0:
        return 0.0
    
    prob = model.predict_proba(vec)[0][1]

    money_amount = extract_money_amount(original)
    bonus_money = calculate_money_bonus(money_amount)
    bonus_name = 0.1 if detect_name(original) else 0.0

    final_score = prob + bonus_money + bonus_name

    return round(min(final_score, 1.0), 2)
    

if __name__ == "__main__":
    report = input("Enter your report: ")
    score = score_text(report)

    print(f"Credibility score: {score}")
