import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fosh_micromanipulator_app/foshma_colors.dart';
import 'package:fosh_micromanipulator_app/views/visor_view.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primaryColor: FoshMAColors.primaryColor,
        accentColor: FoshMAColors.primaryColor,
        brightness: Brightness.dark
      ),
      home: VisorView(),
    );
  }
}

