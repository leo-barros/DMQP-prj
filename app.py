
from flask import Flask, flash, jsonify, redirect, render_template, request, session
from tempfile import mkdtemp
from werkzeug.exceptions import default_exceptions, HTTPException, InternalServerError
from werkzeug.security import check_password_hash, generate_password_hash
from datetime import datetime,date
from flask_mysqldb import MySQL
import uuid
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
# # Ensure templates are auto-reloaded
# app.config["TEMPLATES_AUTO_RELOAD"] = True
# # Ensure responses aren't cached
# @app.after_request
# def after_request(response):
#     response.headers["Cache-Control"] = "no-cache, no-store, must-revalidate"
#     response.headers["Expires"] = 0
#     response.headers["Pragma"] = "no-cache"
#     return response



@app.route("/")
def index():
    cursor = mysql.connection.cursor()
    cursor.execute('''SELECT * FROM movie''')
    query=cursor.fetchall()
    return render_template("home.html",query=query)

@app.route("/admin", methods=["GET", "POST"])
def admin():
    if request.method == "GET":
        return render_template("login.html")
    else:
        username= request.form.get("username")
        password= request.form.get("password")
        if username== "leo" and password=="leo":
            return render_template("adminpanel.html")
        else:
            return f"Error"

@app.route("/addmovie", methods=["GET", "POST"])
def addmovie():
    if request.method == "GET":
        cursor = mysql.connection.cursor()
        cursor.execute('''SELECT scr_no FROM screen''')
        screens=cursor.fetchall()
        return render_template("addmovie.html",screens=screens)
    else:
        title= request.form.get("title")
        duration_mins= request.form.get("duration_mins")
        screen_no= request.form.get("screen_no")
        rating= request.form.get("rating")
        language= request.form.get("language")
        cursor = mysql.connection.cursor()
        cursor.execute(''' INSERT INTO movie (screen_no,duration_mins,rating,title,language) VALUES(%s,%s,%s,%s,%s)''',(screen_no,duration_mins,rating,title,language))
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
        return redirect("/bookseats/{}/{}/{}".format(movieid,mdate,mtime))

@app.route("/bookseats/<movieid>/<date>/<showtime>", methods=["GET", "POST"])
def bookseats(movieid,date,showtime):
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
            return render_template("bookseats.html",available_seats=available_seats,movieid=movieid,date=date,showtime=showtime)
    else:
        seatno=request.form.get("seatno")

        return redirect("/transaction/{}/{}/{}/{}".format(movieid,date,showtime,seatno))

@app.route("/transaction/<movieid>/<date>/<showtime>/<seatno>", methods=["GET", "POST"])
def transact(movieid,date,showtime,seatno):
    if request.method == "GET":
        return render_template("transaction.html",movieid=movieid,date=date,showtime=showtime,seatno=seatno)
    else:
        cust_ph=request.form.get("cust_ph")
        mode_of_pay= request.form.get("mode_of_pay")
        transaction_id=str(uuid.uuid4())[:8]
        noOfTickets=1
        price=200
        now = datetime.now()
        formatted_date = now.strftime('%Y-%m-%d')
        formatted_time = now.strftime('%H:%M:%S')
        cursor = mysql.connection.cursor()
        cursor.execute(''' INSERT INTO transaction (trid,no_of_tickets,mode_of_pay,price,tdate,cust_phone,time) VALUES(%s,%s,%s,%s,%s,%s,%s)''',(transaction_id,noOfTickets,mode_of_pay,price,formatted_date,cust_ph,formatted_time))
        mysql.connection.commit()
        cursor.execute(''' INSERT INTO ticket (movie_id,seat_no,mtime,mdate,tid) VALUES(%s,%s,%s,%s,%s)''',(movieid,seatno,showtime,date,transaction_id))
        mysql.connection.commit()
        cursor.execute(''' SELECT * FROM ticket WHERE tid=%s''',[transaction_id])
        booked_ticket=cursor.fetchone()
        cursor.execute(''' SELECT title,screen_no FROM movie WHERE mid=%s''',[movieid])
        movie_details=cursor.fetchone()
        movie_title=movie_details[0]
        movie_screen=movie_details[1]
        cursor.close()
        flash('Tickets booked successfully!')
        return render_template("generatedtickets.html",ticket=booked_ticket,movie_title=movie_title,movie_screen=movie_screen)
