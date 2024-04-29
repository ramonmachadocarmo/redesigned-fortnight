import 'package:flutter/material.dart';
import 'package:monarch/model/enum/unity_measure.dart';
import 'package:monarch/model/product.dart';
import 'package:monarch/utils/formatter.dart';
import 'package:monarch/view/style/style.dart';

class WidgetProductCard extends StatelessWidget {
  const WidgetProductCard({super.key, required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => goToProductDetail(context),
      child: Card(
        child: ListTile(
          trailing: Image.network(product.imageUrl ??
              'https://primordio-assets.s3.us-east-2.amazonaws.com/logo.png'),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  StyleConst.getText("Nome: "),
                  StyleConst.getText(product.name),
                ],
              ),
              StyleConst.getText(product.category),
              StyleConst.getText(product.code),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  StyleConst.getText("Estoque atual: "),
                  StyleConst.getText(
                      FormatterCustom.numberToString(product.stockCurrent)),
                  StyleConst.getText(
                      UnityMeasure.getByCode(product.measureUnit).label),
                ],
              ),
              Row(
                children: [
                  StyleConst.getText("Preço: "),
                  StyleConst.getText(
                      FormatterCustom.currencyToString(product.pricePurchase)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  goToProductDetail(BuildContext context) {
    Navigator.pushNamed(context, 'product_detail', arguments: product);
  }
}
