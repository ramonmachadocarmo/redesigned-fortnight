// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:monarch/controller/purchase_order_controller.dart';
import 'package:monarch/model/purchase_order.dart';
import 'package:monarch/model/purchase_order_item.dart';
import 'package:monarch/utils/formatter.dart';
import 'package:monarch/view/components/toasty.dart';
import 'package:monarch/view/style/style.dart';

import '../../components/loading_dialog.dart';

class ViewPurchaseOrderDetail extends StatefulWidget {
  const ViewPurchaseOrderDetail({super.key, required this.purchaseOrder});
  final PurchaseOrder purchaseOrder;

  @override
  State<ViewPurchaseOrderDetail> createState() =>
      _ViewPurchaseOrderDetailState();
}

class _ViewPurchaseOrderDetailState extends State<ViewPurchaseOrderDetail> {
  PurchaseOrderController pc = PurchaseOrderController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.purchaseOrder.number),
      ),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    StyleConst.getTextLabel("CNPJ:"),
                    StyleConst.getTextSecondary(
                        widget.purchaseOrder.supplier.cnpj),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    StyleConst.getTextLabel("Razão social:"),
                    StyleConst.getTextSecondary(
                        widget.purchaseOrder.supplier.name),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    StyleConst.getTextLabel("Nome fantasia:"),
                    StyleConst.getTextSecondary(
                        widget.purchaseOrder.supplier.fantasyName),
                  ],
                ),
                const Divider(),
                Row(
                  children: [
                    StyleConst.getTextLabel('Situação: '),
                    StyleConst.getTextSecondary(widget.purchaseOrder.status),
                  ],
                ),
                Row(
                  children: [
                    StyleConst.getTextLabel('Condição pagamento: '),
                    StyleConst.getTextSecondary(
                        widget.purchaseOrder.paymentCondition ?? "A DEFINIR"),
                  ],
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    StyleConst.getTextLabel('Valor total'),
                    StyleConst.getTextLabel('Desconto total'),
                    StyleConst.getTextLabel('Quantidade itens'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    StyleConst.getTextSecondary(
                        FormatterCustom.currencyToString(
                            widget.purchaseOrder.value)),
                    StyleConst.getTextSecondary(
                        FormatterCustom.currencyToString(
                            widget.purchaseOrder.discount)),
                    StyleConst.getTextSecondary(FormatterCustom.numberToString(
                        widget.purchaseOrder.items.length)),
                  ],
                ),
                const Divider(),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: ListView.builder(
                itemCount: widget.purchaseOrder.items.length,
                itemBuilder: (context, index) {
                  PurchaseOrderItem item = widget.purchaseOrder.items[index];
                  return Card(
                    child: ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          StyleConst.getText(item.product.code),
                          StyleConst.getText(item.product.name),
                        ],
                      ),
                      subtitle: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              StyleConst.getTextLabel('Preço'),
                              StyleConst.getTextLabel('Desconto'),
                              StyleConst.getTextLabel('Quantidade'),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              StyleConst.getTextSecondary(
                                  FormatterCustom.currencyToString(item.price)),
                              StyleConst.getTextSecondary(
                                  FormatterCustom.currencyToString(
                                      item.discount)),
                              StyleConst.getTextSecondary(
                                  FormatterCustom.numberToString(
                                      item.quantity)),
                            ],
                          ),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              StyleConst.getTextLabel('Preço total'),
                              StyleConst.getTextLabel('Desconto total'),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              StyleConst.getTextSecondary(
                                  FormatterCustom.currencyToString(
                                      item.price * item.quantity)),
                              StyleConst.getTextSecondary(
                                  FormatterCustom.currencyToString(
                                      item.discount * item.quantity)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          widget.purchaseOrder.status == 'PENDENTE'
              ? Container(
                  color: Colors.grey.shade300,
                  height: MediaQuery.of(context).size.height * .1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        StyleConst.getCancelButton(() => cancelPO(context)),
                        StyleConst.getConfirmButton(() => confirmPO(context)),
                      ],
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  goToEdit(BuildContext context) {
    Navigator.popAndPushNamed(context, 'purchaseOrder_form',
        arguments: widget.purchaseOrder);
  }

  deletePurchaseOrder(BuildContext context) async {
    loadingDialog(context, message: "Excluindo fornecedor...");
    try {
      await pc.delete(widget.purchaseOrder);
    } on Exception catch (e) {
      Toasty.toast(context, e.toString(), backgroundColor: Colors.red);
    }

    Navigator.pop(context);
  }

  confirmPO(BuildContext context) async {
    loadingDialog(context, message: "Confirmando pedido de compra...");
    try {
      await pc.confirm(widget.purchaseOrder);
    } on Exception catch (e) {
      Toasty.toast(context, e.toString(), backgroundColor: Colors.red);
    }
    Navigator.pop(context);
  }

  cancelPO(BuildContext context) {}
}
