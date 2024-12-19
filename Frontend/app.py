from flask import Flask, render_template, url_for, redirect, request
from flask_sqlalchemy import SQLAlchemy
from flask_login import UserMixin, login_user, LoginManager, login_required, logout_user, current_user
from flask_wtf import FlaskForm
from wtforms import StringField, PasswordField, SubmitField, IntegerField
from wtforms.validators import InputRequired, Length, ValidationError
from flask_bcrypt import Bcrypt
from sqlalchemy.ext.automap import automap_base
import pickle
import numpy as np
import mysql.connector
import joblib
from datetime import datetime, timedelta

model = joblib.load('../ML/model_cycle1.joblib')

app = Flask(__name__)
app.config[
    'SQLALCHEMY_DATABASE_URI'] = 'mysql://root:password123@localhost/BANK2'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['SECRET_KEY'] = 'thisisasecretkey'
db = SQLAlchemy(app)
bcrypt = Bcrypt(app)

app.app_context().push()
Base = automap_base()
Base.prepare(db.engine, reflect=True)
client = Base.classes.client


app.app_context().push()

login_manager = LoginManager()
login_manager.init_app(app)
login_manager.login_view = 'login'


@login_manager.user_loader
def load_user(user_id):
    return User.query.get(int(user_id))


class User(db.Model, UserMixin):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(20), nullable=False, unique=True)
    password = db.Column(db.String(80), nullable=False)

class Account(db.Model):
    __tablename__ = 'accounts'
    #gives the account number and get the balance from db
    acc_no = db.Column(db.String(20), primary_key=True)
    balance = db.Column(db.Float, nullable=False)

class TransactionForm(FlaskForm):
    acc_no = StringField(
        validators=[InputRequired()],
        render_kw={"placeholder": "Enter Your Account Number"})
    type = StringField(validators=[InputRequired()],
                       render_kw={"placeholder": "Enter type of transfer"})
    amount = IntegerField(
        validators=[InputRequired()],
        render_kw={"placeholder": "Enter Amount to be transferred"})
    old_bal = IntegerField(validators=[InputRequired()],
                           render_kw={"placeholder": "Enter your balance"})
    to_acc = StringField(validators=[InputRequired()],
                         render_kw={
                             "placeholder":
                             "Enter Account number you'd like to transfer to"
                         })
    # new_bal = (old_bal - amount)

    submit = SubmitField('Submit')


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

class RegisterForm(FlaskForm):
    username = StringField(validators=[InputRequired(),
                                       Length(min=4, max=20)],
                           render_kw={"placeholder": "Username"})

    password = PasswordField(
        validators=[InputRequired(), Length(min=8, max=20)],
        render_kw={"placeholder": "Password"})

    submit = SubmitField('Register')

    def validate_username(self, username):
        existing_user_username = User.query.filter_by(
            username=username.data).first()
        if existing_user_username:
            raise ValidationError(
                'That username already exists. Please choose a different one.')


class LoginForm(FlaskForm):
    username = StringField(validators=[InputRequired(),
                                       Length(min=4, max=20)],
                           render_kw={"placeholder": "Username"})

    password = PasswordField(
        validators=[InputRequired(), Length(min=8, max=20)],
        render_kw={"placeholder": "Password"})

    submit = SubmitField('Login')


@app.route('/')
def home():
    return render_template('home.html')


@app.route('/login', methods=['GET', 'POST'])
def login():
    form = LoginForm()
    if form.validate_on_submit():
        user = User.query.filter_by(username=form.username.data).first()
        if user:
            if bcrypt.check_password_hash(user.password, form.password.data):
                login_user(user)
                return redirect(url_for('dashboard'))
    return render_template('login.html', form=form)


@app.route('/dashboard', methods=['GET', 'POST'])
@login_required
def dashboard():
    return render_template('dashboard.html')


@app.route('/logout', methods=['GET', 'POST'])
@login_required
def logout():
    logout_user()
    return redirect(url_for('login'))


@app.route('/new_client', methods=['GET', 'POST'])
def new_client():
    form = ClientForm()

    if form.validate_on_submit():
        new_client = client(ssn=form.ssn.data,
                            Fname=form.fname.data,
                            Lname=form.lname.data,
                            DOB=form.dob.data,
                            email=form.email.data,
                            phone=form.phone.data,
                            street=form.street.data,
                            city=form.city.data,
                            state=form.state.data)
        db.session.add(new_client)
        db.session.commit()
        return redirect(url_for('dashboard'))
    return render_template('new_client.html', form=form)


@app.route('/trans_success', methods=['GET', 'POST'])
def success():
    return render_template('trans_success.html')


@app.route('/register', methods=['GET', 'POST'])
def register():
    form = RegisterForm()

    if form.validate_on_submit():
        hashed_password = bcrypt.generate_password_hash(form.password.data)
        new_user = User(username=form.username.data, email=request.form['email'],password=hashed_password)
        db.session.add(new_user)
        db.session.commit()
        return redirect(url_for('login'))

    return render_template('register.html', form=form)

@app.route('/fraud', methods=['GET'])
def fraud():
    return render_template('transaction_fail.html') 


@app.route('/transaction', methods=['GET', 'POST'])
def transaction():
    if request.method == 'POST':
        # Get form data
        acc_no = request.form['acc_no']
        to_acc = request.form['to_acc']
        amount = float(request.form['amount'])
        transaction_type = request.form['type']
        
        # Fetch balances from the database
        sender_account = Account.query.filter_by(acc_no=acc_no).first()
        recipient_account = Account.query.filter_by(acc_no=to_acc).first()

        if not sender_account or not recipient_account:
            return "Error: Invalid account numbers", 400
        
        transaction_time = datetime.now()
        simulation_start = datetime.now() - timedelta(days=30)
        step = (transaction_time - simulation_start).total_seconds() // 3600 
        step = int(step) % 744 
        # Calculate old and new balances
        oldbalance_org = sender_account.balance
        newbalance_org = oldbalance_org - amount
        oldbalance_dest = recipient_account.balance
        newbalance_dest = oldbalance_dest + amount
        diff_new_old_balance = newbalance_org - oldbalance_org
        diff_new_old_destiny = newbalance_dest - oldbalance_dest
        type_transfer = 1 if transaction_type.upper() == "TRANSFER" else 0
        input_data = np.array([[
            step,
            oldbalance_org,
            newbalance_org,
            newbalance_dest,
            diff_new_old_balance,
            diff_new_old_destiny,
            type_transfer
        ]])

        # Make prediction
        is_fraud = model.predict(input_data)[0]

        # Redirect based on prediction
        if is_fraud == 1:
            return redirect(url_for('fraud'))
        else:
            # Update balances in the database
            sender_account.balance = newbalance_org
            recipient_account.balance = newbalance_dest
            db.session.commit()
            return redirect(url_for('success'))

    return render_template('transaction.html')
        
if __name__ == '__main__':
    app.run(debug=True)
