import 'package:flutter/material.dart';
import '../bluetoothServices/bluetooth_services.dart';

class VerticalSpeedSlider extends StatefulWidget {
  const VerticalSpeedSlider({super.key});

  @override
  State<VerticalSpeedSlider> createState() => _VerticalSpeedSliderState();
}

class _VerticalSpeedSliderState extends State<VerticalSpeedSlider> {

  double _currentGear = 3.0;

  final Map<double, int> _gearToSpeed = {
    1.0: 70,
    2.0: 120,
    3.0: 160,
    4.0: 190,
    5.0: 210,
    6.0: 255,
  };

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final screenHeight = screenSize.height;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: screenHeight*0.014),
        Text(
          "SPEED : ${_currentGear.toInt()}",
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
        ),
        SizedBox(height: screenHeight*0.014),
        SizedBox(
          height: screenHeight*0.8,
          child: RotatedBox(
            quarterTurns: 3,
            child: Slider(
              value: _currentGear,
              min: 1.0,
              max: 6.0,
              divisions: 5,
              label: "Speed ${_currentGear.toInt()}",
              activeColor: Colors.orange,
              inactiveColor: Colors.grey[800],

              onChanged: (double value) {
                setState(() {
                  _currentGear = value;
                });
              },

              onChangeEnd: (double finalValue){
                int pwmSpeed = _gearToSpeed[finalValue] ?? 150;
                BluetoothManager().setSpeed(pwmSpeed);
              },
            )
          ),
        )
      ],
    );
  }
}
