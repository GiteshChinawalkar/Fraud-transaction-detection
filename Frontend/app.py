from flask import Flask, render_template, redirect, url_for, request, session, g, jsonify
from flask_login import UserMixin, LoginManager, login_user, login_required, logout_user
from flask_wtf import FlaskForm
from wtforms import StringField, PasswordField, SubmitField, IntegerField, SelectField
from wtforms.validators import InputRequired, Length, ValidationError
from flask_bcrypt import Bcrypt
from sqlalchemy import create_engine, text
import joblib
import numpy as np
from datetime import datetime, timedelta
import random


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

class ClientForm(FlaskForm):
    ssn = StringField(validators=[InputRequired(),
                                  Length(min=11, max=11)],
                      render_kw={"placeholder": "ssn"})

    fname = StringField(validators=[InputRequired(),
                                    Length(min=3, max=50)],
                        render_kw={"placeholder": "First Name"})
    lname = StringField(validators=[InputRequired(),
                                    Length(min=3, max=50)],
                        render_kw={"placeholder": "Last Name"})
    dob = StringField(validators=[InputRequired(),
                                  Length(min=3, max=50)],
                      render_kw={"placeholder": "Date of birth"})
    email = StringField(validators=[InputRequired(),
                                    Length(min=3, max=50)],
                        render_kw={"placeholder": "email"})
    phone = StringField(validators=[InputRequired(),
                                    Length(min=3, max=50)],
                        render_kw={"placeholder": "phone"})
    street = StringField(validators=[InputRequired(),
                                     Length(min=3, max=50)],
                         render_kw={"placeholder": "street address"})
    city = StringField(validators=[InputRequired(),
                                   Length(min=3, max=50)],
                       render_kw={"placeholder": "city"})
    state = StringField(validators=[InputRequired(),
                                    Length(min=3, max=50)],
                        render_kw={"placeholder": "state"})

    submit = SubmitField('Submit')
    
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
            conn.commit()
        except IntegrityError:
            conn.rollback() 
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
        if not user:
            # User already exists
            return render_template('index.html', form=form, error="User does not exists.")

        print("USER", user)
        print(user[2])

        if user and (user[2] == form.password.data):
            user_obj = Userdata(user[0], user[1], user[2], user[3])
            login_user(user_obj)
            session['email'] =user[3]
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
        from_acc = str(request.form['from_acc'])
        to_acc = str(request.form['to_acc'])
        amount = float(request.form['amount'])
        transaction_type = request.form['type']
        print(from_acc)

        # Fetch accounts
        sender_query = text("SELECT * FROM bank_v3.bank_account WHERE acc_no = :from_acc")
        sender_account = conn.execute(sender_query, {"from_acc": from_acc}).fetchone()
        recipient_account = None
        if to_acc:
            recipient_query = text("SELECT * FROM bank_v3.bank_account WHERE acc_no = :to_acc")
            recipient_account = conn.execute(recipient_query, {"to_acc": to_acc}).fetchone()

        if not sender_account or (to_acc and not recipient_account):
            return "Error: Invalid account numbers", 400

        # Perform transaction logic
        old_balance_org = sender_account[3] # taking balance from fetched row tuple
        new_balance_org = old_balance_org - amount if transaction_type == 'debit' else old_balance_org + amount
        old_balance_dest = recipient_account[3] if recipient_account else 0
        new_balance_dest = old_balance_dest + amount if recipient_account else 0

        # ML Prediction
        # ML Prediction Step Calculation
        step = (timedelta(days=30).total_seconds() // 3600) % 744
        input_data = np.array([[step, old_balance_org, new_balance_org, new_balance_dest,
                                new_balance_org - old_balance_org, new_balance_dest - old_balance_dest,
                                1 if transaction_type == 'CASH-IN' else 0]])
        is_fraud = model.predict(input_data)[0]

        if is_fraud == 1:
            return redirect(url_for('transaction_fail'))

        # Update balances
        update_sender = text("UPDATE bank_v3.bank_account SET balance = :new_balance WHERE acc_no = :from_acc")
        conn.execute(update_sender, {"new_balance": new_balance_org, "from_acc": from_acc})

        if recipient_account:
            update_recipient = text("UPDATE  bank_v3.bank_account SET balance = :new_balance WHERE acc_no = :to_acc")
            conn.execute(update_recipient, {"new_balance": new_balance_dest, "to_acc": to_acc})

        return redirect(url_for('transaction_success'))
    return render_template('transaction.html')

@app.route('/transaction_success')
def transaction_success():
    return render_template('transaction_success.html')

@app.route('/transaction_fail')
def transaction_fail():
    return render_template('transaction_fail.html')

def generate_unique_account_number():
    """Generate a unique 10-digit account number."""
    while True:
        account_number = "-".join(
        str(random.randint(1000, 9999)) for _ in range(4)
    )

        query = text("SELECT 1 FROM bank_v3.bank_account WHERE acc_no = :account_number")


        result = conn.execute(query, {"account_number": account_number}).fetchone()
        if not result:
            return account_number

@app.route('/new_client', methods=['GET', 'POST'])
@login_required
def new_client():
    form = ClientForm()
    if request.method == 'POST':
        try:
            # Generate a unique account number
            account_number = generate_unique_account_number()
            query = text("""
                INSERT INTO bank_v3.client (ssn, fname, lname, dob, email, phone, street, city, state)
                VALUES (:ssn, :fname, :lname, :dob, :email, :phone, :street, :city, :state)
            """)
            conn.execute(query, {
                "ssn": form.ssn.data,
                "fname": form.fname.data,
                "lname": form.lname.data,
                "dob": form.dob.data,
                "email": form.email.data,
                "phone": form.phone.data,
                "street": form.street.data,
                "city": form.city.data,
                "state": form.state.data
            })

            # Insert the generated account number into the account table
            account_query = text("""
                INSERT INTO bank_v3.bank_account (acc_no, ssn, balance, acc_type)
                VALUES (:account_number, :ssn, :balance, :account_type)
            """)
            conn.execute(account_query, {
                "account_number": account_number,
                "ssn": form.ssn.data,
                "balance": 0.0,  # Default balance for a new account
                "account_type": "Savings"  # Default account type
            })

            conn.commit()
            return redirect(url_for('dashboard'))
            
        except Exception as e:
            conn.rollback() 
            print(f"Error inserting client: {e}")
            return render_template('new_client.html', form=form, error="Error adding client. Please try again.")
    return render_template('new_client.html', form=form)



if __name__ == '__main__':
    app.run(debug=True)
