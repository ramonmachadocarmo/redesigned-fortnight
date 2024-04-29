class ConverterCustom {
  static double? convertDoubleOptional(dynamic field) {
    if (field is double) return field;
    if (field is int) return field.toDouble();
    return null;
  }

  static double convertDouble(dynamic field) {
    if (field is double) return field;
    if (field is int) return field.toDouble();
    return 0;
  }
}
