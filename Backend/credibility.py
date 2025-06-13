import joblib
import re 
from langdetect import detect
from googletrans import Translator
from indic_transliteration.sanscript import transliterate, ITRANS, DEVANAGARI

vectorizer = joblib.load("Backend/ml/vectorizer.pkl")
model = joblib.load("Backend/ml/model.pkl")
translator = Translator()

common_nepali_words = [
    "paisa","rupiya", "paise", "rupaye", "rupiya", "rupaiya", "rupaiye","ghus","ghuskhori","le","diyo","diye","sarkari",
    "sarkari kaam","sarkari karyalaya","sarkari karmachari","sarkari adhikari","karmachari","adhikari","karyalaya","karyalayama",
    "karyalayako","karyalayama ko","karyalayako kaam","maghcha","magchha","magyo","maghdai","kaam","kaam","khayo","lagyo","lagcha",
    "ghatana","ghatna","hunchha","huncha","hunechha","ghhus","ghus khori","loksewa","parhari"
]

def is_romanized_nepali(text):
    count = sum(1 for word in common_nepali_words if word in text.lower())
    return count >= 2

def smart_translate(text):
    try:
        lang = detect(text)
        if lang == 'ne':
            translated = translator.translate(text, dest='en').text 
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
    
def clean_text(text):
    text = text.lower()
    text = re.sub(r'\d+', '<num>', text)  
    text = re.sub(r'[^a-zA-Z\s]', '', text)
    return text.strip()

def score_text(text):
    text = smart_translate(text)
    cleaned = clean_text(text)
    vec = vectorizer.transform([cleaned])

    if vec.nnz == 0:
        return 0.0
    
    prob = model.predict_proba(vec)[0][1]
    return round(prob, 2)
    
