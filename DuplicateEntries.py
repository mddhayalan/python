import csv

uniqueList = []
duplicateList = []
with open(r'C:\Views\Trunk\Build_\ApprovedBinaries.txt', 'r') as csvFile:
    reader = csv.reader(csvFile)
    for row in reader:
        if row is not []:
            if  row[0].startswith("#") or row not in uniqueList:
                uniqueList.append(row)
            else:
                duplicateList.append(row)

csvFile.close()