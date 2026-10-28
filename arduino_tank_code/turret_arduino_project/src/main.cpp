#include <Arduino.h>
#include <AccelStepper.h>
#include "Transmission.hpp"

AccelStepper stepper1(4,8,10,9,11);
AccelStepper stepper2(4,3,5,4,7);
Transmission transmission(12, 13);


void setup() {
    Serial.begin(9600);
    transmission.begin(152000); 

    stepper1.setMaxSpeed(500.0);
    stepper1.setAcceleration(300.0);
    stepper2.setMaxSpeed(500.0);
    stepper2.setAcceleration(300.0);

    Serial.println("READY");
}

void loop() {
    byte order[3]={0,0,0};

    transmission.readOrder(order);

    if(order[0]!=0){

        int16_t a = order[1];
        int16_t b = order[2];
        int16_t step = 0;

        a = a<<8;

        step = (long)(a | b);

        switch (order[0])
            {
            case 1:
                Serial.println("Commande : Moteur 1 | absolu");
                Serial.print("Mouvement du moteur 1 vers la position ");
                Serial.println(step);
                stepper1.moveTo(step);
                break;
            case 2:
                Serial.println("Commande : Moteur 1 | relatif");
                Serial.print("Mouvement du moteur 1 de ");
                Serial.print(step);
                Serial.println("pas");
                stepper1.move(step);
                break;
            case 3:
                Serial.println("Commande : Moteur 2 | absolu");
                Serial.print("Mouvement du moteur 1 vers la position ");
                Serial.println(step);
                stepper2.moveTo(step);
                break;
            case 4:
                Serial.println("Commande : Moteur 2 | relatif");
                Serial.print("Mouvement du moteur 2 de ");
                Serial.print(step);
                Serial.println("pas");
                stepper2.move(step);
                break;    
            default:
                break;
            }

    }

    stepper1.run();
    stepper2.run();
}