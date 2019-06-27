
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'foshma_colors.dart';

class CameraApp extends StatefulWidget {
  @override
  _CameraAppState createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
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

    final childView = !controller.value.isInitialized
    ? Container(
        color: FoshMAColors.black,
        child: Center(
          child: CircularProgressIndicator(backgroundColor: FoshMAColors.primaryColor),
        ),
      )
    : AspectRatio(
        aspectRatio:
        controller.value.aspectRatio,
        child: CameraPreview(controller));


    return Scaffold(
      body: Container(
        child: Stack(
          children: <Widget>[
            childView,

          ]
        ),
      ),
    );
  }

  _initCamera() async {
    cameras = await availableCameras();
    
    controller = CameraController(cameras[0], ResolutionPreset.medium);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  Widget uiControls() {
    
    return Container(
      width: 200,
      height: 200,
      child: Stack(
        children: <Widget>[
          ...[
            {'left': 0.0, 'top': 0.0},
            {'left': 0.0, 'top': 0.0},
            {'left': 0.0, 'top': 0.0},
            {'left': 0.0, 'top': 0.0}
          ].map((v) => Positioned(
            left: v['left'],
            top: v['top'],
            child: GestureDetector(
              onTap: () {},
              child: Container(
                width: 40,
                height: 40,
                color: FoshMAColors.primaryColor,
              ),
            ),
          ))
        ],
      ),
    );
  }
}