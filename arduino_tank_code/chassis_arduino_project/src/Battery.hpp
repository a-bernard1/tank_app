#ifndef DEF_BATTERY
#define DEF_BATTERY

#include <cstdint>
#include <Arduino.h>


class Battery{
    private:
        uint8_t pin;
        float getVoltage();
        float underVoltageStartTime =0;

    public:
        Battery(uint8_t analog_pin);
        float getAverageVoltage();
        bool isCritical();
};


#endif