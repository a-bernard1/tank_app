#include "Tank.hpp"
#include "Battery.hpp"

Tank::Tank(Motor& l, Motor& r)  : left(l), right(r) {}

Battery battery(A0);

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
        default: return Direction::None;
    }
}

void Tank::move(Direction dir, uint8_t speed){
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

        default:
            movStop();
            battery.getMeanVoltage();
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


void Tank::updateBrake(){
    left.updateBrake();
    right.updateBrake();
}
