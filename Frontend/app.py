from flask import Flask, render_template, redirect, url_for, request, session, g
from flask_login import UserMixin, LoginManager, login_user, login_required, logout_user
from flask_wtf import FlaskForm
from wtforms import StringField, PasswordField, SubmitField, IntegerField, SelectField
from wtforms.validators import InputRequired, Length, ValidationError
from flask_bcrypt import Bcrypt
from sqlalchemy import create_engine, text
import joblib
import numpy as np
from datetime import datetime, timedelta

# Load Machine Learning Model
model = joblib.load('../ML/model_cycle1.joblib')

app = Flask(__name__)

# Configuration
app.config['SECRET_KEY'] = 'thisisasecretkey'

# DATABASEURI = 'postgresql://postgres:admin123@localhost:5432/bank_data?options=-csearch_path=bank_v3'
DATABASEURI = 'postgresql://postgres:admin123@localhost:5432/bank_data'

engine = create_engine(DATABASEURI)
conn = engine.connect()
# bcrypt = Bcrypt(app)

# Login Manager
login_manager = LoginManager()
login_manager.init_app(app)
login_manager.login_view = 'login'

# Models replaced with raw SQL
@login_manager.user_loader
def load_user(user_id):
    query = text("SELECT * FROM bank_v3.userdata WHERE id = :id")
    user = conn.execute(query, {"id": user_id}).fetchone()
    if user:
        return  Userdata(user[0], user[1], user[2], user[3])
    return None

class Userdata(UserMixin):
    def __init__(self, id, username, password, email):
        self.id = id
        self.username = username
        self.password = password
        self.email = email

# Forms
class RegisterForm(FlaskForm):
    username = StringField('username', validators=[InputRequired(), Length(min=4, max=20)])
    password = PasswordField('Password', validators=[InputRequired(), Length(min=8, max=20)])
    email = StringField('email', validators=[InputRequired(), Length(min=4, max=100)])
    submit = SubmitField('Register')

    def validate_username(self, username):
        query = text("SELECT * FROM bank_v3.userdata WHERE username = :username")
        user = conn.execute(query, {"username": username.data}).fetchone()
        if user:
            raise ValidationError('Username already exists.')

class LoginForm(FlaskForm):
    email = StringField('email', validators=[InputRequired(), Length(min=4, max=100)])
    password = PasswordField('Password', validators=[InputRequired(), Length(min=8, max=20)])
    submit = SubmitField('Login')

# Routes
@app.route('/')
def home():
    return render_template('index.html')

@app.route('/register', methods=['GET', 'POST'])
def register():
    form = RegisterForm()
    if request.method == 'POST':
        # Check if the user already exists
        query_check = text("""
            SELECT COUNT(*) FROM bank_v3.Userdata
            WHERE username = :username OR email = :email
        """)
        result = conn.execute(query_check, {"username": form.username.data, "email": form.email.data}).scalar()
        
        if result > 0:
            # User already exists
            return render_template('register.html', form=form, error="Username or email already exists.")

        # Hash the password
        # hashed_password = bcrypt.generate_password_hash(form.password.data).decode('utf-8')
        
        # Insert the new user
        query_insert = text("""
            INSERT INTO bank_v3.Userdata (username, password, email) 
            VALUES (:username, :password, :email)
        """)
        try:
            conn.execute(query_insert, {
                "username": form.username.data,
                "password": form.password.data,
                "email": form.email.data
            })
        except IntegrityError:
            print("fail")
            return render_template('register.html', form=form, error="Error inserting the user. Try again.")

        return redirect(url_for('login'))
    
    return render_template('register.html', form=form)


@app.route('/login', methods=['GET', 'POST'])
def login():
    form = LoginForm()
    if request.method == 'POST':
        query = text("SELECT * FROM bank_v3.Userdata WHERE email = :email")
        user = conn.execute(query, {"email": form.email.data}).fetchone()
        print("USER", user)
        print(user[2])
        if user and (user[2] == form.password.data):
            user_obj = Userdata(user[0], user[1], user[2], user[3])
            login_user(user_obj)
            return redirect(url_for('dashboard'))
    return render_template('index.html', form=form)

@app.route('/dashboard')
@login_required
def dashboard():
    return render_template('home_page.html')

@app.route('/logout')
@login_required
def logout():
    logout_user()
    return redirect(url_for('home'))

# Transaction Route Example
@app.route('/transaction', methods=['GET', 'POST'])
@login_required
def transaction():
    if request.method == 'POST':
        acc_no = request.form['acc_no']
        to_acc = request.form['to_acc']
        amount = float(request.form['amount'])
        transaction_type = request.form['type']

        # Fetch accounts
        sender_query = text("SELECT * FROM Account WHERE acc_no = :acc_no")
        sender_account = conn.execute(sender_query, {"acc_no": acc_no}).fetchone()
        recipient_account = None
        if to_acc:
            recipient_query = text("SELECT * FROM Account WHERE acc_no = :to_acc")
            recipient_account = conn.execute(recipient_query, {"to_acc": to_acc}).fetchone()

        if not sender_account or (to_acc and not recipient_account):
            return "Error: Invalid account numbers", 400

        # Perform transaction logic
        old_balance_org = sender_account['balance']
        new_balance_org = old_balance_org - amount if transaction_type == 'debit' else old_balance_org + amount
        old_balance_dest = recipient_account['balance'] if recipient_account else 0
        new_balance_dest = old_balance_dest + amount if recipient_account else 0

        # ML Prediction
        step = (datetime.now() - timedelta(days=30)).total_seconds() // 3600 % 744
        input_data = np.array([[step, old_balance_org, new_balance_org, new_balance_dest,
                                new_balance_org - old_balance_org, new_balance_dest - old_balance_dest,
                                1 if transaction_type == 'credit' else 0]])
        is_fraud = model.predict(input_data)[0]

        if is_fraud == 1:
            return redirect(url_for('transaction_fail'))

        # Update balances
        update_sender = text("UPDATE Account SET balance = :new_balance WHERE acc_no = :acc_no")
        conn.execute(update_sender, {"new_balance": new_balance_org, "acc_no": acc_no})

        if recipient_account:
            update_recipient = text("UPDATE Account SET balance = :new_balance WHERE acc_no = :acc_no")
            conn.execute(update_recipient, {"new_balance": new_balance_dest, "acc_no": to_acc})

        return redirect(url_for('transaction_success'))
    return render_template('transaction.html')

@app.route('/transaction_success')
def transaction_success():
    return render_template('transaction_success.html')

@app.route('/transaction_fail')
def transaction_fail():
    return render_template('transaction_fail.html')

if __name__ == '__main__':
    app.run(debug=True)
