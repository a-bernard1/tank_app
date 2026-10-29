#include "Transmission.hpp"
#define HEADER_MESSAGE 0xAA

Transmission::Transmission(uint8_t rx, uint8_t tx) : 
    rx(rx), tx(tx), serial(rx, tx){}


void Transmission::begin(long speed){
    serial.begin(speed);
}

void Transmission::sendOrder(byte command, int16_t step){
    byte order[4];
    order[0] = HEADER_MESSAGE;
    order[1] = command;
    order[2] = (step >> 8) & 0xFF;
    order[3] = step & 0xFF;
    serial.write(order, 4);
}


void Transmission::readOrder(byte order[]){
    order[0] = 0;
    while(serial.available()>0){
        if(serial.peek() != HEADER_MESSAGE){
            serial.read();
        }else{
            if(serial.available()>=4){
                serial.read();
                order[0] = serial.read();
                order[1] = serial.read();
                order[2] = serial.read();
                return;
            }else{
                return;
            }
        }
    }  
}