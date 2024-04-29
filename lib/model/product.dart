import 'package:monarch/utils/converter.dart';

class Product {
  String? id;
  String code;
  String name;
  String category;
  String description;
  String measureUnit;
  String? measureUnit2;
  double? stockMin;
  double? stockMax;
  double? stockCurrent;
  double? pricePurchase;
  double? priceSale;
  String? imageUrl =
      'https://primordio-assets.s3.us-east-2.amazonaws.com/logo.png';

  Product(
    this.code,
    this.category,
    this.name,
    this.description,
    this.measureUnit,
  );

  bool setMeasureUnit2(String mu2) {
    if (mu2 == measureUnit) {
      return false;
    }
    measureUnit2 = mu2;
    return true;
  }

  // ! CRIAR EXCEPTIONS & INTERNACIONALIZAÇÃO
  // ! OVERRIDE MÉTODOS TOSTRING
  String setStockMin(double qty) {
    if (qty < 0) {
      return "Estoque não pode ser negativo";
    }
    if (stockMax != null && qty > stockMax!) {
      return "Estoque mínimo precisa ser menor ou igual ao máximo";
    }
    stockMin = qty;
    return "";
  }

  String setStockMax(double qty) {
    if (qty < 0) {
      return "Estoque não pode ser negativo";
    }
    if (stockMin != null && qty < stockMin!) {
      return "Estoque máximo precisa ser maior ou igual ao máximo";
    }
    stockMax = qty;
    return "";
  }

  String setStock(double qty) {
    if (qty < 0) {
      return "Estoque não pode ser negativo";
    }
    stockCurrent = qty;
    return "";
  }

  String setPurchasePrice(double price) {
    if (price <= 0) {
      return "Preço não pode ser menor ou igual a zero";
    }
    pricePurchase = price;
    return "";
  }

  String setSalePrice(double price) {
    if (price <= 0) {
      return "Preço não pode ser menor ou igual a zero";
    }
    priceSale = price;
    return "";
  }

  Map<String, dynamic> toJson() => {
        'code': code,
        'name': name,
        'category': category,
        'description': description,
        'measureUnit': measureUnit,
        'measureUnit2': measureUnit2,
        'stockMin': stockMin,
        'stockMax': stockMax,
        'stockCurrent': stockCurrent,
        'pricePurchase': pricePurchase,
        'priceSale': priceSale,
      };

  Product.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        code = json['code'],
        name = json['name'],
        category = json['category'],
        description = json['description'],
        measureUnit = json['measureUnit'],
        measureUnit2 = json['measureUnit2'],
        stockMin = ConverterCustom.convertDoubleOptional(json['stockMin']),
        stockMax = ConverterCustom.convertDoubleOptional(json['stockMax']),
        stockCurrent =
            ConverterCustom.convertDoubleOptional(json['stockCurrent']),
        pricePurchase =
            ConverterCustom.convertDoubleOptional(json['pricePurchase']),
        priceSale = ConverterCustom.convertDoubleOptional(json['priceSale']);
}
