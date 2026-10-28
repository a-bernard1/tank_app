#include "Transmission.hpp"

Transmission::Transmission(uint8_t rx, uint8_t tx) : 
    rx(rx), tx(tx), serial(rx, tx){}


void Transmission::begin(long speed){
    serial.begin(speed);
}

void Transmission::sendOrder(byte command, uint16_t step){
    byte order[3];
    order[0] = command;
    order[1] = (step >> 8) & 0xFF;
    order[2] = step & 0xFF;
    serial.write(order, 3);
}

/*void Transmission::readOrder(byte order[]){
    serial.listen();
    while(serial.available()>0){
        for(int i=0; i<frame_size; i++){
            order[i] = serial.read();
        }
    }  
}*/

void Transmission::readOrder(byte order[]){
    order[0];
    if(serial.available()>=3){
        order[0] = serial.read();
        order[1] = serial.read();
        order[2] = serial.read();
    }  
}