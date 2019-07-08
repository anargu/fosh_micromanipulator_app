


import 'package:flutter/material.dart';

import '../foshma_colors.dart';

showSnackbar(BuildContext context, String message) {
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