import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'dart:typed_data';

class BluetoothManager {
  static final BluetoothManager _instance = BluetoothManager._internal();
  factory BluetoothManager() => _instance;
  BluetoothManager._internal();

  BluetoothDevice? _device;
  BluetoothCharacteristic? _commandCharacteristic;
  BluetoothCharacteristic? _batteryCharacteristic;
  BluetoothCharacteristic? _speedCharacteristic;

  bool _isScanning = false;

  final String targetDeviceName = "MOUHAHA";

  final Guid serviceUuid = Guid("19B10000-E8F2-537E-4F6C-D104768A1214");
  final Guid characteristicUuid = Guid("19B10001-E8F2-537E-4F6C-D104768A1214");

  final Guid batteryServiceUuid = Guid("19B10000-E8F2-537E-4F6C-D104768A1214");
  final Guid batteryCharacteristicUuid = Guid("19B10002-E8F2-537E-4F6C-D104768A1214");

  final Guid speedServiceUuid = Guid("19B10000-E8F2-537E-4F6C-D104768A1214");
  final Guid speedCharacteristicUuid = Guid("19B10003-E8F2-537E-4F6C-D104768A1214");

  final StreamController<double> _batteryStreamController = StreamController<double>.broadcast();
  Stream<double> get batteryStream => _batteryStreamController.stream;

  void start() {
    _startScan();
  }

  Future<bool> requestBluetoothPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location
    ].request();

    return statuses.values.every((status) => status.isGranted);
  }

  void _startScan() async {
    if (_isScanning) return;

    print(" ========== trying to ask permissions =============================");
    var status = await requestBluetoothPermissions();
    if (!status) {
      print(" ========== perm not allowed =============================");
      return;
    }


    var locationStatus = await Permission.locationWhenInUse.serviceStatus;
    if (locationStatus.isDisabled) {
      print("Le GPS est désactivé ! Veuillez activer la localisation dans les paramètres d'Android");
      return;
    }


    bool isOn = await FlutterBluePlus.isOn;
    if (!isOn) {
      print("Bluetooth is off. Please enable Bluetooth.");
      return;
    }

    _isScanning = true;
    print("========== Starting Scan ==========");

    try {
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));
      FlutterBluePlus.scanResults.listen((results) async {
        for (ScanResult r in results) {
          String deviceName = r.advertisementData.advName.isNotEmpty
              ? r.advertisementData.advName
              : r.device.platformName;
          print("result : ${r.device}");


          if (deviceName == targetDeviceName && _device == null) {
            print("Found device: $deviceName. Stopping scan and connecting...");
            _isScanning = false;
            await FlutterBluePlus.stopScan();
            await _connectToDevice(r.device);
            break;
          }
        }
      });


    } catch (e) {
      print("Erreur scan: $e");
      _isScanning = false;
    }

    FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));
  }

  Future<void> _connectToDevice(BluetoothDevice device) async {
    try {
      await device.connect(autoConnect: false);
      _device = device;
      print("Connected to ${device.platformName}");

      List<BluetoothService> services = await device.discoverServices();

      for (var service in services) {
        if (service.uuid == serviceUuid) {
          for (var characteristic in service.characteristics) {
            if (characteristic.uuid == characteristicUuid) {
              _commandCharacteristic = characteristic;
              print("Characteristic found and ready !");
            }
            if(characteristic.uuid == batteryCharacteristicUuid){
              _batteryCharacteristic = characteristic;
              print("Battery characteristic ready");
              _listenToBattery();
            }
            if(characteristic.uuid == speedCharacteristicUuid){
              _speedCharacteristic = characteristic;
            }
          }
        }
      }
    } catch (e) {
      print("Error during connection: $e");
      _device = null;
      _isScanning = false;
    }
  }


  void _listenToBattery() async {
    if(_batteryCharacteristic == null) return;

    try{
      await _batteryCharacteristic!.setNotifyValue(true);

      _batteryCharacteristic!.onValueReceived.listen((value) {
        if(value.isNotEmpty){
          if(value.length >= 4){
            ByteData byteData = ByteData.sublistView(Uint8List.fromList(value));
            double voltage = byteData.getFloat32(0, Endian.little);
            _batteryStreamController.add(voltage);
          }
        }
      });
    } catch(e){
      print("Error battery notification");
    }
  }

  void setSpeed(int speed) async{
    if(_speedCharacteristic != null){
      int clampedSpeed = speed.clamp(0, 255);
      await _speedCharacteristic!.write([clampedSpeed]);
    }
  }


  void stop() async {
    await _commandCharacteristic?.write([0x00]);
  }

  void forward() async {
    await _commandCharacteristic?.write([0x01]);
  }

  void backward() async {
    await _commandCharacteristic?.write([0x02]);
  }

  void turnLeft() async {
    await _commandCharacteristic?.write([0x03]);
  }

  void turnRight() async {
    await _commandCharacteristic?.write([0x04]);
  }

  void rotateLeft() async {
    await _commandCharacteristic?.write([0x06]);
  }

  void rotateRight() async {
    await _commandCharacteristic?.write([0x05]);
  }

  void turnLeftBack() async {
    await _commandCharacteristic?.write([0x07]);
  }

  void turnRightBack() async {
    await _commandCharacteristic?.write([0x08]);
  }
}