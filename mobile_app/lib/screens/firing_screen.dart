import 'package:flutter/material.dart';
import 'package:tank_app/screens/control_screen.dart';
import 'package:tank_app/theme/styles.dart';

class FiringScreen extends StatefulWidget {
  const FiringScreen({super.key});

  @override
  State<FiringScreen> createState() => _FiringScreenState();
}

class _FiringScreenState extends State<FiringScreen> {

  final int elevation = 0;
  final List<String> rotaValue = ["-0.6", "-6", "+6", "+0.6"];

  @override
  Widget build(BuildContext context) {

    final buttonTextStyle = Theme.of(context).textTheme.labelLarge;

    return Scaffold(
      body: Container(
        color: AppColors.buttonBackground,
        child: Row(
          children: <Widget>[
            const SizedBox(
              width: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.buttonBackground,
                  ),
                  child: Text("tank control", style: buttonTextStyle),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const ControlScreen()
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(
              width: 20,
            ),

            Row(
                children: [
                  for(int i=0; i<4; i++)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.buttonBackground,
                      ),
                      onPressed: (){
                        print(rotaValue[i]);
                      },
                      child: Text(rotaValue[i], style: buttonTextStyle),
                    ),


                ]
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.buttonBackground,
              ),
              onPressed: (null),
              child: Text("FIRE !", style: buttonTextStyle),
            ),
          ],
        ),
      ),
    );
  }
}
