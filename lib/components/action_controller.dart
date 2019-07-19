
import 'package:flutter/widgets.dart';
import 'package:fosh_micromanipulator_app/components/snackbar.dart';
import 'package:fosh_micromanipulator_app/constants.dart';
import 'package:fosh_micromanipulator_app/providers/bluetooth_provider.dart';
import 'package:provider/provider.dart';

import '../foshma_colors.dart';

class ActionController extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ActionControllerState();
}

class ActionControllerState extends State<ActionController> {

  BluetoothProvider _bluetoothProvider; 

  final controls = [
    {
      'left': 60.0,
      'top': 0.0,
      'action': ActionType.A,
      'text': 'A'
    },
    { 'left': 0.0,
      'top': 60.0,
      'action': ActionType.B,
      'text': 'B'
    }
  ];

  @override
  Widget build(BuildContext context) {
    _bluetoothProvider = Provider.of<BluetoothProvider>(context);
    return Positioned(
      bottom: 20.0,
      left: 20.0,
      child: Container(
        width: 180,
        height: 180,
        child: Stack(
          children: <Widget>[
            ...controls.map((v) => Positioned(
              left: v['left'],
              bottom: v['top'],
              child: GestureDetector(
                onTap: _onTapAction(v['action']),
                child: Container(
                  decoration: BoxDecoration(
                    color: FoshMAColors.primaryColor,
                    shape: BoxShape.circle
                  ),
                  width: 60,
                  height: 60,
                  child: Center(
                    child: Text(v['text'],
                    style: TextStyle(
                      color: FoshMAColors.darkColor,
                      fontSize: 20.0, fontWeight: FontWeight.bold))),
                ),
              ),
            )
            )
          ],
        ),
      )
    );
  }

  _onTapAction (ActionType action) {
    return () {
      try {
        print('action triggered ${action.toString()}');
        switch (action) {
          case ActionType.A:
            _bluetoothProvider.putValue('A\n');        
            break;
          case ActionType.B:
            _bluetoothProvider.putValue('B\n');
            break;
          default:
        }
      } catch (e) {
        showSnackbar(context, e.toString());
      }
    };
  }

}