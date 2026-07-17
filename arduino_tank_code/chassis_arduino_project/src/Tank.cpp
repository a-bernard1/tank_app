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
    currentSpeed = speed;
    move(current, speed);
}

void Tank::movStop(){
    left.stop();
    right.stop();
    current = Direction::None;        
}

Direction Tank::command(uint8_t cmd){
    switch(cmd){
        //case 0: return Direction::None;
        case 1: return Direction::Forward;
        case 2: return Direction::Backward;
        case 3: return Direction::RotateLeft;
        case 4: return Direction::RotateRight;
        default: return Direction::None;
    }
}

void Tank::move(Direction dir, uint8_t speed){
    if (dir==current && speed==currentSpeed) return;
    
    switch (dir){
        /*case Direction::None:
            battery.getMeanVoltage();
            left.stop();
            right.stop();

            break;*/
        
        case Direction::Forward:
            left.forward(speed);
            right.forward(speed);
            break;
        
        case Direction::Backward:
            left.backward(speed);
            right.backward(speed);
            break;
        
        case Direction::RotateLeft:
            left.backward(speed);
            right.forward(speed);
            break;

        case Direction::RotateRight:
            left.forward(speed);
            right.backward(speed);
            break;

        default:
            left.stop();
            right.stop();
            battery.getMeanVoltage();
    }
    current = dir;
}
