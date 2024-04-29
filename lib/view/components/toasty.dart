import 'package:flutter/material.dart';

class Toasty {
  static toast(BuildContext context, String alertText,
      {Color backgroundColor = Colors.black, Color textColor = Colors.white}) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        alertText,
        style: TextStyle(color: textColor),
      ),
      backgroundColor: backgroundColor,
    ));
  }
}
