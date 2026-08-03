import 'package:flutter/material.dart';
import 'package:tank_app/bluetoothServices/bluetooth_services.dart';
import 'package:tank_app/theme/styles.dart';

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
              Center(
                  child: StreamBuilder<double>(
                stream: bluetoothManager.batteryStream,
                initialData: 0,
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
              const Center(
                child: Text(
                  "CONNECTED",
                  style: TextStyle(
                      decoration: TextDecoration.none,
                      color: Colors.orange,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic),
                ),
              ),
            ],
          ),
        ),
        Expanded(child: child),
      ],
    );
  }
}
