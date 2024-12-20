
# **BankAG Fraud Detection and Management System**

## **Project Overview**
BankAG is a web-based fraud detection and user management system built with Flask, PostgreSQL, and SQLAlchemy. It includes:
- User registration and login.
- Admin functionality for managing users.
- Fraud detection using a pre-trained machine learning model.
- Transaction management with real-time fraud detection.

---


<img alt="image" src="https://github.com/user-attachments/assets/561b619a-59f3-4112-af5d-24b9dd9fe848" />


## **Table of Contents**
1. [Features](#features)
2. [Tech Stack](#tech-stack)
3. [Setup Instructions](#setup-instructions)
4. [Usage](#usage)
5. [Admin Functionality](#admin-functionality)
6. [File Structure](#file-structure)
7. [Screenshots](#screenshots)

---

## **Features**
- **User Management**:
  - User registration and login with Flask-Login.
  - Admin login with additional privileges to manage users.

- **Transaction Management**:
  - Users can make transactions.
  - Real-time fraud detection powered by a pre-trained ML model.

- **Admin Dashboard**:
  - Admin can delete users.
  - User data displayed in a well-formatted table.

---

## **Tech Stack**
- **Backend**: Flask, SQLAlchemy
- **Database**: PostgreSQL
- **Frontend**: HTML, CSS, JavaScript
- **Machine Learning**: Pre-trained model for fraud detection (`joblib` file)
- **Authentication**: Flask-Login

---

## **Setup Instructions**

### **Prerequisites**
1. Python 3.7 or higher.
2. PostgreSQL installed and running.
3. `pip` (Python package manager) installed.

### **Steps to Run**
1. Clone the repository:
   ```bash
   git clone https://github.com/GiteshChinawalkar/Fraud-transaction-detection
   cd Frontend
   ```

2. Create and activate a virtual environment:
   ```bash
   python3 -m venv venv
   source venv/bin/activate
   ```

3. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```

4. Set up the database:
   - Start PostgreSQL.
   - Create a database named `bank_data`:
     ```sql
     CREATE DATABASE bank_data;
     ```

   - Update the `DATABASEURI` in `app.py`:
     ```python
     DATABASEURI = 'postgresql://<username>:<password>@localhost:5432/bank_data'
     ```

   - Import the required schema or initialize tables as per your requirements.

5. Run the Flask app:
   ```bash
   python app.py
   ```

6. Access the application:
   - Open your browser and navigate to `http://127.0.0.1:5000`.

---

## **Usage**
### **User Registration and Login**
1. Register a new user through the `/register` route.
2. Log in with your credentials on the `/login` page.

### **Transaction**
1. Navigate to the dashboard after logging in.
2. Add new client details or make a new transaction.
3. Fraudulent transactions are flagged and redirected to the fraud alert page.

### **Admin Functionality**
1. Log in with `admin` as the username and password.
2. Access the **Manage Users** section from the admin dashboard.
3. View, and delete users from the system.

---

## **Admin Functionality**

### Admin Login:
- Username: `admin`
- Password: `admin`

### Features:
1. **Manage Users**:
   - View all registered users.
   - Delete any user with a single click.

---

## **File Structure**
```
BankAG/
│
├── static/
│   ├── css/
│   │   └── style.css           # Main stylesheet
│   ├── images/                 # Background and other assets
│
├── templates/
│   ├── index.html              # Login page
│   ├── register.html           # Registration page
│   ├── home_page.html          # Dashboard
│   ├── manage_users.html       # Admin manage users page
│   ├── transaction.html        # Transaction page
│   ├── transaction_success.html# Successful transaction
│   ├── transaction_fail.html   # Failed transaction
│
├── app.py                      # Main Flask application
├── requirements.txt            # Python dependencies
├── README.md                   # Project instructions
```

---

## **Future Enhancements**
- Implement email notifications for flagged transactions.
- Add graphs and charts to display transaction history.
- Enhance security with 2-factor authentication.

---
