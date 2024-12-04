import 'package:expense_book/style_resources/colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

const kMediumTextStyle = TextStyle(color: kBlackColor, fontSize: 16);
const kBigTextStyle = TextStyle(color: kBlackColor, fontSize: 18);
const kLightTextStyle = TextStyle(color: kBlackColor, fontSize: 14);
const kHintTextStyle = TextStyle(color: kTextGreyColor, fontSize: 14, fontWeight: FontWeight.normal);
const kCreditTextStyle = TextStyle(fontSize: 20, color: kGreenColor);
const kDebitTextStyle = TextStyle(fontSize: 20, color: kRedColor);

Future<void> toastMessage(String text) {
  return Fluttertoast.showToast(
    msg: text,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.black87,
    timeInSecForIosWeb: 1,
  );
}
