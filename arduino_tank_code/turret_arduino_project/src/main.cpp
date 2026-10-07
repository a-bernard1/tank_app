#include <Arduino.h>
#include <AccelStepper.h>

AccelStepper stepper1(4,8,10,9,11);
AccelStepper stepper2(4,3,5,4,7);


void setup() {
  Serial.begin(9600);
  Serial.println("READY");

  stepper1.setMaxSpeed(500.0);
  stepper1.setAcceleration(300.0);
  stepper2.setMaxSpeed(500.0);
  stepper2.setAcceleration(300.0);
}

void loop() {

    if(Serial.available()>0){
    char c = Serial.read();

    if(c=='\r' || c=='\n')return;

    Serial.println("VALUE: ");
    Serial.println(c);

    switch (c)
    {
    case 'a':
      stepper1.move(100);
      break;
    case 'z':
      stepper1.move(-100);
      break;
    case 'q':
      stepper2.move(100);
      break;
    case 's':
      stepper2.move(-100);
      break;
    case 'm':
      stepper1.moveTo(0);
      break;
    case 'l':
      stepper2.moveTo(0);
      break;

    default:
      break;
    }
  }

  stepper1.run();
  stepper2.run();
}