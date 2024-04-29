import 'package:flutter/material.dart';
import 'package:monarch/model/supplier.dart';
import 'package:monarch/utils/formatter.dart';
import 'package:monarch/view/style/style.dart';

class WidgetSupplierCard extends StatelessWidget {
  const WidgetSupplierCard({super.key, required this.supplier});
  final Supplier supplier;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => goToSupplierDetail(context),
      child: Card(
        child: ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StyleConst.getText(supplier.fantasyName),
              StyleConst.getText(supplier.cnpj),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  StyleConst.getText("Razão social: "),
                  StyleConst.getText(
                      FormatterCustom.numberToString(supplier.fantasyName)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  goToSupplierDetail(BuildContext context) {
    Navigator.pushNamed(context, 'supplier_detail', arguments: supplier);
  }
}
