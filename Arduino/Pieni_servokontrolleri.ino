// Ajomoottorijutut
#include <Servo.h> 
Servo leftServo;  // Creating servo-objects for controlling the motors
Servo rightServo;
static int motor; // 1 = right, 2 = left
static int pwm;
unsigned long time;
int leftMid;
int rightMid;
 
void setup() { 
  time = millis();
  Serial.begin(9600);     // Opening the serial port. Sets data rate to 9600bps (default).
  Serial.println("Pieni servokontrolleri :3");
  leftServo.attach(13);   // Attaches the Servo-object on pin 5 (left motor).
  rightServo.attach(11);  // Attaches the Servo-object on pin 6 (right motor).
  leftMid = 80;
  rightMid = 80;
  leftServo.write(leftMid);
  rightServo.write(rightMid);
} 

void loop() {
  serialPorts();
}

void serialPorts() { 
  if (millis() - time > 250) {
    leftServo.write(leftMid);
    rightServo.write(rightMid); 
    time = millis();
  }
  if (Serial.available()) {
    
    char serialData;
    serialData = Serial.read();
    
    switch(serialData) {
      case '0'...'9':
        pwm = pwm * 10 + (serialData -'0');
        break;       
      case 'L':
        motor = 2;
        break;
      case 'R':
        motor = 1;
        break;
      case 'X':
        time = millis();
        if (motor == 2) {
        leftServo.write(pwm-1);
        pwm = 0; 
        }
        else if (motor == 1) {
        rightServo.write(pwm-10);
        pwm = 0;
        }
        break;
    }
  }
}
