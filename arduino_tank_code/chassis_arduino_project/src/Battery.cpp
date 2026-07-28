#include "Battery.hpp"


Battery::Battery(uint8_t analog_pin):
    pin(analog_pin) {}


float Battery::getVoltage(){
    float R1 = 30000.0;
    float R2 = 7500.0;
    float ref_voltage = 5.0;
    float correction = 1.028;

    float ADC_value = analogRead(pin);
 
    float ADC_voltage = correction*(ADC_value*ref_voltage)/1024.0;

    float voltage_in = (ADC_voltage*(R1+R2)/R2); 
    
    return voltage_in;
}

float Battery::getAverageVoltage(){
    int N = 8;
    float sum=0;
    float averageVoltage=0;


    for(int i=0; i<8; i++){
        sum += getVoltage();
    }

    averageVoltage=sum/N;

    return averageVoltage;
}

bool Battery::isCritical(){
    float voltage = getAverageVoltage();
    Serial.print("TEST: voltage = ");
    Serial.println(voltage);

    if(voltage<10.5){
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
