import pyrebase
import cv2

face_cascade = cv2.CascadeClassifier('cascades/data/haarcascade_frontalface_alt2.xml')

cap = cv2.VideoCapture(0)

config = {
  "apiKey": "AIzaSyAjpWVkFgbKyCOt3C7-MqKQi943Kr91ZZ0",
  "authDomain": "btec-e4bef.firebaseapp.com",
  "databaseURL": "https://btec-e4bef.firebaseio.com",
  "storageBucket": "btec-e4bef.appspot.com",
  "serviceAccount": "C:/Users/mohdi/GitHub/btec_security/python/btec-e4bef-firebase-adminsdk-5r8s2-bd319bb969.json"
}

firebase = pyrebase.initialize_app(config)
storage = firebase.storage()

while(True):
    #capture frame-by-frame
    ret, frame =cap.read()
    
    #convert rgb to gray and apply face detection module
    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
    faces = face_cascade.detectMultiScale(gray, scaleFactor=1.5, minNeighbors=5)
    for (x,y,w,h) in faces:
        print(x,y,w,h)
        
        #create image and save into project directory
        roi_gray = gray[y:y+h, x:x+w]
        roi_color = frame[y:y+h, x:x+w]
        img_item = "image.png"
        cv2.imwrite(img_item, roi_color)
        
        #draw rectangle wit color
        color = (255, 0, 0) #BGR min=0 max=255
        stroke = 2 #thickness of line
        end_cord_x = x + h #ending of coordinate of X
        end_cord_y = y + w #ending of coordinate of Y
        cv2.rectangle(frame, (x,y), (end_cord_x, end_cord_y), color, stroke)
        
        #store in Firebase Storage
        storage.child("image.png").put("C:/Users/mohdi/GitHub/btec_security/python/image.png")
        
    #display resulting frame
    cv2.imshow('frame',frame)
    if cv2.waitKey(20) & 0xFF == ord('q'):
        break
cap.release()
cv2.destroyAllWindows()
    