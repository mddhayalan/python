import socket
import sys
import time
import datetime

if len(sys.argv) < 3:
    print("Arguments required:\n TruckAlert.py <TruckID> <total alert count> <alert interval> \nfor eg: TruckAlert.py 123456 100 30 creates alerts every 30 seconds and totally 100 alerts")
    sys.exit()
else:
    counter = int(sys.argv[2])
    interval = int(sys.argv[3])
    truckId = sys.argv[1]
    print(sys.argv[2] + " alerts will be created in " + sys.argv[3] + " seconds interval each" )

buffer_size = 1024
ip = "10.0.0.14"
port=5001
truckSpeed = 90 #speed more than 50 creates alert
latitude = 14.243157
longitude = 76.563828

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect((ip, port))

while counter > 0:
    command = f"$$TRINITY,{truckId},1,{latitude},{longitude},010720095730,A,25,{truckSpeed},73566,215,6,1.340000,0,0,68,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,12368,4276,*20"
    b = bytearray()
    b.extend(command.encode())
    s.sendall(b)
    counter -= 1
    time.sleep(interval)
    dateString = datetime.datetime.now()
    dateString = dateString.strftime('%Y-%m-%d %H:%M:%S')
    print("Truck alert created @ ", dateString)
    latitude += 0.0001
    longitude += 0.0001
s.close()
print("All truck alerts are created")