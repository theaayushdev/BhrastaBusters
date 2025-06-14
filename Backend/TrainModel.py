import pandas as pd
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.linear_model import LogisticRegression
import joblib
import re
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score


# Load dataset
df = pd.read_csv("Backend/Trainingdata.csv")

# Clean and preprocess text
def clean_text(text):
    text = text.lower()
    text = re.sub(r'\d+', '<num>', text)  # replace numbers
    text = re.sub(r'[^a-zA-Z0-9\s<>]', '', text)  # remove symbols
    return text.strip()

df["clean_text"] = df["text"].apply(clean_text)

# Convert to TF-IDF vectors using unigrams + bigrams
vec = TfidfVectorizer(ngram_range=(1, 2), max_features=8000)
X = vec.fit_transform(df["clean_text"])
y = df["label"]


# Split into training
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

#train model 
model = LogisticRegression(class_weight="balanced", max_iter=1000)
model.fit(X_train, y_train)

# Evaluate
preds = model.predict(X_test)
print("Accuracy:", accuracy_score(y_test, preds))


#save vectorizer + model
joblib.dump(vec, "ml/vectorizer.pkl")
joblib.dump(model,"ml/model.pkl")



