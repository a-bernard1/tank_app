#include <Arduino.h>
#include "Transmission.hpp"

Transmission transmission(12, 13);

void setup() {
    Serial.begin(9600);
    Serial.println("READY");
    Serial.println("Je suis l'UNO 2 : mainUNO1.cpp : qui envoie");
    transmission.begin(152000); 

}

void loop() {

    if(Serial.available()>0){
    char c = Serial.read();

    if(c=='\r' || c=='\n')return;

    if(c=='a'){
        Serial.print("VALUE: ");
        Serial.println(c);
        transmission.sendOrder(1, 500);
    }
  }
}