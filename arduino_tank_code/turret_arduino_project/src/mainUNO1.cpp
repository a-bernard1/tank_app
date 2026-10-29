#include <Arduino.h>
#include "Transmission.hpp"

Transmission transmission(12, 13);

void setup() {
    Serial.begin(9600);
    Serial.println("READY");
    Serial.println("Je suis l'UNO 2 : mainUNO1.cpp : qui envoie");
    transmission.begin(57600); 

}

void loop() {

    if(Serial.available()>0){
    char c = Serial.read();

    if(c=='\r' || c=='\n')return;


    switch (c){
        case 'a':
            Serial.print("VALUE: ");
            Serial.println(c);
            transmission.sendOrder(2, 50);
            break;
        
        case 'z':
            Serial.print("VALUE: ");
            Serial.println(c);
            transmission.sendOrder(2, -50);
            break;
        
        case 'q':
            Serial.print("VALUE: ");
            Serial.println(c);
            transmission.sendOrder(4, 100);
            break;
        
        case 's':
            Serial.print("VALUE: ");
            Serial.println(c);
            transmission.sendOrder(4, -100);
            break;
        case 'A':
            Serial.print("VALUE: ");
            Serial.println(c);
            transmission.sendOrder(1, 0);
            break;
        case 'Z':
            Serial.print("VALUE: ");
            Serial.println(c);
            transmission.sendOrder(3, 0);
            break;
        
        default:
            break;
        }
    }
}