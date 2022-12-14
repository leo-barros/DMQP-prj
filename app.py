
from flask import Flask, flash, jsonify, redirect, render_template, request, session
from tempfile import mkdtemp
from werkzeug.exceptions import default_exceptions, HTTPException, InternalServerError
from werkzeug.security import check_password_hash, generate_password_hash
from datetime import datetime,date
from flask_session import Session
from flask_mysqldb import MySQL
import uuid
from functools import wraps
from datetime import datetime
# Configure application
app = Flask(__name__)
app.secret_key = 'super secret key'
app.config['SESSION_TYPE'] = 'filesystem'
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = ''
app.config['MYSQL_DB'] = 'booking'
 
mysql = MySQL(app)
# Ensure templates are auto-reloaded
app.config["TEMPLATES_AUTO_RELOAD"] = True
# Ensure responses aren't cached
if app.config["DEBUG"]:
    @app.after_request
    def after_request(response):
        response.headers["Cache-Control"] = "no-cache, no-store, must-revalidate"
        response.headers["Expires"] = 0
        response.headers["Pragma"] = "no-cache"
        return response
#Configure session to use filesystem (instead of signed cookies)

# configure session to use filesystem (instead of signed cookies)
app.config["SESSION_FILE_DIR"] = mkdtemp()
app.config["SESSION_PERMANENT"] = False
app.config["SESSION_TYPE"] = "filesystem"
app.config["PREFERRED_URL_SCHEME"] = 'https'
app.config["DEBUG"] = False
Session(app)

def login_required(f):

    @wraps(f)
    def decorated_function(*args, **kwargs):
        if session.get("user_id") is None:
            return redirect("/login")
        return f(*args, **kwargs)
    return decorated_function

@app.route("/logout")
def logout():
    """Log user out"""

    # Forget any user_id
    session.clear()

    # Redirect user to login form
    return redirect("/")


@app.route("/")
def index():
    cursor = mysql.connection.cursor()
    cursor.execute('''SELECT * FROM movie''')
    query=cursor.fetchall()
    return render_template("home.html",query=query)


@app.route("/login", methods=["GET", "POST"])
def login():
    """Log user in"""

    # Forget any user_id


    # User reached route via POST (as by submitting a form via POST)
    if request.method == "POST":
        password=request.form.get("password")
        username=request.form.get("username")
        # Query database for username
        cursor = mysql.connection.cursor()
        cursor.execute('''SELECT * FROM admins WHERE username=%s''',[username])
        returned_user=cursor.fetchone()
        # Ensure username exists and password is correct
        if not returned_user or not (check_password_hash(returned_user[2], str(password))):
            return render_template("error.html",error="Invalid username and/or password")
        # Remember which user has logged in
        session["user_id"] = returned_user[0]
        # Redirect user to home page
        return redirect("/admin")

    else:
        return render_template("login.html")


@app.route("/register", methods=["GET", "POST"])
@login_required
def register():
    if request.method == "GET":
        return render_template("register.html")
    else:
        username= request.form.get("username")
        password1=request.form.get("password")
        password2=request.form.get("cpassword")
        cursor = mysql.connection.cursor()
        cursor.execute('''SELECT * FROM admins WHERE username=%s''',[username])
        existing_user=cursor.fetchone()
        

        if existing_user:
            return render_template("error.html",error="This username has laready been used for another account. Please use another username.")


        elif password1 != password2:
            return render_template("error.html",error="Passwords do not match")


        else:
            hashed_password=generate_password_hash(password2, method='pbkdf2:sha256', salt_length=8)
            cursor = mysql.connection.cursor()
            cursor.execute('''INSERT INTO admins (username,hash) VALUES(%s,%s)''',(username,hashed_password))
            mysql.connection.commit()
            cursor.execute('''SELECT * FROM admins WHERE username=%s''',[username])
            returned_user=cursor.fetchone()
            session["user_id"] = returned_user[0]
            flash('Registered!')
            cursor.close()
            return redirect("/admin")


@app.route("/admin")
@login_required
def admin():
    if request.method == "GET":
        cursor = mysql.connection.cursor()
        cursor.execute('''SELECT count(mid) FROM movie''')
        movies=cursor.fetchone()[0]
        cursor.execute('''SELECT count(phone) FROM customer''')
        customers=cursor.fetchone()[0]
        cursor.execute('''SELECT count(scr_no) FROM screen''')
        screens=cursor.fetchone()[0]
        cursor.execute('''SELECT count(tic_id) FROM ticket''')
        tickets=cursor.fetchone()[0]
        cursor.execute('''SELECT count(empid) FROM employee''')
        emps=cursor.fetchone()[0]
        cursor.execute('''SELECT count(Dnumber) FROM department''')
        deps=cursor.fetchone()[0]
        cursor.execute('''SELECT count(trid) FROM transaction''')
        trans=cursor.fetchone()[0]
        return render_template("adminpanel.html",movies=movies,customers=customers,tickets=tickets,emps=emps,deps=deps,trans=trans,screens=screens)

        
        
            

