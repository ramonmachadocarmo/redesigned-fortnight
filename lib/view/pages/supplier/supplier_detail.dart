// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:monarch/controller/supplier_controller.dart';
import 'package:monarch/model/supplier.dart';
import 'package:monarch/view/components/toasty.dart';
import 'package:monarch/view/style/style.dart';

import '../../components/loading_dialog.dart';

class ViewSupplierDetail extends StatefulWidget {
  const ViewSupplierDetail({super.key, required this.supplier});
  final Supplier supplier;

  @override
  State<ViewSupplierDetail> createState() => _ViewSupplierDetailState();
}

class _ViewSupplierDetailState extends State<ViewSupplierDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.supplier.cnpj),
        actions: [
          IconButton(
              onPressed: () => goToEdit(context), icon: const Icon(Icons.edit))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => deleteSupplier(context),
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
                  StyleConst.getText('Razão social'),
                  StyleConst.getText(widget.supplier.name),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StyleConst.getText('Nome fantasia'),
                  StyleConst.getText(widget.supplier.fantasyName),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  goToEdit(BuildContext context) {
    Navigator.popAndPushNamed(context, 'supplier_form',
        arguments: widget.supplier);
  }

  deleteSupplier(BuildContext context) async {
    loadingDialog(context, message: "Excluindo fornecedor...");
    try {
      SupplierController pc = SupplierController();
      await pc.delete(widget.supplier);
    } on Exception catch (e) {
      Toasty.toast(context, e.toString(), backgroundColor: Colors.red);
    }

    Navigator.pop(context);
  }
}
