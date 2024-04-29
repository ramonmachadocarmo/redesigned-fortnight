import 'package:flutter/material.dart';
import 'package:monarch/controller/product_controller.dart';
import 'package:monarch/model/product.dart';
import 'package:monarch/view/components/progress.dart';
import 'package:monarch/view/pages/product/product_card.dart';

class ViewProductList extends StatefulWidget {
  const ViewProductList({super.key});

  @override
  State<ViewProductList> createState() => ViewProductListState();
}

class ViewProductListState extends State<ViewProductList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Produtos"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => goToProductFormn(context),
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Product>>(
        future: ProductController().get(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Progress();
            case ConnectionState.done:
              List<Product> products = snapshot.data ?? [];
              if (products.isEmpty) {
                return const Center(
                  child: Text("Sem produtos cadastrados"),
                );
              }
              return ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: WidgetProductCard(product: products[index]),
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

  goToProductFormn(BuildContext context) {
    Navigator.pushNamed(context, 'product_form');
  }
}
