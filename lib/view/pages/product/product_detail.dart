// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:monarch/controller/product_controller.dart';
import 'package:monarch/model/product.dart';
import 'package:monarch/utils/formatter.dart';
import 'package:monarch/view/components/toasty.dart';
import 'package:monarch/view/style/style.dart';

import '../../components/loading_dialog.dart';

class ViewProductDetail extends StatefulWidget {
  const ViewProductDetail({super.key, required this.product});
  final Product product;

  @override
  State<ViewProductDetail> createState() => _ViewProductDetailState();
}

class _ViewProductDetailState extends State<ViewProductDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.code),
        actions: [
          IconButton(
              onPressed: () => goToEdit(context), icon: const Icon(Icons.edit))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => deleteProduct(context),
        child: const Icon(
          Icons.delete,
          color: Colors.red,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StyleConst.getText('Nome'),
                  StyleConst.getText(widget.product.name),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StyleConst.getText('Descrição'),
                  StyleConst.getText(widget.product.description),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StyleConst.getText('Estoque mínimo'),
                  StyleConst.getText(
                      FormatterCustom.numberToString(widget.product.stockMin)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StyleConst.getText('Estoque máximo'),
                  StyleConst.getText(
                      FormatterCustom.numberToString(widget.product.stockMax)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StyleConst.getText('Estoque atual'),
                  StyleConst.getText(FormatterCustom.numberToString(
                      widget.product.stockCurrent)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StyleConst.getText('Preço compra'),
                  StyleConst.getText(FormatterCustom.currencyToString(
                      widget.product.pricePurchase)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StyleConst.getText('Preço venda'),
                  StyleConst.getText(FormatterCustom.currencyToString(
                      widget.product.priceSale)),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.network(widget.product.imageUrl ??
                    'https://primordio-assets.s3.us-east-2.amazonaws.com/logo.png'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  goToEdit(BuildContext context) {
    Navigator.popAndPushNamed(context, 'product_form',
        arguments: widget.product);
  }

  deleteProduct(BuildContext context) async {
    loadingDialog(context, message: "Excluindo produto...");
    try {
      ProductController pc = ProductController();
      await pc.delete(widget.product);
    } on Exception catch (e) {
      Toasty.toast(context, e.toString(), backgroundColor: Colors.red);
    }

    Navigator.pop(context);
  }
}
