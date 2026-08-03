#include <Arduino.h>
#include <ArduinoBLE.h>
#include "Motor.hpp"
#include "Battery.hpp"
#include "Tank.hpp"



BLEService tankService("19B10000-E8F2-537E-4F6C-D104768A1214"); // Bluetooth® Low Energy LED Service
// Bluetooth® Low Energy LED Switch Characteristic - custom 128-bit UUID, read and writable by central
BLEByteCharacteristic switchCharacteristic("19B10001-E8F2-537E-4F6C-D104768A1214", BLERead | BLEWrite);
BLEFloatCharacteristic batteryVoltageChar("19B10002-E8F2-537E-4F6C-D104768A1214", BLERead | BLENotify);


Motor leftMotor(10, 9, 4, 5);
Motor rightMotor(3, 11, 7, 8);
Battery battery(A0);

Tank tank = Tank(leftMotor, rightMotor, battery);

unsigned long lastBrakeTime=0;

void setup() {
	Serial.begin(9600);
	tank.begin();

    if (!BLE.begin()) {
        Serial.println("starting Bluetooth® Low Energy module failed!");
    	while (1);
  	}

	// set advertised local name and service UUID:
	BLE.setLocalName("MOUHAHA");

	BLE.setAdvertisedService(tankService);

	// add the characteristic to the service
	tankService.addCharacteristic(switchCharacteristic);
	tankService.addCharacteristic(batteryVoltageChar);


	// add service
	BLE.addService(tankService);

	// set the initial value for the characteristic:
	switchCharacteristic.writeValue(0);
	batteryVoltageChar.writeValue(12.6);

	// start advertising
	BLE.advertise();
}

void updateBatteryBLE(){
	if(millis()-lastBrakeTime >=2000){
		lastBrakeTime = millis();
		float voltage = battery.getVoltage();

		Serial.print("TEST main::updateBatteryBLE: voltage = ");
		Serial.println(voltage);

		batteryVoltageChar.writeValue(voltage);
	}
}


void loop() {
  	BLEDevice central = BLE.central();

	if(central){
		while(central.connected()){
			tank.update();
			updateBatteryBLE();
			if(switchCharacteristic.written()){
				uint8_t cmd_received = switchCharacteristic.value();
				Direction dir = tank.command(cmd_received); 
				tank.move(dir, 150);
			}
		}
	}
}
