
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:fosh_micromanipulator_app/components/blue_settings.dart';
import 'package:fosh_micromanipulator_app/components/move_controller.dart';
import 'package:fosh_micromanipulator_app/foshma_colors.dart';


class VisorView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => VisorViewState();
}

class VisorViewState extends State<VisorView> {
  CameraController controller;
  List<CameraDescription> cameras;

  List<BluetoothDiscoveryResult> results = List<BluetoothDiscoveryResult>();
  bool isDiscovering;
  
  @override
  void initState() {
    super.initState();
    
    _initCamera();
    // _startDiscovery();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool hasInit = false;
    if (controller != null) {
      if (controller.value.isInitialized) {
        hasInit = true;
      }
    }

    final deviceSize = MediaQuery.of(context).size;
    final deviceRatio = (deviceSize.width / deviceSize.height);
    final childView = !hasInit
    ? Container(
        color: FoshMAColors.black,
        child: Center(
          child: CircularProgressIndicator(backgroundColor: FoshMAColors.primaryColor),
        ),
      )
    : Transform.scale(
        scale: controller.value.aspectRatio / deviceRatio,
        child: Center(
          child: AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: CameraPreview(controller)
          ),
        ),
    );


    return Scaffold(
      body: Builder(
        builder: (context) {
          return Container(
            child: Stack(
              children: <Widget>[
                childView,
                MoveController(),
                BlueSettings()
              ]
            ),
          );
        },
      )
    );
  }

  _initCamera() async {
    cameras = await availableCameras();
    
    controller = CameraController(
      cameras[0],
      ResolutionPreset.medium,
      enableAudio: false
    );
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  // void _startDiscovery() async {
  //   final bool isOn = await FlutterBluetoothSerial.instance.isEnabled;
  //   if (!isOn) {
  //     final requestResult = await FlutterBluetoothSerial.instance.requestEnable();
  //     print('*** requestResult $requestResult');
  //   }
  //   _streamSubscription = FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
  //     print('*** device found ${r.device.name} - ${r.device.address}\n');
  //     setState(() { results.add(r); });
  //   });
    
  //   _streamSubscription.onDone(() {
  //     setState(() { isDiscovering = false; });
  //   });
  // }

}