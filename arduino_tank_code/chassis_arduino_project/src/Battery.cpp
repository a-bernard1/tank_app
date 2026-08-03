#include "Battery.hpp"


Battery::Battery(uint8_t analog_pin):
    pin(analog_pin) {}


void Battery::measureVoltage(){
    if(millis()-lastMeasuredTime >=500){
        lastMeasuredTime = millis();
        float ADC_value = analogRead(pin);
    
        float ADC_voltage = correction*(ADC_value*ref_voltage)/1024.0;

        currentVoltage = (ADC_voltage*(R1+R2)/R2);

    }
}


float Battery::getVoltage(){
    return currentVoltage;
}


bool Battery::isCritical(){        

    if(currentVoltage>0  && currentVoltage<10.5){
        if(underVoltageStartTime==0){
            underVoltageStartTime=millis();
        } else if(millis()-underVoltageStartTime >1500){
            return true;
        }
    }else{
        underVoltageStartTime=0;
        return false;
    }
}
