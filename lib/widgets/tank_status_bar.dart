import 'package:flutter/material.dart';
import 'package:tank_app/bluetoothServices/bluetooth_services.dart';
import 'package:tank_app/screens/bluetooth_devices_screen.dart';
import '../main.dart';

class TankStatusBar extends StatelessWidget {
  final Widget child;

  final BluetoothManager bluetoothManager = BluetoothManager();

  TankStatusBar({required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 30,
          color: Colors.black,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: const Icon(Icons.bluetooth, color: Colors.blueAccent, size: 22),
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
                  return Row(
                    children: [
                      Icon(
                        batteryLevel > 10.5
                            ? Icons.battery_std
                            : Icons.battery_alert,
                        color: batteryLevel > 10.5 ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "${batteryLevel.toStringAsFixed(2)} V",
                        style: const TextStyle(
                          decoration: TextDecoration.none,
                          color: Colors.orange,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  );
                },
              )),
              const SizedBox(width: 40),
              StreamBuilder(
                  stream: bluetoothManager.connectionStateStream,
                  initialData: bluetoothManager.isConnected,
                  builder: (context, snapshot) {
                    bool connected = snapshot.data ?? false;
                    return Text(
                      connected ? "CONNECTED" : "DISCONNECTED",
                      style: TextStyle(
                          decoration: TextDecoration.none,
                          color: connected ? Colors.green : Colors.red,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                    );
                  })
              /*Center(
                child: Text(
                  "CONNECTED",
                  style: TextStyle(
                      decoration: TextDecoration.none,
                      color: Colors.orange,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic),
                ),
              ),*/
            ],
          ),
        ),
        Expanded(child: child),
      ],
    );
  }
}
