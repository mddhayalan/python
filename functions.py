students = []


def get_students_titlecase():
    students_titlecase = []
    for student in students:
        students_titlecase = student["name"].title()
    return students_titlecase


def print_students_titlecase():
    students_titlecase = []
    for student in students:
        students_titlecase = student["name"].title()
        print(students_titlecase)


def add_student(name, student_id=332):
    student = {"name": name, "student_id": student_id}
    students.append(student)


while input("Do you want to add new student details ? (yes/no): ") == "yes":
    student_name = input("Enter student name: ")
    student_id = input("Enter student id: ")
    add_student(student_name, student_id) 

