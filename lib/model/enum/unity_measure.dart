enum UnityMeasure {
  unity('un'),
  box('cx'),
  gram('g'),
  quilogram('kg'),
  liter('l'),
  milliliter('ml'),
  unknow('xx');

  const UnityMeasure(this.label);
  final String label;

  String getLabel() {
    return label;
  }

  static UnityMeasure getByCode(String code) {
    return UnityMeasure.values.firstWhere(
        (element) => element.toString() == 'UnityMeasure.$code',
        orElse: () => UnityMeasure.unknow);
  }
}
