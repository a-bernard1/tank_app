#ifndef DEF_BATTERY
#define DEF_BATTERY

#include <cstdint>
#include <Arduino.h>


class Battery{
    private:
        const float R1 = 30000.0;
        const float R2 = 7500.0;
        const float ref_voltage = 5.0;
        const float correction = 1.028;
        unsigned long compt=0;

        uint8_t pin;
        float currentVoltage = 0.0;
        unsigned long lastMeasuredTime = -500;
        unsigned long underVoltageStartTime =0;

    public:
        Battery(uint8_t analog_pin);
        
        void measureVoltage();

        float getVoltage();
        bool isCritical();
};


#endif