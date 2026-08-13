import 'package:flutter/material.dart';
import 'package:tank_app/bluetoothServices/bluetooth_services.dart';
import 'package:tank_app/screens/bluetooth_devices_screen.dart';
import '../theme/styles.dart';
import '../main.dart';

class TankStatusBar extends StatelessWidget {
  final Widget child;

  final BluetoothManager bluetoothManager = BluetoothManager();

  TankStatusBar({required this.child});

  @override
  Widget build(BuildContext context) {

    final screenSize = MediaQuery.sizeOf(context);
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    String textState;
    bool isConnected = false;
    IconData batteryIcon;
    Color batteryIconColor;

    return Column(
      children: [
        Container(
          height: screenHeight*0.1,
          color: Colors.black,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: Icon(Icons.bluetooth, color: Colors.blueAccent, size: screenWidth*0.034),
            onPressed: () {
              navigatorKey.currentState?.push(
                MaterialPageRoute(
                  builder: (context) => const BluetoothDevicesScreen(),
                ),
              );
            },
          ),
              Center(
                  child: StreamBuilder<double>(
                stream: bluetoothManager.batteryStream,
                initialData: -1,
                builder: (context, snapshot) {
                  double batteryLevel = snapshot.data ?? 0;
                  if(isConnected){
                    if(batteryLevel>10.5){
                      batteryIcon = Icons.battery_std;
                      batteryIconColor = AppColors.techGreen;
                    } else {
                      batteryIcon = Icons.battery_alert;
                      batteryIconColor = AppColors.techRed;
                    }
                  } else {
                    batteryIcon = Icons.battery_unknown;
                    batteryIconColor = AppColors.widgetText;
                  }

                  return Row(
                    children: [
                      Icon(
                          batteryIcon,
                          color: batteryIconColor
                      ),
                      SizedBox(width: screenWidth*0.006),
                      Text(
                        isConnected && batteryLevel >0
                            ? "${batteryLevel.toStringAsFixed(2)} V"
                            : "-- V",
                        style: TextStyle(
                          decoration: TextDecoration.none,
                          color: AppColors.widgetText,
                          fontSize: screenWidth*0.023,
                        ),
                      ),
                    ],
                  );
                },
              )),
              SizedBox(width: screenWidth*0.06),
              StreamBuilder(
                  stream: bluetoothManager.connectionStateStream,
                  initialData: bluetoothManager.isConnected,
                  builder: (context, snapshot) {
                    bool connected = snapshot.data ?? false;
                    if(connected){
                      textState = "CONNECTED";
                      isConnected = true;
                    } else {
                      textState = "DISCONNECTED";
                      isConnected = false;
                    }

                    return Text(
                      textState,
                      style: TextStyle(
                          decoration: TextDecoration.none,
                          color: connected ? AppColors.techGreen : AppColors.techRed,
                          fontSize: screenWidth*0.023,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                    );
                  },
              )
            ],
          ),
        ),
        Expanded(child: child),
      ],
    );
  }
}
