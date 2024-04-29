class ValidateCustom {
  static String? isTextNotEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return 'Campo obrigatório';
    }
    return null;
  }

  static String? isTextDoubleNonObrigat(String? value) {
    if (value == null || value.isEmpty) return null;
    if (double.tryParse(value) is double) return null;
    return "Valor inválido";
  }

  static String? isTextDouble(String? value) {
    if (value == null || value.isEmpty) return "Campo obrigatório";
    if (double.tryParse(value) is! double) return "Valor inválido";
    return null;
  }

  static String? isTextInt(String? value) {
    if (value == null || value.isEmpty) return "Campo obrigatório";
    if (int.tryParse(value) is! int) return "Valor inválido";
    return null;
  }
}
