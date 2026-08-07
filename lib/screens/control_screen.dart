import 'package:flutter/material.dart';
import 'package:tank_app/bluetoothServices/bluetooth_services.dart';
import 'package:tank_app/screens/firing_screen.dart';
import 'package:tank_app/widgets/vertical_speed_slider.dart';
import 'package:tank_app/theme/styles.dart';
import 'package:vector_math/vector_math_64.dart';

class ControlScreen extends StatefulWidget {
  const ControlScreen({super.key});

  @override
  State<ControlScreen> createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {

  @override
  Widget build(BuildContext context) {

    final buttonTextStyle = Theme.of(context).textTheme.labelLarge;

    return Scaffold(
      body: Container(
        color: AppColors.buttonBackground,
        child: Row(
          children: <Widget>[
            const SizedBox(
              width: 7,
            ),
            SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.buttonBackground,
                    ),
                    onPressed: BluetoothManager().forward,
                    child: SizedBox(
                      width: 90,
                      height: 100,
                      child: Center(
                        child: Text(
                          "FORWARD",
                          style: buttonTextStyle,
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.buttonBackground,
                      ),
                      onPressed: BluetoothManager().stop,
                      child: SizedBox(
                        width: 90,
                        height: 100,
                        child: Center(
                          child: Text(
                            "STOP",
                            style: buttonTextStyle
                          ),
                        ),
                      ),
                    ),
                  ElevatedButton(
                    onPressed: BluetoothManager().backward,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.buttonBackground,
                    ),
                    child: SizedBox(
                      width: 90,
                      height: 100,
                      child: Center(
                        child: Text(
                          "BACKWARD",
                          style: buttonTextStyle
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 120,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonBackground,
                ),
                child: Text(
                  "barrel commands",
                  textAlign: TextAlign.center,
                  style: buttonTextStyle
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const FiringScreen()));
                },
              ),
            ),
            SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.buttonBackground,
                        ),
                        onPressed: BluetoothManager().rotateLeft,
                        child: SizedBox(
                          width: 90,
                          height: 100,
                          child: Center(
                            child: Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.identity()..scaleByVector3(Vector3(1.0, -1.0, 100)),
                              child: const Icon(
                                Icons.refresh_rounded,
                                color: AppColors.widgetText,
                                size: 50.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.buttonBackground,
                        ),
                        onPressed: BluetoothManager().rotateRight,
                        child: const SizedBox(
                          width: 90,
                          height: 100,
                          child: Center(
                            child: Icon(
                              Icons.refresh_rounded,
                              color: AppColors.widgetText,
                              size: 50.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.buttonBackground,
                        ),
                        onPressed: BluetoothManager().turnLeft,
                        child: const SizedBox(
                          width: 90,
                          height: 120,
                          child: Center(
                            child: Icon(
                              Icons.undo,
                              color: AppColors.widgetText,
                              size: 50.0,
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.buttonBackground,
                        ),
                        onPressed: BluetoothManager().turnRight,
                        child: const SizedBox(
                          width: 90,
                          height: 120,
                          child: Center(
                            child: Icon(
                              Icons.redo,
                              color: AppColors.widgetText,
                              size: 50.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.buttonBackground,
                        ),
                        onPressed: BluetoothManager().turnLeftBack,
                        child: SizedBox(
                          width:90,
                          height: 110,
                          child: Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()..scaleByVector3(Vector3(1.0, -1.0, 100)),
                            child: const Icon(
                              Icons.undo,
                              color: AppColors.widgetText,
                              size: 50.0,
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.buttonBackground,
                        ),
                        onPressed: BluetoothManager().turnRightBack,
                        child: SizedBox(
                          width: 90,
                          height: 110,
                          child: Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()
                              ..scale(1.0, -1.0, 1.0),
                            child: const Icon(
                              Icons.redo,
                              color: AppColors.widgetText,
                              size: 50.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            VerticalSpeedSlider()
          ],
        ),
      ),
    );
  }
}