@app.route("/addmovie", methods=["GET", "POST"])
def addmovie():
    if request.method == "GET":
        cursor = mysql.connection.cursor()
        cursor.execute('''SELECT scr_no FROM screen ''')
        screens=cursor.fetchall()
        return render_template("addmovie.html",screens=screens)
    else:
        title= request.form.get("title")
        duration_mins= request.form.get("duration_mins")
        screen_no= request.form.get("screen_no")
        rating= request.form.get("rating")
        language= request.form.get("language")
        genre= request.form.get("genre")
        description= request.form.get("description")
        cursor = mysql.connection.cursor()
        cursor.execute(''' INSERT INTO movie (screen_no,duration_mins,rating,title,language,genre,description) VALUES(%s,%s,%s,%s,%s,%s,%s)''',(screen_no,duration_mins,rating,title,language,genre,description))
        mysql.connection.commit()
        cursor.close()
        flash('Movie has been added successfully!')
        return redirect("/")


@app.route("/book/<movieid>", methods=["GET", "POST"]) #this page will display details of the movie and showtimes
def book(movieid):
    if request.method == "GET":
        cursor = mysql.connection.cursor()
        cursor.execute('''SELECT * FROM movie WHERE mid=%s''',movieid)
        movieDetails=cursor.fetchone()
        return render_template("moviedetails.html",movieDetails=movieDetails)
    else:
        mtime= request.form.get("mtime")
        mdate= request.form.get("mdate")
        quantity=request.form.get("quantity")
        return redirect("/bookseats/{}/{}/{}/{}".format(movieid,mdate,mtime,quantity))

@app.route("/bookseats/<movieid>/<date>/<showtime>/<quantity>", methods=["GET", "POST"])
def bookseats(movieid,date,showtime,quantity):
    if request.method == "GET":
        cursor = mysql.connection.cursor()
        cursor.execute('''SELECT screen_no FROM movie WHERE mid=%s''',movieid)
        screenNumber=cursor.fetchone()
        cursor.execute('''SELECT capacity FROM screen WHERE scr_no=%s''',screenNumber)
        capacity=cursor.fetchone()
        cursor.execute('''SELECT seat_no FROM ticket WHERE movie_id=%s AND mtime=%s AND mdate=%s''',(movieid,showtime,date))
        result_tuple=cursor.fetchall()
        taken_seats=[]
        if len(result_tuple) > 0:
            for tuple in result_tuple:
                taken_seats.append(tuple[0])
        else:
            taken_seats=list(result_tuple)
        total_seats=list(range(1,int(capacity[0])+1))
        available_seats=list(set(total_seats).symmetric_difference(taken_seats))
        if len(available_seats) == 0:
            return render_template("error.html")
        else:
            return render_template("bookseats.html",available_seats=available_seats,movieid=movieid,date=date,showtime=showtime,quantity=quantity)
    else:
        seatno=request.form.getlist('seatno')
        return redirect("/transaction/{}/{}/{}/{}/{}".format(movieid,date,showtime,quantity,seatno))

@app.route("/transaction/<movieid>/<date>/<showtime>/<quantity>/<seatno>", methods=["GET", "POST"])
def transact(movieid,date,showtime,quantity,seatno):
    if request.method == "GET":
        amount=int(int(quantity)*200)
        return render_template("transaction.html",movieid=movieid,date=date,showtime=showtime,quantity=quantity,seatno=seatno,transaction_amount=amount)
    else:
        cust_ph=request.form.get("cust_ph")
        mode_of_pay= request.form.get("mode_of_pay")
        cursor = mysql.connection.cursor()
        cursor.execute('''SELECT * FROM customer WHERE phone=%s''',[cust_ph])
        response=cursor.fetchone()
        if response:
            transaction_id=str(uuid.uuid4())[:8]
            noOfTickets=quantity
            price=200
            now = datetime.now()
            formatted_date = now.strftime('%Y-%m-%d')
            formatted_time = now.strftime('%H:%M:%S')
            cursor = mysql.connection.cursor()
            cursor.execute(''' INSERT INTO transaction (trid,no_of_tickets,mode_of_pay,price,tdate,cust_phone,time) VALUES(%s,%s,%s,%s,%s,%s,%s)''',(transaction_id,noOfTickets,mode_of_pay,price,formatted_date,cust_ph,formatted_time))
            mysql.connection.commit()
            seatno=seatno.replace("%20","")
            seatno=seatno.replace("'","")
            seatno=seatno.replace("[","")
            seatno=seatno.replace("]","")
            seatno=seatno.split(",")
            for seat in seatno:
                cursor.execute(''' INSERT INTO ticket (movie_id,seat_no,mtime,mdate,tid) VALUES(%s,%s,%s,%s,%s)''',(movieid,seat,showtime,date,transaction_id))
                mysql.connection.commit()
            cursor.execute(''' SELECT * FROM ticket WHERE tid=%s''',[transaction_id])
            booked_tickets=cursor.fetchall()
            cursor.execute(''' SELECT title,screen_no FROM movie WHERE mid=%s''',[movieid])
            movie_details=cursor.fetchone()
            movie_title=movie_details[0]
            movie_screen=movie_details[1]
            cursor.close()
            flash('Tickets booked successfully!')
            return render_template("generatedtickets.html",tickets=booked_tickets,movie_title=movie_title,movie_screen=movie_screen)
            
        else:
            return render_template("error.html",error="User does not exist. Please sign up before booking")
            cursor.close()
            
        


