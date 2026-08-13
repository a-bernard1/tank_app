import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../bluetoothServices/bluetooth_services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/styles.dart';

class BluetoothDevicesScreen extends StatefulWidget {
  const BluetoothDevicesScreen({super.key});

  @override
  State<BluetoothDevicesScreen> createState() => _BluetoothDevicesScreenState();
}

class _BluetoothDevicesScreenState extends State<BluetoothDevicesScreen> {
  final BluetoothManager bleManager = BluetoothManager();
  bool isScanning = false;

  @override
  void initState() {
    super.initState();
    _startScan();
  }

  void _startScan() async {
    setState(() => isScanning = true);
    await bleManager.startScan();
    setState(() => isScanning = false);
  }

  @override
  Widget build(BuildContext context) {

    final buttonTextStyle = Theme.of(context).textTheme.labelLarge;
    final screenSize = MediaQuery.sizeOf(context);
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    return Scaffold(
      appBar: AppBar(
        title:  const Text(
            "Bluetooth devices"),
        actions: [
          IconButton(
            icon: isScanning
                ? SizedBox(
                    width: screenWidth*0.03,
                    height: screenHeight*0.56,
                    child: const CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2),
                  )
                : const Icon(Icons.refresh),
            onPressed: isScanning ? null : _startScan,
          )
        ],
      ),
      body: Column(
        children: [
          if (bleManager.isConnected)
            Container(
              color: Colors.green.withValues(alpha: 0.2),
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Connected to : ${bleManager.targetDevice?.platformName ?? 'Tank'}"),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.techRed),
                    onPressed: () async {
                      await bleManager.disconnect();
                      setState(() {});
                    },
                    child: const Text("Disconnected",
                        style: TextStyle(color: Colors.white)),
                  )
                ],
              ),
            ),
          const Divider(),
          Expanded(
            child: StreamBuilder<List<ScanResult>>(
              stream: bleManager.scanResults,
              initialData: const [],
              builder: (context, snapshot) {
                final results = snapshot.data ?? [];
                if (results.isEmpty) {
                  return const Center(
                    child: Text("No tank detected"),
                  );
                }

                return ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    final result = results[index];
                    final deviceName = result.device.platformName.isNotEmpty
                        ? result.device.platformName
                        : "Unknown device";

                    return ListTile(
                      leading: const Icon(Icons.bluetooth),
                      title: Text(deviceName),
                      subtitle: Text(result.device.remoteId.str),
                      trailing: ElevatedButton(
                          child: const Text("Connect"),
                          onPressed: () async {
                            await bleManager.connectToDevice(result.device);
                            if (context.mounted) {
                              Navigator.pop(context);
                            }
                          }),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
