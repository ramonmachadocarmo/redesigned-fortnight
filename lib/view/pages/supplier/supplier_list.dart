import 'package:flutter/material.dart';
import 'package:monarch/controller/supplier_controller.dart';
import 'package:monarch/model/supplier.dart';
import 'package:monarch/view/components/progress.dart';
import 'package:monarch/view/pages/supplier/supplier_card.dart';

class ViewSupplierList extends StatefulWidget {
  const ViewSupplierList({super.key});

  @override
  State<ViewSupplierList> createState() => ViewSupplierListState();
}

class ViewSupplierListState extends State<ViewSupplierList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fornecedores"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => goToSupplierForm(context),
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Supplier>>(
        future: SupplierController().get(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Progress();
            case ConnectionState.done:
              List<Supplier> suppliers = snapshot.data ?? [];
              if (suppliers.isEmpty) {
                return const Center(
                  child: Text("Sem fornecedores cadastrados"),
                );
              }
              return ListView.builder(
                itemCount: suppliers.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: WidgetSupplierCard(supplier: suppliers[index]),
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

  goToSupplierForm(BuildContext context) {
    Navigator.pushNamed(context, 'supplier_form');
  }
}
