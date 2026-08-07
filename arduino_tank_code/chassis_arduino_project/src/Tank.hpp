#pragma once
#ifndef DEF_TANK
#define DEF_TANK

#include <Arduino.h>
#include "Motor.hpp"
#include "Battery.hpp"

enum class Direction {
    None,
    Forward,
    Backward,
    TurnLeft,
    TurnRight,
    RotateLeft,
    RotateRight,
    TurnLeftBack,
    TurnRightBack
};

class Tank{
    private: 
        Motor& left;
        Motor& right;
        Battery& battery;
        Direction current = Direction::None;
        uint8_t speed = 150;
        uint8_t currentSpeed = speed;
        bool batteryTooLow = false;

    public: 
        Tank(Motor& l, Motor& r, Battery& b);

        void begin();

        void setSpeed(uint8_t s);

        uint8_t getSpeed();

        Direction command(uint8_t cmd);

        void move(Direction dir, uint8_t speed);

        void movStop();

        void update();

        void rotate(bool dirRotation, uint8_t speed);
};

#endif