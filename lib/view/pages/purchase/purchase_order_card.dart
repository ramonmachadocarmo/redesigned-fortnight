import 'package:flutter/material.dart';
import 'package:monarch/model/purchase_order.dart';
import 'package:monarch/utils/formatter.dart';
import 'package:monarch/view/style/style.dart';

class WidgetPurchaseOrderCard extends StatelessWidget {
  const WidgetPurchaseOrderCard({super.key, required this.purchaseOrder});
  final PurchaseOrder purchaseOrder;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => goToPurchaseOrderDetail(context),
      child: Card(
        child: ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StyleConst.getText("Nro.: ${purchaseOrder.number}"),
              StyleConst.getText(
                  "Valor: ${FormatterCustom.currencyToString(purchaseOrder.value - purchaseOrder.discount)}"),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  StyleConst.getText("Fornecedor: "),
                  StyleConst.getText(purchaseOrder.supplier.fantasyName),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StyleConst.getTextLabel('Valor total:'),
                  StyleConst.getTextLabel('Status:'),
                  StyleConst.getTextLabel('Desconto total:'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StyleConst.getTextSecondary(
                      FormatterCustom.currencyToString(purchaseOrder.value)),
                  StyleConst.getTextSecondary(purchaseOrder.status),
                  StyleConst.getTextSecondary(
                      FormatterCustom.currencyToString(purchaseOrder.discount)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  goToPurchaseOrderDetail(BuildContext context) {
    Navigator.pushNamed(context, 'purchaseOrder_detail',
        arguments: purchaseOrder);
  }
}
