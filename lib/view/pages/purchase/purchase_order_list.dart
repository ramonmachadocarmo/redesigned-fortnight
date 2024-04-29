import 'package:flutter/material.dart';
import 'package:monarch/controller/purchase_order_controller.dart';
import 'package:monarch/model/purchase_order.dart';
import 'package:monarch/view/components/progress.dart';
import 'package:monarch/view/pages/purchase/purchase_order_card.dart';

class ViewPurchaseOrderList extends StatefulWidget {
  const ViewPurchaseOrderList({super.key});

  @override
  State<ViewPurchaseOrderList> createState() => ViewPurchaseOrderListState();
}

class ViewPurchaseOrderListState extends State<ViewPurchaseOrderList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pedidos de compra"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => goToPurchaseOrderForm(context),
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<PurchaseOrder>>(
        future: PurchaseOrderController().get(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Progress();
            case ConnectionState.done:
              List<PurchaseOrder> purchaseOrders = snapshot.data ?? [];
              if (purchaseOrders.isEmpty) {
                return const Center(
                  child: Text("Sem pedidos de compra"),
                );
              }
              return ListView.builder(
                itemCount: purchaseOrders.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: WidgetPurchaseOrderCard(
                        purchaseOrder: purchaseOrders[index]),
                  );
                },
              );
            default:
              return const SizedBox();
          }
        },
      ),
    );
  }

  goToPurchaseOrderForm(BuildContext context) {
    Navigator.pushNamed(context, 'purchaseOrder_form');
  }
}
