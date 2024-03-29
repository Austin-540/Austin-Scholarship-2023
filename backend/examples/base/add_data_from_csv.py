import csv
from pocketbase import PocketBase
from secrets import getSecrets
import sqlite3

admin_password = getSecrets()['admin_password']

client = PocketBase('http://127.0.0.1:8090')

admin_data = client.admins.auth_with_password("admin@example.com", admin_password) # This script requires admin privelliges on PB to run 

def uploadLesson(listOfDetails):
    homeroom = "0" #Mr White can manually change this if there is a name clash
    students_in_lesson = []
    time = listOfDetails[0]
    for j in range(len(listOfDetails)):
        students_in_lesson.append(listOfDetails[j])
        if listOfDetails[j] != '' and j != 0:
            if listOfDetails[j] not in list_of_names_in_DB:
                client.collection('students').create({"name": listOfDetails[j], "homeroom":homeroom});
    

    all_teachers = client.collection("users").get_full_list() 
    #It is supposedly possible to use the get_one method with a filter to accomplish this, but it was giving me rediculously unhelpful error messages
    print(all_teachers)
    for x in range(len(all_teachers)): #Loop through all teachers to find the one in the CSV file's ID
        if all_teachers[x].username == teacher:
            teacher_id = all_teachers[x].id

    all_students = client.collection("students").get_full_list()
    student_db_IDs = []
    for student in students_in_lesson:
        for x in range(len(all_students)):
            if all_students[x].name == student:
                print(all_students[x].name)
                student_db_IDs.append(all_students[x].id)
    
    client.collection('lessons').create(
        {
            'teacher': teacher_id, #will raise an error if no teacher is found
            'instrument': instrument,
            'students': student_db_IDs,
            'weekday' : date,
            'time': time
        }
    )


students_already_in_DB_obj = client.collection('students').get_full_list()
students_already_in_DB_list = list(students_already_in_DB_obj) #convert SQL object to list
list_of_names_in_DB = []
for i in range(len(students_already_in_DB_list)):
    list_of_names_in_DB.append(students_already_in_DB_list[i].name)
print(list_of_names_in_DB)

con = sqlite3.connect('/home/austin/helloworld/pb_data/data.db')
cur = con.cursor()

csv_file = cur.execute("SELECT csv FROM csv_files").fetchone()[0]

data_lines = csv_file.split('\r\n') #for some reason PB shows it up with \r\n instead of just \n
data=[]
for i in range(len(data_lines)):
    data.append(data_lines[i].split(',')) #converting csv plaintext into list of lists

instrument = data[0][0]
teacher = data[1][0]
date = data[2][0]
for i in range(4, len(data)):
    uploadLesson(data[i])

cur.execute("DELETE FROM csv_files") #delete what was just uploaded
con.commit()
con.close()
