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

    final screenSize = MediaQuery.sizeOf(context);
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    final buttonTextStyle = Theme.of(context).textTheme.labelLarge;

    return Scaffold(
      body: Container(
        color: AppColors.buttonBackground,
        child: Row(
          children: <Widget>[
            SizedBox(
              width: screenWidth*0.01,
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
                      width: screenWidth*0.15,
                      height: screenHeight*0.30,
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
                        width: screenWidth*0.14,
                        height: screenHeight*0.30,
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
                      width: screenWidth*0.14,
                      height: screenHeight*0.30,
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
              width: screenWidth*0.17,
              height: screenHeight*0.16,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonBackground,
                ),
                child: Text(
                  "gun control",
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
                          width: screenWidth*0.14,
                          height: screenHeight*0.30,
                          child: Center(
                            child: Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.identity()..scaleByVector3(Vector3(-1.0, 1.0, 1.0)),
                              child: Icon(
                                Icons.refresh_rounded,
                                color: AppColors.widgetText,
                                size: screenWidth*0.08,
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
                        child: SizedBox(
                          width: screenWidth*0.14,
                          height: screenHeight*0.30,
                          child: Center(
                            child: Icon(
                              Icons.refresh_rounded,
                              color: AppColors.widgetText,
                              size: screenWidth*0.08,
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
                        child: SizedBox(
                          width: screenWidth*0.14,
                          height: screenHeight*0.30,
                          child: Center(
                            child: Icon(
                              Icons.undo,
                              color: AppColors.widgetText,
                              size: screenWidth*0.08,
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.buttonBackground,
                        ),
                        onPressed: BluetoothManager().turnRight,
                        child:  SizedBox(
                          width: screenWidth*0.14,
                          height: screenHeight*0.3,
                          child: Center(
                            child: Icon(
                              Icons.redo,
                              color: AppColors.widgetText,
                              size: screenWidth*0.08,
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
                          width:screenWidth*0.14,
                          height: screenHeight*0.30,
                          child: Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()..scaleByVector3(Vector3(1.0, -1.0, 1.0)),
                            child: Icon(
                              Icons.undo,
                              color: AppColors.widgetText,
                              size: screenWidth*0.08,
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
                          width: screenWidth*0.14,
                          height: screenHeight*0.30,
                          child: Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()..scaleByVector3(Vector3(1.0, -1.0, 1.0)),
                            child: Icon(
                              Icons.redo,
                              color: AppColors.widgetText,
                              size:screenWidth*0.08,
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
