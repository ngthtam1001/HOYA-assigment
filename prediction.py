import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestRegressor
from sklearn.metrics import mean_absolute_error, mean_squared_error
import matplotlib.pyplot as plt

# Load and prepare data
def load_data(file_path):
    df = pd.read_csv(file_path)
    df['date'] = pd.to_datetime(df['date'])
    df.set_index('date', inplace=True)
    return df

# Feature engineering
def engineer_features(df):
    df['month'] = df.index.month
    df['quarter'] = df.index.quarter
    df['year'] = df.index.year
    df['sales_lag_1'] = df['sales'].shift(1)
    df['sales_lag_2'] = df['sales'].shift(2)
    df['sales_rolling_mean'] = df['sales'].rolling(window=3).mean()
    return df

# Train model
def train_model(X_train, y_train):
    model = RandomForestRegressor(n_estimators=100, random_state=42)
    model.fit(X_train, y_train)
    return model

# Evaluate model
def evaluate_model(model, X_test, y_test):
    predictions = model.predict(X_test)
    mae = mean_absolute_error(y_test, predictions)
    rmse = np.sqrt(mean_squared_error(y_test, predictions))
    return mae, rmse

# Main function
def main():
    # Load data
    df = load_data('sales_data.csv')
    
    # Engineer features
    df = engineer_features(df)
    
    # Prepare features and target
    features = ['month', 'quarter', 'year', 'sales_lag_1', 'sales_lag_2', 'sales_rolling_mean']
    X = df.dropna()[features]
    y = df.dropna()['sales']
    
    # Split data
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, shuffle=False)
    
    # Train model
    model = train_model(X_train, y_train)
    
    # Evaluate model
    mae, rmse = evaluate_model(model, X_test, y_test)
    print(f"MAE: {mae:.2f}")
    print(f"RMSE: {rmse:.2f}")
    
    # Feature importance
    feature_importance = pd.DataFrame({'feature': features, 'importance': model.feature_importances_})
    feature_importance = feature_importance.sort_values('importance', ascending=False)
    print("\nFeature Importance:")
    print(feature_importance)
    
    # Plot actual vs predicted
    plt.figure(figsize=(12,6))
    plt.plot(y_test.index, y_test.values, label='Actual')
    plt.plot(y_test.index, model.predict(X_test), label='Predicted')
    plt.legend()
    plt.title('Actual vs Predicted Sales')
    plt.show()

if __name__ == "__main__":
    main()