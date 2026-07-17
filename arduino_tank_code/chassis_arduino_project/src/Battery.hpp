#ifndef DEF_BATTERY
#define DEF_BATTERY

#include <cstdint>
#include <Arduino.h>


class Battery{
    private:
        uint8_t pin;

    public:
        Battery(uint8_t analog_pin);
        float getVoltage();
        void getMeanVoltage();
};


#endif