class Supplier {
  String? id;
  String cnpj;
  String name;
  String fantasyName;

  Supplier(this.cnpj, this.name, this.fantasyName);

  Map<String, dynamic> toJson() => {
        'cnpj': cnpj,
        'name': name,
        'fantasyName': fantasyName,
      };

  Supplier.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        cnpj = json['cnpj'],
        name = json['name'],
        fantasyName = json['fantasyName'];
}
