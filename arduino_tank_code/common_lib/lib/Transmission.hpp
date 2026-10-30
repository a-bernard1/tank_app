#ifndef DEF_TRANSMISSION
#define DEF_TRANSMISSION

//#include <cstdint>
#include <Arduino.h>
#include <SoftwareSerial.h>

class Transmission{
    private:
        Stream& serial;

    public: 
        explicit Transmission(Stream& serial);

        void begin(long speed);

        void sendOrder(byte command, int16_t step);
        void readOrder(byte order[]);
};


#endif