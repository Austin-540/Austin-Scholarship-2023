#!/usr/bin/python

import sqlite3
from my_secrets import getSecrets
import smtplib, ssl
from tabulate import tabulate
from datetime import datetime
from datetime import date
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

def sendEmail(contents, reciever_email, subject):
    msg = MIMEMultipart()
    msg['From'] = secrets['my_email']
    msg['To'] = secrets['reciever_email']
    msg['Subject'] = subject
    body = f"""\
<pre>
<code>
{contents}
</code>
</pre>
    """
    msg.attach(MIMEText(body, 'html'))

    with smtplib.SMTP_SSL('smtp.gmail.com', 465) as server:
        server.login(secrets['my_email'], secrets['my_password'])
        server.sendmail(secrets['my_email'], secrets['reciever_email'], msg.as_string())



    cur.execute("DELETE FROM rolls") #Delete the rolls that were uploaded, not that the email is sent
    cur.execute("DELETE FROM send_email_ready") #delete the signal that the email is ready to be sent
    con.commit()
    con.close()
    quit()

def getStudentDetails(student):
    studentDBDetails = cur.execute("SELECT name, homeroom FROM students WHERE id = ?", [student[3]]).fetchone()
    print(studentDBDetails)
    return [studentDBDetails[0], studentDBDetails[1], student[6]]


def getLessonTime(student):
    cur.execute("SELECT time FROM lessons WHERE id = ?", [student[2]])
    time = cur.fetchone()

    weekday = cur.execute("SELECT weekday FROM lessons WHERE id = ?", [student[2]]).fetchone()
    if weekday[0] != datetime.now().strftime("%A"): #If the lesson is for a different day
        cur.execute("DELETE FROM rolls") #Dont send the email
        con.commit()
        con.close()
        quit()

    date_last_marked = cur.execute("SELECT date_last_marked FROM lessons WHERE id = ?", [student[2]]).fetchone()
    print(date_last_marked)
    print(date.today().strftime("%d_%m"))
    if f"{int(date.today().strftime('%d'))}_{int(date.today().strftime('%m'))}" == date_last_marked[0]: #if date_last_marked is today add the already_marked message
        marked_today = True
    else:
        marked_today = False
    return [datetime.strptime(time[0], "%H%M").strftime("%I:%M"), marked_today]


secrets = getSecrets() #from secrets.py

con = sqlite3.connect("/home/austin/pb_data/data.db")
cur = con.cursor()

cur.execute("SELECT * FROM rolls WHERE final = true")
x = cur.fetchall()
if len(x) == 0: #look for a student where 'final' field is true, otherwise wait until there is one
    con.close()
    print("quitting - no final found")
    quit()
else:
    try:
        import google_sheets
    except Exception as error:
        print(f"**\n\n\n{error}\n\n\n**")
        print("error in google sheets, continuing")
        
print("line 66")


allDetails = []
allRolls = cur.execute("SELECT * FROM rolls").fetchall()
for student in allRolls:
	x = getStudentDetails(student)
	allDetails.append(x)
	time = getLessonTime(student)
print("Line 75")
secrets = getSecrets() #secrets from secrets.py file
print(secrets)

con = sqlite3.connect("/home/austin/pb_data/data.db")
cur = con.cursor()

cur.execute("SELECT * FROM rolls WHERE final = true")
x = cur.fetchall()
if len(x) == 0: #if there is no final:
    con.close()
    print("Quitting - no final (L85)")
    quit()
try:

    allDetails = []
    allRolls = cur.execute("SELECT * FROM rolls").fetchall()
    for student in allRolls:
        x = getStudentDetails(student)
        allDetails.append(x)

    # if time[1] == True: #if already_marked == true
    #     already_marked = "!!  This lesson has already been marked -- This is the updated information."
    # else:
    already_marked = ""

    table = tabulate(allDetails, headers=['Name', 'Homeroom', 'Status'], tablefmt='grid')

    subjectLine = datetime.now().strftime("%d-%m-%Y, %H:%M")


    sendEmail(f"""{table}

Lesson start time: {time[0]}
    {already_marked}
""", secrets['reciever_email'], subjectLine)

except Exception as e: 
    sendEmail(f"""Subject: Error while trying to send email \n
    {e}""", secrets['reciever_email'])
