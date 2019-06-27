
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'foshma_colors.dart';

class MiscroscopeVisorView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MiscroscopeVisorViewState();
}

class MiscroscopeVisorViewState extends State<MiscroscopeVisorView> {
  CameraController controller;
  List<CameraDescription> cameras;
  
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
      body: Container(
        child: Stack(
          children: <Widget>[
            childView,
            uiControls()
          ]
        ),
      ),
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

  Widget uiControls() {
    return Positioned(
      bottom: 0.0,
      right: 0.0,
      child: Container(
        width: 180,
        height: 180,
        child: Stack(
          children: <Widget>[
            ...[
              // x    0   60  120 
              // 0    x   .    x 
              // 60   .   x    . 
              // 120  x   .    x 
              
              {'left': 60.0, 'top': 0.0},
              {'left': 0.0, 'top': 60.0},
              {'left': 120.0, 'top': 60.0},
              {'left': 60.0, 'top': 120.0}
            ].map((v) => Positioned(
              left: v['left'],
              top: v['top'],
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  decoration: BoxDecoration(
                    color: FoshMAColors.primaryColor,
                    shape: BoxShape.circle
                  ),
                  width: 60,
                  height: 60,
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }
}