@app.route("/addscreen", methods=["GET", "POST"])
def addscreen():
    if request.method == "GET":
        return render_template("addscreen.html")
    else:
        floor= request.form.get("floor")
        scr_no= request.form.get("scr_no")
        dimension= request.form.get("dimension")
        capacity= request.form.get("capacity")
        cursor = mysql.connection.cursor()
        cursor.execute(''' INSERT INTO screen (floor,scr_no,dimension,capacity) VALUES(%s,%s,%s,%s)''',(floor,scr_no,dimension,capacity))
        mysql.connection.commit()
        cursor.close()
        flash('Screen has been added successfully!')
        return redirect("/admin")

@app.route("/adddept", methods=["GET", "POST"])
def adddept():
    if request.method == "GET":
        return render_template("adddept.html")
    else:
        type= request.form.get("type")
        cursor = mysql.connection.cursor()
        cursor.execute(''' INSERT INTO department (Dnumber,type) VALUES(%s,%s)''',(0,type))
        mysql.connection.commit()
        cursor.close()
        flash('Department has been added successfully!')
        return redirect("/admin")

@app.route("/addemp", methods=["GET", "POST"])
def addemp():
    if request.method == "GET":
        cursor = mysql.connection.cursor()
        cursor.execute('''SELECT * FROM department''')
        departments=cursor.fetchall()
        return render_template("addemp.html",departments=departments)
    else:
        gender= request.form.get("gender")
        fname= request.form.get("fname")
        lname= request.form.get("lname")
        street= request.form.get("street")
        state= request.form.get("state")
        city= request.form.get("city")
        salary= request.form.get("salary")
        dno= request.form.get("dno")
        cursor = mysql.connection.cursor()
        cursor.execute(''' INSERT INTO employee (gender,fname,lname,street,state,city,salary,dno) VALUES(%s,%s,%s,%s,%s,%s,%s,%s)''',(gender,fname,lname,street,state,city,salary,dno))
        mysql.connection.commit()
        cursor.close()
        flash('employee has been added successfully!')
        return redirect("/admin")

@app.route("/addmaintains", methods=["GET", "POST"])
def addmaintains():
    if request.method == "GET":
        cursor = mysql.connection.cursor()
        cursor.execute('''SELECT scr_no FROM screen''')
        screens=cursor.fetchall()
        cursor1 = mysql.connection.cursor()
        cursor1.execute('''SELECT * FROM department''')
        departments=cursor1.fetchall()
        return render_template("addmaintains.html",screens=screens,departments=departments)
    else:
        dno= request.form.get("dno")
        scr_no= request.form.get("scr_no")
        
        cursor = mysql.connection.cursor()
        cursor.execute(''' INSERT INTO maintains (dno,scr_no) VALUES(%s,%s)''',(dno,scr_no))
        mysql.connection.commit()
        cursor.close()
        flash('maintains relation has been added successfully!')
        return redirect("/admin")

@app.route("/signup", methods=["GET", "POST"])
def signup():
    if request.method == "GET":
        return render_template("signup.html")
    else:
        fname= request.form.get("fname")
        lname= request.form.get("lname")
        bdate=request.form.get("bdate")
        gender=request.form.get("gender")
        phone=request.form.get("cust_ph")
        cursor = mysql.connection.cursor()
        cursor.execute('''SELECT * FROM customer WHERE phone=%s''',[phone])
        response=cursor.fetchone()
        if response:
            return render_template("error.html",error="User with the same phone no. already exists")
            cursor.close()
        else:
            cursor.execute(''' INSERT INTO customer (phone,gender,fname,lname,bdate) VALUES(%s,%s,%s,%s,%s)''',(phone,gender,fname,lname,bdate))
            mysql.connection.commit()
            cursor.close()
            flash('User registration successful!')
            return redirect("/")
        
        