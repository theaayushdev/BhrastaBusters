import pandas as pd 
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.linear_model import LogisticRegression
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score
import re
import joblib

def clean_text(text):
    text = text.lower()
    text = re.sub(r'\d+', '<num>', text)  
    text = re.sub(r'[^a-zA-Z\s]', '', text)
    return text.strip()
