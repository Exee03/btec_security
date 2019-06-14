#include <SoftwareSerial.h>
#include <Adafruit_Fingerprint.h>

SoftwareSerial mySerial(2, 3);

#define doorlock 8
#define trigPin 11
#define echoPin 12
#define pushbutton 6

Adafruit_Fingerprint finger = Adafruit_Fingerprint(&mySerial);

int scanned = 0;
unsigned long startTime = millis();
unsigned long intervalTime = 40000UL;
int remainderTime = 0;

void setup() {
  Serial.begin(9600);
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);
  pinMode(doorlock, OUTPUT);
  digitalWrite(doorlock, HIGH);
  digitalWrite(pushbutton, HIGH);
  while (!Serial);
  delay(100);

  // set the data rate for the sensor serial port
  finger.begin(57600);

  if (finger.verifyPassword()) {
    Serial.println("Found fingerprint sensor!");
  } else {
    Serial.println("Did not find fingerprint sensor :(");
    while (1) {
      delay(1);
    }
  }

  finger.getTemplateCount();
  Serial.print("Sensor contains "); Serial.print(finger.templateCount); Serial.println(" templates");
  Serial.println("Waiting for valid finger...");
}

void loop() {
  Serial.println("Safe");
  if (digitalRead(pushbutton) == HIGH) {
    long duration, distance;
    digitalWrite(trigPin, LOW);
    delayMicroseconds(2);
    digitalWrite(trigPin, HIGH);
    delayMicroseconds(10);
    digitalWrite(trigPin, LOW);

    duration = pulseIn(echoPin, HIGH);
    distance = (duration / 2) / 29.1;

    if (distance < 10) {
      Serial.println("Human Detected");
      while (remainderTime < intervalTime) {
        long duration, distance;
        digitalWrite(trigPin, LOW);
        delayMicroseconds(2);
        digitalWrite(trigPin, HIGH);
        delayMicroseconds(10);
        digitalWrite(trigPin, LOW);

        duration = pulseIn(echoPin, HIGH);
        distance = (duration / 2) / 29.1;

        if (distance < 10) {
          if (digitalRead(pushbutton) == LOW) {
            break;
          }
          remainderTime = millis() - startTime;
          getFingerprintIDez();
          delay(50);
          if (scanned == 1) {
            scanned = 0;
            remainderTime = 0;
            startTime = millis();
            break;
          }
          else {
            Serial.println("Waiting for Scan\n");
          }
        } else {
          break;
        }


      }
      if (remainderTime > intervalTime) {
        Serial.println("Sent Notification!");
        Serial.println("Detected!");
        remainderTime = 0;
        startTime = millis();
        delay(3000);
      }
    }
    else {
      Serial.println("-----No human detected----------");
    }

    Serial.print(distance);
    Serial.println(" cm");
    delay(500);
  } else if (digitalRead(pushbutton) == LOW) {
    digitalWrite(doorlock, LOW);
    delay(6000);
    digitalWrite(doorlock, HIGH);
  }
}

uint8_t getFingerprintID() {
  uint8_t p = finger.getImage();
  switch (p) {
    case FINGERPRINT_OK:
      Serial.println("Image taken");
      break;
    case FINGERPRINT_NOFINGER:
      Serial.println("No finger detected");
      return p;
    case FINGERPRINT_PACKETRECIEVEERR:
      Serial.println("Communication error");
      return p;
    case FINGERPRINT_IMAGEFAIL:
      Serial.println("Imaging error");
      return p;
    default:
      Serial.println("Unknown error");
      return p;
  } // OK success!

  p = finger.image2Tz();
  switch (p) {
    case FINGERPRINT_OK:
      Serial.println("Image converted");
      break;
    case FINGERPRINT_IMAGEMESS:
      Serial.println("Image too messy");
      return p;
    case FINGERPRINT_PACKETRECIEVEERR:
      Serial.println("Communication error");
      return p;
    case FINGERPRINT_FEATUREFAIL:
      Serial.println("Could not find fingerprint features");
      return p;
    case FINGERPRINT_INVALIDIMAGE:
      Serial.println("Could not find fingerprint features");
      return p;
    default:
      Serial.println("Unknown error");
      return p;
  }

  // OK converted!
  p = finger.fingerFastSearch();
  if (p == FINGERPRINT_OK) {
    Serial.println("Found a print match!");
  } else if (p == FINGERPRINT_PACKETRECIEVEERR) {
    Serial.println("Communication error");
    return p;
  } else if (p == FINGERPRINT_NOTFOUND) {
    Serial.println("Did not find a match");
    return p;
  } else {
    Serial.println("Unknown error");
    return p;
  }
  // found a match!

  Serial.print("Found ID #"); Serial.print(finger.fingerID);
  Serial.print(" with confidence of "); Serial.println(finger.confidence);
  return finger.fingerID;
}

// returns -1 if failed, otherwise returns ID #
int getFingerprintIDez() {
  uint8_t p = finger.getImage();
  if (p != FINGERPRINT_OK)  return -1;

  p = finger.image2Tz();
  if (p != FINGERPRINT_OK)  return -1;

  p = finger.fingerFastSearch();
  if (p != FINGERPRINT_OK)  return -1;

  // found a match!
  Serial.println("Attendance");
  Serial.println(finger.fingerID);
  digitalWrite(doorlock, LOW);
  delay(6000);
  digitalWrite(doorlock, HIGH);
  scanned = 1;
  return finger.fingerID;
}
