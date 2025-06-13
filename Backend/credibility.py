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

