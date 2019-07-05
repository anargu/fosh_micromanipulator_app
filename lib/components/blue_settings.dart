
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:fosh_micromanipulator_app/foshma_colors.dart';
import 'package:fosh_micromanipulator_app/foshma_icons.dart';

class BlueSettings extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BlueSettingsState();
}

class BlueSettingsState extends State<BlueSettings> {

  bool _isConnecting = false;
  String _address;
  // StreamSubscription<BluetoothDiscoveryResult> _streamSubscription;

  @override
  void initState() {
    super.initState();
    // _showSnackbar('Holaaa');
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 52.0,
      left: 20.0,
      child: Container(
        child: !_isConnecting
        ? GestureDetector(
          onTap: () { _showSnackbar('Holaaaa'); }, // _onBlueSettingsTap(context),
          child: Center(
            child: Icon(
              FoshMAIcons.bluetooth, size: 22.0,
              color: FoshMAColors.primaryColor,
              )))
        : CircularProgressIndicator()
      ),
    );
  }


  _onBlueSettingsTap(BuildContext context) {
    return () {
      showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            elevation: 0.0,
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    maxLines: 1,
                    maxLength: 100,
                    autovalidate: true,
                    initialValue: _address,
                    style: TextStyle(fontSize: 14.0),
                    decoration: InputDecoration(
                      labelText: 'Put the Address',
                      // hintText: '',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                      _address = null;
                        return 'Write an address';
                      }
                      _address = value;
                      return null;
                    },
                  ),
                  FlatButton(
                    onPressed: _connect2Address,
                    child: Text('CONNECT')
                  )
                ]
                ),
            ));
        }
      );      
    };
  }

  _connect2Address() async {
    if (_address == null) {
      _showSnackbar('Put an address');
      return;
    }
    _showSnackbar('trying connecting to device');
    setState(() {
      _isConnecting = true;
    });
    // final isConnected = 
    await _connect2BluetoothDevice(_address);
    setState(() {
      _isConnecting = false;
    });
  }


  _showSnackbar(String message) {
    Scaffold.of(context).hideCurrentSnackBar();    
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: FoshMAColors.snackbarColor,
      duration: Duration(seconds: 10),
      action: SnackBarAction(
        label: 'OK',
        onPressed: () {
          Scaffold.of(context).hideCurrentSnackBar();
        },
      ),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  _connect2BluetoothDevice(String address) async {
    // Some simplest connection :F
    try {
      BluetoothConnection connection = await BluetoothConnection.toAddress(address);
      print('Connected to the device');
      _showSnackbar('Connected to the device');

      var dataToSend = Uint8List.fromList(utf8.encode("UP"));
      connection.output.add(dataToSend);
      
      connection.input.listen((Uint8List data) {
          _showSnackbar('Data incoming...');
          print('Data incoming: ${ascii.decode(data)}');
          connection.output.add(data); // Sending data

          if (ascii.decode(data).contains('!')) {
              connection.finish(); // Closing connection
              print('Disconnecting by local host');
              _showSnackbar('Disconnecting by local host');
          }
      }).onDone(() {
        print('Disconnected by remote request');
        _showSnackbar('Disconnected by remote request');
      });
      return true;
    }
    catch (exception) {
        print('Cannot connect, exception occured');
        _showSnackbar('Cannot connect to device, something is missing or error ocurred');
        return false;
    }
  }

}