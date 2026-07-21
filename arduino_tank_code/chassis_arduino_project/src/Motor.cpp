#include "Motor.hpp"


Motor::Motor(uint8_t fwd, uint8_t back, uint8_t en1, uint8_t en2) :
    pwmForward(fwd), pwmBackward(back), enable1(en1), enable2(en2){}

void Motor::begin(){
    pinMode(pwmForward, OUTPUT);
    pinMode(pwmBackward, OUTPUT);
    pinMode(enable1, OUTPUT);
    pinMode(enable2, OUTPUT);

    digitalWrite(enable1, HIGH);
    digitalWrite(enable2, HIGH);
}

void Motor::forward(uint8_t speed){
    isBraking = false;
    analogWrite(pwmForward, speed);
    analogWrite(pwmBackward, 0);
    state = 1;
    currentSpeed = speed;
}

void Motor::backward(uint8_t speed){
    isBraking = false;
    analogWrite(pwmForward, 0);
    analogWrite(pwmBackward, speed);
    state = 2;
    currentSpeed = speed;
}

void Motor::stop(){
    if(isBraking = true)return;
    
    if (currentSpeed > 0) {
        isBraking = true;
        targetSpeed = 0;
        lastBrakeTime = millis();
    } else {
        analogWrite(pwmForward, 0);
        analogWrite(pwmBackward, 0);
        state = 0;
        isBraking = false;
    }
}

void Motor::updateBrake(){
    if(!isBraking) return;

    if(millis()-lastBrakeTime >=10){
        lastBrakeTime = millis();

        if(currentSpeed > targetSpeed){
            if(currentSpeed >=5){
                currentSpeed -= 5;
            }else{
                currentSpeed = 0;
            }
            
            if(state == 1){
                analogWrite(pwmForward, currentSpeed);
                analogWrite(pwmBackward, 0);
            }else if(state == 2){
                analogWrite(pwmForward, 0);
                analogWrite(pwmBackward, currentSpeed);
            }
        }

        if(currentSpeed == 0){
            analogWrite(pwmForward, 0);
            analogWrite(pwmBackward, 0);
            state = 0;
            isBraking = false;
        }
    }
}

