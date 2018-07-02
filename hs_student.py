from Student import Student


class HighSchoolStudent(Student):

    School_Name = "srv"

    def get_school_name(self):
        return "This is a high school student"

    def get_name_capitalize(self):
        original = super().get_name_capitalize()
        return original + "-HS"