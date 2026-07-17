#include "Battery.hpp"


Battery::Battery(uint8_t analog_pin):
    pin(analog_pin) {}



float Battery::getVoltage(){
    float R1 = 30000.0;
    float R2 = 7500.0;
    float ref_voltage = 5.0;
    float correction = 1.028;

    float ADC_value = analogRead(pin);
    //Serial.print("ADC_value: ");
    //Serial.println(ADC_value);

    float ADC_voltage = correction*(ADC_value*ref_voltage)/1024.0;
    //Serial.print("ADC_voltage: ");
    //Serial.println(ADC_voltage);

    float voltage_in = (ADC_voltage*(R1+R2)/R2); 
    
    /*if(voltage_in<10.0){
        Serial.print("Voltage : ");
        Serial.print(voltage_in);
        Serial.print(" V");
        Serial.println(" BATTERY VOLTAGE TOO LOW !!");
    } else {
        Serial.print("Voltage : ");
        Serial.print(voltage_in);
        Serial.print(" V");
    }*/
    return voltage_in;
}

void Battery::getMeanVoltage(){
    int N = 8;
    float sum=0;
    float meanVoltage=0;


    for(int i=0; i<8; i++){
        sum += getVoltage();
    }

    meanVoltage=sum/N;

    Serial.println("");
    Serial.print("moy : ");
    Serial.print(meanVoltage);
    Serial.println(" V");
    Serial.println("");
}
