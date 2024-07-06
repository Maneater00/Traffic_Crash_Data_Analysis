import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LogisticRegression
from sklearn.tree import DecisionTreeClassifier
from sklearn.metrics import accuracy_score, classification_report, confusion_matrix
import seaborn as sns
import matplotlib.pyplot as plt

# List of datasets to be imported
datasets = [
    'accident', 'cevent', 'crashrf', 'damage', 'distract', 'drimpair', 'driverrf',
    'drugs', 'factor', 'maneuver', 'nmcrash', 'nmdistract', 'nmimpair', 'nmprior',
    'parkwork', 'pbtype', 'person', 'personrf', 'pvehiclesf', 'race', 'safetyeq',
    'vehicle', 'vehiclesf', 'vevent', 'violatn', 'vision', 'vpicdecode', 'vpictrailerdecode',
    'vsoe', 'weather', 'miacc', 'midrvacc', 'miper'
]

# Base URL for the raw content in your GitHub repository
base_url = "https://github.com/Maneater00/Traffic_Crash_Data_Analysis/new/main"

# Function to load datasets from GitHub
def load_datasets(base_url, datasets):
    data_frames = {}
    for dataset in datasets:
        url = f"{base_url}{dataset}.csv"  # assuming datasets are stored as .csv
        df = pd.read_csv(url)
        data_frames[dataset] = df
    return data_frames

# Load all datasets
data_frames = load_datasets(base_url, datasets)

# Example: Using only 'accident' and 'person' datasets for model development
accident_df = data_frames['accident']
person_df = data_frames['person']

# Data Preprocessing (example preprocessing steps)
# Merge 'accident' and 'person' datasets on 'caseid'
merged_df = pd.merge(accident_df, person_df, on='caseid')

# Handle missing values (fill with mean for numerical columns)
merged_df.fillna(merged_df.mean(), inplace=True)

# Convert categorical variables to dummy/indicator variables
merged_df = pd.get_dummies(merged_df, drop_first=True)

# Define feature variables and target variable (example target: 'severe_crash')
# Assuming 'severe_crash' is a binary column indicating severe crashes
X = merged_df.drop('severe_crash', axis=1)  # Features
y = merged_df['severe_crash']  # Target variable

# Split the data into training and testing sets
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Logistic Regression Model
log_reg = LogisticRegression(max_iter=1000)
log_reg.fit(X_train, y_train)
y_pred_log_reg = log_reg.predict(X_test)

# Decision Tree Model
tree_clf = DecisionTreeClassifier(random_state=42)
tree_clf.fit(X_train, y_train)
y_pred_tree = tree_clf.predict(X_test)

# Evaluate the models
accuracy_log_reg = accuracy_score(y_test, y_pred_log_reg)
accuracy_tree = accuracy_score(y_test, y_pred_tree)

print("Logistic Regression Accuracy: {:.2f}%".format(accuracy_log_reg * 100))
print("Decision Tree Accuracy: {:.2f}%".format(accuracy_tree * 100))

print("\nLogistic Regression Classification Report:\n", classification_report(y_test, y_pred_log_reg))
print("\nDecision Tree Classification Report:\n", classification_report(y_test, y_pred_tree))

# Confusion Matrix
conf_matrix_log_reg = confusion_matrix(y_test, y_pred_log_reg)
conf_matrix_tree = confusion_matrix(y_test, y_pred_tree)

# Plotting the Confusion Matrix
plt.figure(figsize=(14, 6))

plt.subplot(1, 2, 1)
sns.heatmap(conf_matrix_log_reg, annot=True, fmt='d', cmap='Blues')
plt.title('Logistic Regression Confusion Matrix')
plt.xlabel('Predicted')
plt.ylabel('Actual')

plt.subplot(1, 2, 2)
sns.heatmap(conf_matrix_tree, annot=True, fmt='d', cmap='Blues')
plt.title('Decision Tree Confusion Matrix')
plt.xlabel('Predicted')
plt.ylabel('Actual')

plt.tight_layout()
plt.show()
