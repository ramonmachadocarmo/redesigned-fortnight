import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class FormatterCustom {
  static String numberToString(dynamic value) {
    if (value == null || value == "null") {
      return "";
    }
    return value.toString();
  }

  static String currencyToString(double? value) {
    if (value == null) {
      return "";
    }
    return "R\$ ${value.toStringAsFixed(2)}";
  }

  static String brDateToUs(String date) {
    return "${date.substring(6)}-${date.substring(3, 5)}-${date.substring(0, 2)}";
  }

  static MaskTextInputFormatter dateFormatter() {
    return MaskTextInputFormatter(
      mask: "##/##/####",
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy,
    );
  }

  static MaskTextInputFormatter numberFormatter() {
    return MaskTextInputFormatter(
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy,
    );
  }
}
