

import 'package:flutter/material.dart';
import 'package:fosh_micromanipulator_app/components/snackbar.dart';
import 'package:fosh_micromanipulator_app/foshma_colors.dart';
import 'package:fosh_micromanipulator_app/foshma_icons.dart';
import 'package:fosh_micromanipulator_app/providers/bluetooth_provider.dart';
import 'package:provider/provider.dart';

class BlueSettings extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => BlueSettingsState();
}

class BlueSettingsState extends State<BlueSettings> {

  bool _isConnecting = false;
  String _address;
  BluetoothProvider _bluetoothProvider; 

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _bluetoothProvider = Provider.of<BluetoothProvider>(context);
    
    return Positioned(
      top: 52.0,
      left: 20.0,
      child: Container(
        child: !_isConnecting
        ? GestureDetector(
          onTap: _onBlueSettingsTap(context),
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
            backgroundColor: FoshMAColors.darkColor,
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
                    onPressed: _onTap2Connect,
                    child: Text(
                      'CONNECT',
                      style: TextStyle(color: FoshMAColors.primaryColor)),
                  )
                ]
                ),
            ));
        }
      );      
    };
  }

  _onTap2Connect() async {
    if (_address == null) {
      showSnackbar(context, 'Put an address');
      return;
    }
    showSnackbar(context, 'trying connecting to device');
    setState(() {
      _isConnecting = true;
    });
    // final isConnected = 
    await _connect2BluetoothDevice(_address);
    setState(() {
      _isConnecting = false;
    });
  }

  _connect2BluetoothDevice(String address) async {
    // Some simplest connection :F
    try {
      await _bluetoothProvider.connect2Device(address);
      print('Connected to the device');
      showSnackbar(context, 'Connected to the device');
      return true;
    } catch (exception) {
      print('Cannot connect, exception occured');
      showSnackbar(context, 'Cannot connect to device, something is missing or error ocurred or bluetooth is not enabled');
      return false;
    }
  }
}