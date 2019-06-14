import pyrebase
import serial

config = {
  "apiKey": "AIzaSyAjpWVkFgbKyCOt3C7-MqKQi943Kr91ZZ0",
  "authDomain": "btec-e4bef.firebaseapp.com",
  "databaseURL": "https://btec-e4bef.firebaseio.com",
  "storageBucket": "btec-e4bef.appspot.com",
  "serviceAccount": "C:/Users/mohdi/GitHub/btec_security/python/btec-e4bef-firebase-adminsdk-5r8s2-bd319bb969.json"
}

firebase = pyrebase.initialize_app(config)
db = firebase.database()

ser = serial.Serial('COM9',baudrate = 9600, timeout=1)


uid = "SZPPbQkIK9dtK8zBVGEIzOnUW0I3"
address = "Pesiaran Pendidikan Bertam Perdana, Persiaran Perindustrian Bertam Perdana, Kepala Batas"
state = "pen"
branch = "Pulau Pinang"

while 1:
    arduinoData = ser.readline()
    finalValue = arduinoData.decode('utf-8').replace('\r','').replace('\n','')
    print (finalValue)
    if finalValue == "Detected!":
        data = {
                "status": finalValue,
                "uid": uid,
                "address": address,
                "state": state,
                }
        db.child("status").child(uid).update(data)
        print("Sent Notification")
    elif finalValue == "Safe":
        data = {
                "status": finalValue,
                "uid": uid,
                "address": address,
                "state": state,
                }
        db.child("status").child(uid).update(data)
        print("Save in DB")
    elif finalValue == "Attendance":
        arduinoData = ser.readline()
        scanData = arduinoData.decode('utf-8').replace('\r','').replace('\n','')
        print(scanData)
        data = {
                "branch": branch,
                "scanData": scanData,
                "time": "null",
                "uid": uid,
                }
        db.child("attendance").child(uid).update(data)
        print("Save in Attendance")
