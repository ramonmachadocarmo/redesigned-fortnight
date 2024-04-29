import 'package:flutter/material.dart';
import 'package:monarch/view/style/colors.dart';

class StyleConst {
  static TextStyle textPrimaryStyle =
      TextStyle(color: ColorsConst.primaryColor);
  static TextStyle textLabelStyle =
      const TextStyle(color: Colors.black, fontSize: 12);
  static TextStyle textSecondaryStyle =
      TextStyle(color: ColorsConst.secondaryColor);
  static TextStyle textFieldLabel =
      TextStyle(color: ColorsConst.primaryColor, fontWeight: FontWeight.bold);
  static TextStyle textAlertLabel =
      TextStyle(color: ColorsConst.secondaryColor, fontWeight: FontWeight.w900);

  static Text getText(String text) {
    return Text(
      text,
      style: TextStyle(color: ColorsConst.primaryColor, fontSize: 16),
    );
  }

  static Text getTextSecondary(String text) {
    return Text(
      text,
      style: TextStyle(color: ColorsConst.secondaryColor, fontSize: 16),
    );
  }

  static Text getTextLabel(String text) {
    return Text(
      text,
      style: const TextStyle(color: Colors.black, fontSize: 12),
    );
  }

  static Text getTextImportant(String text) {
    return Text(
      text,
      style: TextStyle(color: ColorsConst.accentColor, fontSize: 24),
    );
  }

  static InputDecoration getInputDecoration(String hint, String label) {
    return InputDecoration(
        hintText: hint,
        labelText: label,
        labelStyle: StyleConst.textFieldLabel,
        enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.purple, width: 2),
            borderRadius: BorderRadius.all(Radius.circular(12))));
  }

  static IconButton getConfirmButton(Function callback) {
    return IconButton(
      onPressed: () => callback(),
      icon: const Icon(
        Icons.thumb_up,
        color: Colors.green,
      ),
      iconSize: 56,
    );
  }

  static IconButton getCancelButton(Function callback) {
    return IconButton(
      onPressed: () => callback(),
      icon: const Icon(
        Icons.thumb_down,
        color: Colors.red,
      ),
      iconSize: 56,
    );
  }
}
