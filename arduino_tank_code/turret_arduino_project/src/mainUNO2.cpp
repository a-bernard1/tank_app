#include <Arduino.h>
#include "Transmission.hpp"
#include <SoftwareSerial.h>

Transmission transmission(12, 13);
//SoftwareSerial MonPortSerie(12, 13);

void setup() {
	Serial.begin(9600);
	Serial.println("READY");
    Serial.println("Je suis l'UNO 3 : mainUNO2.cpp : qui reçoie");
	transmission.begin(152000); 
	//MonPortSerie.begin(152000); 

}

void loop() {
    
    byte order[3]={0,0,0};

    transmission.readOrder(order);

    if(order[0]!=0){
        switch (order[0])
            {
            case 1:
                Serial.println("Commande : Moteur 1 | absolu");
                break;
            case 2:
                Serial.println("Commande : Moteur 1 | relatif");
                break;
            case 3:
                Serial.println("Commande : Moteur 2 | absolu");
                break;
            case 4:
                Serial.println("Commande : Moteur 2 | relatif");
            default:
                break;
            }

        uint16_t a = order[1];
        uint16_t b = order[2];
        uint16_t step = 0;

        a = a<<8;

        step = a | b;

        Serial.print("pas :");
        Serial.println(step);
        /*Serial.print("Pas : ");
        Serial.print(order[1]);

        Serial.print(order[2]);
        Serial.println();
*/
    }

    
    /*MonPortSerie.listen();
    while(MonPortSerie.available()>0){
        byte valeur;
        valeur = MonPortSerie.read();
        if(valeur!=-1){
            Serial.print("valeur reçu : ");
            Serial.println(valeur);
            Serial.println();
        }
    }*/
   delay(1000);
}