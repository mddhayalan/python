students=[]


class Student:

    School_Name = "Little Flower"

    def __init__(self, name, student_id=332):
        self.name = name
        self.student_id = student_id
        students.append(self)

    def __str__(self):
        return "Student " + self.name

    def get_school_name(self):
        return self.School_Name.capitalize()

    def get_name_capitalize(self):
        return self.name.capitalize()
