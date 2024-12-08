import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future<void> toastMessage(String text) {
  return Fluttertoast.showToast(
    msg: text,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.black87,
    timeInSecForIosWeb: 1,
  );
}

