import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'dart:typed_data';

class BluetoothManager {
  static final BluetoothManager _instance = BluetoothManager._internal();
  factory BluetoothManager() => _instance;
  BluetoothManager._internal();

  BluetoothDevice? targetDevice;

  BluetoothCharacteristic? _commandCharacteristic;
  BluetoothCharacteristic? _batteryCharacteristic;
  BluetoothCharacteristic? _speedCharacteristic;

  final String targetDeviceName = "MOUHAHA";

  final Guid serviceUuid = Guid("19B10000-E8F2-537E-4F6C-D104768A1214");
  final Guid characteristicUuid = Guid("19B10001-E8F2-537E-4F6C-D104768A1214");

  final Guid batteryServiceUuid = Guid("19B10000-E8F2-537E-4F6C-D104768A1214");
  final Guid batteryCharacteristicUuid = Guid("19B10002-E8F2-537E-4F6C-D104768A1214");

  final Guid speedServiceUuid = Guid("19B10000-E8F2-537E-4F6C-D104768A1214");
  final Guid speedCharacteristicUuid = Guid("19B10003-E8F2-537E-4F6C-D104768A1214");

  final StreamController<double> _batteryStreamController = StreamController<double>.broadcast();
  Stream<double> get batteryStream => _batteryStreamController.stream;

  final StreamController<bool> _connectionStateController = StreamController<bool>.broadcast();
  Stream<bool> get connectionStateStream => _connectionStateController.stream;

  bool _isConnected = false;
  bool get isConnected => _isConnected;

  Stream<List<ScanResult>> get scanResults => FlutterBluePlus.scanResults;

  void start() {
    startScan();
  }

  Future<bool> requestBluetoothPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location
    ].request();

    return statuses.values.every((status) => status.isGranted);
  }


  Future<void> startScan() async {
    if(await FlutterBluePlus.isSupported == false) return;

    await FlutterBluePlus.startScan(
      withServices: [serviceUuid],
      timeout: const Duration(seconds: 4),
    );
  }

  Future<void> stopScan() async{
    await FlutterBluePlus.stopScan();
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    await stopScan();

    try{
      await device.connect(timeout: const Duration(seconds: 5));
      targetDevice = device;
      _isConnected = true;
      _connectionStateController.add(true);

      device.connectionState.listen((state) {
        if(state == BluetoothConnectionState.disconnected){
          _isConnected = false;
          _connectionStateController.add(false);
        }
      });

      await _discoverServices(device);
    } catch(e) {
      print("ERROR connection : $e");
      _isConnected = false;
      _connectionStateController.add(false);
    }
  }


  Future<void> disconnect() async {
    if(targetDevice != null){
      await targetDevice!.disconnect();
      _isConnected = false;
      _connectionStateController.add(false);
    }
  }

  Future<void> _discoverServices(BluetoothDevice device) async {
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