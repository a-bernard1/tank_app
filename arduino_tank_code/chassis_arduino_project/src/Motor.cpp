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
    if(state==2 && currentSpeed>0){
        targetSpeed = speed;
        targetState = 1;
        isBraking = true;
        return;
    }

    isBraking = false;
    targetState = 1;
    targetSpeed = speed;
    state = 1;
    currentSpeed = speed;
    analogWrite(pwmForward, speed);
    analogWrite(pwmBackward, 0);
}

void Motor::backward(uint8_t speed){
    if(state==1 && currentSpeed>0){
        targetSpeed = speed;
        targetState = 2;
        isBraking = true;
        return;
    }

    isBraking = false;
    targetState = 2;
    targetSpeed = speed;
    state = 2;
    currentSpeed = speed;
    analogWrite(pwmForward, 0);
    analogWrite(pwmBackward, speed);
}

void Motor::stop(){
    if(isBraking)return;
    
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
        

        if(currentSpeed == 0){
            analogWrite(pwmForward, 0);
            analogWrite(pwmBackward, 0);

            if(targetState == 1){
                forward(targetSpeed);
            } else if(targetState == 2){
                backward(targetSpeed);
            }else{
                state = 0;
                isBraking = false;
            }
        }
    }
}

