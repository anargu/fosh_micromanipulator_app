
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothProvider extends ChangeNotifier {

  static bool _isOn = false;
  BluetoothConnection _connection;
  StreamSubscription<BluetoothDiscoveryResult> _streamSubscription;

  BluetoothConnection get connection => _connection;
  set connection(value) {
    _connection = value;
    notifyListeners();
  }
  

  get isOn => _isOn;
  set isOn (value) {
    _isOn = value;
    notifyListeners();
  }

  Future<bool> checkBluetoothEnabled() async {
    isOn = await FlutterBluetoothSerial.instance.isEnabled;
    if (!isOn) {
      isOn = await FlutterBluetoothSerial.instance.requestEnable();
      print('*** requestResult $isOn');
      if (!isOn) {
        throw Exception('bluetooth is not turned on');
      }
      return isOn;
    }
    return isOn;
  }

  Future<bool> connect2Device(String address) async {
    try {
      await checkBluetoothEnabled();
      connection = await BluetoothConnection.toAddress(address);
      print('Connected to the device');
      return true;
    } catch (e) {
      throw e;
    }
  }

  putValue(String value) {
      print('value to be send: $value ...');
    if (connection == null) {
      throw Exception('Connection was lost or it was not initialized');
    }
    var dataToSend = Uint8List.fromList(utf8.encode(value));
    connection.output.add(dataToSend);
  }

  Stream<Uint8List> get listenInputData {
    if (connection == null) {
      throw Exception('Connection was lost or it was not initialized');
    }
    return connection.input;
  }

  discoverBlueDevices() async {
    await checkBluetoothEnabled();
    _streamSubscription = FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
      print('*** device found ${r.device.name} - ${r.device.address}\n');
      // setState(() { results.add(r); });
    });
    
    _streamSubscription.onDone(() {
      // setState(() { isDiscovering = false; });
    });
  }

  // connection.input.listen((Uint8List data) {
  //     _showSnackbar('Data incoming...');
  //     print('Data incoming: ${ascii.decode(data)}');
  //     connection.output.add(data); // Sending data

  //     if (ascii.decode(data).contains('!')) {
  //         connection.finish(); // Closing connection
  //         print('Disconnecting by local host');
  //         _showSnackbar('Disconnecting by local host');
  //     }
  // }).onDone(() {
  //   print('Disconnected by remote request');
  //   _showSnackbar('Disconnected by remote request');
  // });
}