#ifndef DEF_TRANSMISSION
#define DEF_TRANSMISSION

//#include <cstdint>
#include <Arduino.h>
#include <SoftwareSerial.h>

class Transmission{
    private:
        uint8_t rx;
        uint8_t tx;
        long speed;
        SoftwareSerial serial;
        uint8_t frame_size = 3;

    public: 
        Transmission(uint8_t rx, uint8_t tx);

        void begin(long speed);

        void sendOrder(byte command, int16_t step);
        void readOrder(byte order[]);
};


#endif