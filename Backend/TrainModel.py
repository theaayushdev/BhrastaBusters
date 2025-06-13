import pandas as pd 
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.linear_model import LogisticRegression
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score
import re
import joblib

df = pd.read_csv('TrainModel.csv')

#cleaning the text
def clean_text(text):
    text = text.lower()
    text = re.sub(r'\d+', '<num>', text)  
    text = re.sub(r'[^a-zA-Z\s]', '', text)
    return text.strip()

df[clean_text] = df['text'].apply(clean_text)

#converting data to numerical format
vec = TfidfVectorizer(ngram_range=(1, 2), max_features=8000)
X = vec.fit_transform(df['clean_text'])
Y = df['label']

#splitting the data 
X_train, X_test, Y_train, Y_test = train_test_split(X, Y, test_size=0.2, random_state=42)

#training the model
model = LogisticRegression(class_weight="balanced", max_iter=1000)
model.fit(X_train, Y_train)