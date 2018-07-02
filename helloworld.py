print("Hello World")

a = 1
b = 2
print("a") if (a > b) else print("b")

student_names = ["A", "B", "C", "D", "E"]
for name in student_names:
    if name == "D":
        print(f"Found {name}")
        break
    print(f"currently processing {name}")
