import 'package:flutter/material.dart';
import 'package:tank_app/theme/styles.dart';
import 'screens/control_screen.dart';
import 'bluetoothServices/bluetooth_services.dart';
import 'widgets/tank_status_bar.dart';
import 'package:flutter/services.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  BluetoothManager().start();

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Tank controller',
      theme: AppTheme.darkTheme,
      builder: (context, child) {
        return TankStatusBar(
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: const ControlScreen(),
    );
  }
}
