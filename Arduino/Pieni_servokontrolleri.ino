// Ajomoottorijutut
#include <Servo.h> 
Servo leftServo;  // Creating servo-objects for controlling the motors
Servo rightServo;
static int motor; // 1 = right, 2 = left
static int pwm;   // power up between 0 and 255
unsigned long time;
int leftMid;
int rightMid;
 
void setup() { 
  time = millis();
  Serial.begin(9600);     // Opening the serial port. Sets data rate to 9600bps (default).
  Serial.println("Pieni servokontrolleri :3");
  leftServo.attach(5);   // Attaches the Servo-object on pin 5 (left motor).
  rightServo.attach(6);  // Attaches the Servo-object on pin 6 (right motor).
  leftMid = 89;
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
     // When receiving an int between 0-9, pwm is multiplied by 10 and received value is added
     // ie. L140: L -> leftServo pwm = 0*10+1, pwm = 1*10+4, pwm = 14*10+0. leftServo.write(140-1);
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
        // ie. R240XL100X gives Right servo the value of 240, and left servo to 100
        // ! leftMid = 89; -> pwm-1, rightMid = 80; -> pwm-10
    }
  }
}
