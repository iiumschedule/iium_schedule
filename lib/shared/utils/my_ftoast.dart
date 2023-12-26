import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MyFtoast {
  static final FToast _fToast = FToast();

  static void show(BuildContext context, String message) {
    _fToast.init(context);
    _fToast.removeCustomToast();
    _fToast.showToast(
      toastDuration: const Duration(seconds: 3),
      child: Container(
        padding: const EdgeInsets.all(8),
        color: Colors
            .grey[Theme.of(context).brightness == Brightness.dark ? 800 : 300],
        child: Text(message),
      ),
    );
  }
}
