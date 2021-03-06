import requests
import sys
import json
import time

if len(sys.argv) < 3:
    print("Arguments required:\n CameraAlerts.py <CameraID> <total alert count> <alert interval> \nfor eg: CameraAlerts.py CAMERAMADI01 100 30 creates alerts every 30 seconds and totally 100 alerts")
    sys.exit()
else:
    counter = int(sys.argv[2])
    interval = int(sys.argv[3])
    cameraId = sys.argv[1]
    print(sys.argv[2] + " alerts will be created in " + sys.argv[3] + " seconds interval each" )

while counter > 0:
    response = requests.post("http://10.0.0.14:6464/IOTHUB_HttpServer/oauth/token", data={'username': 'trinity', 'password': 'trinity@123', 'grant_type': 'password'}, auth=('trinity-client', 'trinity-secret') )
    if response.status_code != 200:
        print("request failed", response.status_code)
        sys.exit()
    content = json.loads(response.content)
    access_token = content["access_token"]
    bearerToken = f"Bearer {access_token}"
    print(bearerToken)
    header = {'Authorization': bearerToken, 'Content-Type': 'application/json', 'deviceId': cameraId}

    epochTime = int(time.time() * 1000)

    payload ={
    "sourceId": "1",
    "eventId": "218",
    "alertMessage": "Face Recoginition",
    "alertType": "218",
    "headcount": "0",
    "priority": "",
    "userName": "",
    "threshHoldHeadCount": "0",
    "eventDetails4": "",
    "companyId": "3",
    "eventDetails5": "",
    "eventDetails2": "",
    "videoUrl": "http://172.16.1.35:7080/REST/1/event/18/clip",
    "cameraId": cameraId,
    "eventDetails3": "",
    "eventDetails1": "",
    "imageUrl": "https://catalog.carlislefsp.com/images/240x240/270873.jpg",
    "eventTime": epochTime,
    "alertId": "",
    "time": "",
    "alertTime": epochTime
    }
    cameraAlertResponse = requests.post("http://10.0.0.14:6464/IOTHUB_HttpServer/rest/VMSServices/VMSAnalyticsAlerts/3", headers=header, json=payload)
    print(cameraAlertResponse)
    counter -= 1
    time.sleep(interval)
print("All alerts are created. Exiting the script.")