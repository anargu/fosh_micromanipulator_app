
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:fosh_micromanipulator_app/components/blue_settings.dart';
import 'package:fosh_micromanipulator_app/components/move_controller.dart';
import 'package:fosh_micromanipulator_app/foshma_colors.dart';
import 'package:fosh_micromanipulator_app/providers/bluetooth_provider.dart';
import 'package:provider/provider.dart';


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
          return ChangeNotifierProvider(
            builder: (context) => BluetoothProvider(),
            child: Container(
              child: Stack(
                children: <Widget>[
                  childView,
                  MoveController(),
                  BlueSettings()
                ]
              ),
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
}