import socket
import sys

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
command = f"$$TRINITY,{truckId},1,13.243157,76.563828,010720095730,A,25,90,73566,215,6,1.340000,0,0,68,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,12368,4276,*20"
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
b = bytearray()
b.extend(command.encode())
s.connect((ip, port))
s.sendall(b)
# data = s.recv(buffer_size)
s.close()
# print("received data:", data)