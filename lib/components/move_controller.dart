
import 'package:flutter/widgets.dart';
import 'package:fosh_micromanipulator_app/components/snackbar.dart';
import 'package:fosh_micromanipulator_app/foshma_colors.dart';
import 'package:fosh_micromanipulator_app/foshma_icons.dart';
import 'package:fosh_micromanipulator_app/providers/bluetooth_provider.dart';
import 'package:provider/provider.dart';

enum ActionType { UP, DOWN, LEFT, RIGHT }

class MoveController extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MoveControllerState();
}

class MoveControllerState extends State<MoveController> with SingleTickerProviderStateMixin {


  final controls = [
    {
      'left': 60.0,
      'top': 0.0,
      'action': ActionType.UP,
      'icon': FoshMAIcons.arrowUpCircle
    },
    { 'left': 0.0,
      'top': 60.0,
      'action': ActionType.LEFT,
      'icon': FoshMAIcons.arrowLeftCircle
    },
    {
      'left': 120.0,
      'top': 60.0,
      'action': ActionType.RIGHT,
      'icon': FoshMAIcons.arrowRightCircle
    },
    {
      'left': 60.0,
      'top': 120.0,
      'action': ActionType.DOWN,
      'icon': FoshMAIcons.arrowDownCircle
    }
  ];

  BluetoothProvider _bluetoothProvider; 

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _bluetoothProvider = Provider.of<BluetoothProvider>(context);

    return Positioned(
      bottom: 20.0,
      right: 20.0,
      child: Container(
        width: 180,
        height: 180,
        child: Stack(
          children: <Widget>[
            ...controls.map((v) => Positioned(
              left: v['left'],
              top: v['top'],
              child: GestureDetector(
                onTap: _onTapAction(v['action']),
                child: Container(
                  decoration: BoxDecoration(
                    color: FoshMAColors.primaryColor,
                    shape: BoxShape.circle
                  ),
                  width: 60,
                  height: 60,
                  child: Center(child: Icon(v['icon'], size: 32.0, color: FoshMAColors.darkColor)),
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }

  _onTapAction(ActionType action) {
    return () {
      try {
        print('action triggered ${action.toString()}');
        _bluetoothProvider.putValue(action.toString());
      } catch (e) {
        showSnackbar(context, e.toString());
      }
    };
  }
}