enum CategoryPrd {
  disposable('Descartáveis', 'DESC'),
  packaging('Embalagens', 'EMB'),
  polystyrene('Isopor', 'ISO', CategoryPrd.disposable),
  polyethylene('Polietireno', 'POL', CategoryPrd.disposable),
  bowl('Cumbuca', 'CMB', CategoryPrd.packaging),
  unknown(
    'N/A',
    '',
  );

  const CategoryPrd(this.label, this.cod, [this.parent]);
  final String label;
  final String cod;
  final CategoryPrd? parent;

  String getLabel() {
    return label;
  }

  String getFullLabel() {
    String newLabel = label;
    if (parent != null) {
      newLabel = '${parent!.getFullLabel()} > $label';
    }
    return newLabel;
  }

  static CategoryPrd getByCode(String code) {
    return CategoryPrd.values.firstWhere((element) => element.cod == code,
        orElse: () => CategoryPrd.unknown);
  }
}
