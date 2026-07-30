#include "Tank.hpp"

Tank::Tank(Motor& l, Motor& r, Battery& b)  : left(l), right(r), battery(b) {}


void Tank::begin(){
    left.begin();
    right.begin();
}

void Tank::setSpeed(uint8_t s){
    speed = s;
    move(current, speed);
}

void Tank::movStop(){
    left.stop();
    right.stop();
    current = Direction::None;        
}

Direction Tank::command(uint8_t cmd){
    switch(cmd){
        case 1: return Direction::Forward;
        case 2: return Direction::Backward;
        case 3: return Direction::TurnLeft;
        case 4: return Direction::TurnRight;
        case 5: return Direction::RotateLeft;
        case 6: return Direction::RotateRight;
        case 7: return Direction::TurnLeftBack;
        case 8: return Direction::TurnRightBack;
        default: return Direction::None;
    }
}

void Tank::move(Direction dir, uint8_t speed){
    if(batteryTooLow){
        movStop();
        return;
    }
    if (dir==current && speed==currentSpeed) return;
    
    switch (dir){
        
        case Direction::Forward:
            left.forward(speed);
            right.forward(speed);
            break;
        
        case Direction::Backward:
            left.backward(speed);
            right.backward(speed);
            break;
        
        case Direction::TurnLeft:
            left.stop();
            right.forward(speed);
            break;

        case Direction::TurnRight:
            left.forward(speed);
            right.stop();
            break;

        case Direction::RotateLeft:
            rotate(false, speed);
            break;

        case Direction::RotateRight:
            rotate(true, speed);
            break;

        case Direction::TurnLeftBack:
            left.stop();
            right.backward(speed);

        case Direction::TurnRightBack:
            left.backward(speed);
            right.stop();

        default:
            movStop();
    }
    current = dir;
    currentSpeed = speed;
}

void Tank::rotate(bool dirRotation, uint8_t speed){
    if(dirRotation){
        left.backward(speed);
        right.forward(speed);
    }else{
        left.forward(speed);
        right.backward(speed);
    }
}


void Tank::update(){
    left.updateBrake();
    right.updateBrake();

    
    battery.measureVoltage();

    if(battery.isCritical()){
        movStop();
        batteryTooLow = true;
    }
}
