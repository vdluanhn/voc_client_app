import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

abstract class Bluetooth {
  Future<List<BluetoothDevice>> getDevices();
  Future<bool> connectTo(String address);
  Stream<BluetoothState> connectionState();
  void write(String message);
  Future<bool> disconnect();
}

class BluetoothService implements Bluetooth {
  final flutterBluetoothSerial = FlutterBluetoothSerial.instance;
  late BluetoothConnection bluetoothConnection;

  @override
  Future<List<BluetoothDevice>> getDevices() async {
    List<BluetoothDevice> devices = await flutterBluetoothSerial.getBondedDevices();
    try {
      if (devices.isNotEmpty) {
        return devices;
      }
      return [];
    } on PlatformException {
      print("PlatformException");
      return [];
    }
  }

  @override
  Future<bool> connectTo(String address) async {
    try {
      bluetoothConnection = await BluetoothConnection.toAddress(address);
      return bluetoothConnection.isConnected;
    } catch (e) {
      return false;
    }
  }

  @override
  Stream<BluetoothState> connectionState() {
    return flutterBluetoothSerial.onStateChanged();
  }

  @override
  void write(String message) {
    if (bluetoothConnection.isConnected) {
      bluetoothConnection.output.add(ascii.encode(message));
    }
  }

  @override
  Future<bool> disconnect() async {
    if (bluetoothConnection.isConnected) {
      await bluetoothConnection.close();
      return false;
    }
    return false;
  }
}
