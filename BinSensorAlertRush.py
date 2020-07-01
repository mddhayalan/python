import paho.mqtt.client as mqtt
import time
import sys
import datetime

if len(sys.argv) < 2:
    print("Arguments required:\n BinSensorAlertRush.py <total alert count> <alert interval> \nfor eg: BinSensorAlertRush.py 100 30 creates alerts every 30 seconds and totally 100 alerts")
    sys.exit()
else:
    counter = int(sys.argv[1])
    interval = int(sys.argv[2])
    print(sys.argv[1] + " alerts will be created in " + sys.argv[2] + " seconds interval each" )
 
 
def on_connect(client, userdata, flags, rc):
    if rc==0:
        client.connected_flag=True #set flag
        print("connected OK")
    else:
        print("Bad connection Returned code=",rc)
 
mqtt.Client.connected_flag=False
broker="10.0.0.14"# ip of the mqtt service
client = mqtt.Client("paho-108761146183400") # Paho client iD
client.username_pw_set("SUPER", "123456") # username password
client.on_connect=on_connect  #bind call back function
 
client.loop_start()
print("Connecting to broker ",broker)
client.connect(broker)      #connect to broker
while not client.connected_flag: #wait in loop
    print("In wait loop")
    time.sleep(1)
print("in Main Loop")
 
#create date time
dateString = datetime.datetime.now()
dateString = dateString.strftime('%Y-%m-%d %H:%M:%S')
print(dateString)
 
#define topic and payload
# topic = "devices/ENV193734556JGD/messages"
# payload = '{"ENV":{"MAC":"ENV193734556JGD","NS":"NM","DATE":"123620","TIME":"211814","PS":"MP","NO2":"9.486513502946769","SO2":"1.62576351754545","CO":"0.5823456580333326","CO2":"500.938500829337","O3":"13.131981024728974","TEMP":"30.25609943692684","HUM":"78.49768640032687","UV":"","LIGHT":"9986.41","NOISE":"64.2195","PM2.5":"20.26244408520541","PM10":"26.245897764702836","AQI":"35"}}'
topic = "devices/BIN76424629/messages"
payloadstart = '{"VSDATA": {"CSQ": "","LN": "1.2994933333333336","VDP": "","PT": 0,"PV": "A","DLN": "","LT": "0.20366666666666663","IMEI": "BIN76424629","PID": "1852","DLT": "","TA": "","DT": "20191121","FX": "0","BV": "2944","HDP": "","DTF": "97","location": "","SN": "7022627289",'
payloadtime = f'"DATE_TIME": "{dateString}"'
payloadend = ',"PDP": "","SP": "","TS": "022644"},"MESSAGE_ID": 1574326801553}'
payload = payloadstart + payloadtime + payloadend
 
#counter for alert creation in certain interval. eg; this below logic creates alerts every 30 sec for 50 mins (100 times)

while counter != 0:
    info = client.publish(topic, payload, 0, False)
    if info.is_published:
        dateString = datetime.datetime.now()
        dateString = dateString.strftime('%Y-%m-%d %H:%M:%S')
        print("Alert published @", dateString)
    else:
        print("Alert not published")
    counter -= 1
    time.sleep(interval)
 
client.loop_stop()    #Stop loop
client.disconnect() # disconnect client.