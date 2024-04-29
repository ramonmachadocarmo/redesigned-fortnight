// ignore_for_file: use_build_context_synchronously

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:monarch/controller/supplier_controller.dart';
import 'package:monarch/model/supplier.dart';
import 'package:monarch/utils/validate.dart';
import 'package:monarch/view/components/loading_dialog.dart';
import 'package:monarch/view/components/toasty.dart';
import 'package:monarch/view/style/colors.dart';
import 'package:monarch/view/style/style.dart';

class ViewSupplierForm extends StatefulWidget {
  const ViewSupplierForm({super.key, this.supplier});
  final Supplier? supplier;

  @override
  State<ViewSupplierForm> createState() => _ViewSupplierFormState();
}

class _ViewSupplierFormState extends State<ViewSupplierForm> {
  bool isEditing = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cnpj = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _fantasyName = TextEditingController();
  SupplierController sc = SupplierController();

  @override
  Widget build(BuildContext context) {
    if (widget.supplier != null) {
      setForm();
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fornecedores"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => sendSup(context),
        backgroundColor: ColorsConst.secondaryColor,
        child: const Icon(
          Icons.done,
          color: Colors.white,
        ),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    child: TextField(
                      controller: _cnpj,
                      decoration: StyleConst.getInputDecoration('CNPJ', 'CNPJ'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    child: TextFormField(
                      enabled: !isEditing,
                      controller: _name,
                      textInputAction: TextInputAction.next,
                      decoration:
                          StyleConst.getInputDecoration('Razão social', 'Nome'),
                      validator: (value) {
                        return ValidateCustom.isTextNotEmpty(value);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    child: TextFormField(
                      enabled: !isEditing,
                      controller: _fantasyName,
                      textInputAction: TextInputAction.next,
                      decoration: StyleConst.getInputDecoration(
                          'Nome fantasia', 'Nome'),
                      validator: (value) {
                        return ValidateCustom.isTextNotEmpty(value);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  sendSup(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      Toasty.toast(context, "Existem campos obrigatórios não preenchidos",
          backgroundColor: Colors.red);
      return;
    }
    loadingDialog(context);

    Supplier sup = Supplier(_cnpj.text, _name.text, _fantasyName.text);

    if (kDebugMode) {
      print(sup);
    }
    try {
      if (isEditing) {
        await sc.edit(sup);
      } else {
        await sc.save(sup);
      }
    } on Exception catch (e) {
      Toasty.toast(context, e.toString(), backgroundColor: Colors.red);
    }
    Navigator.pop(context);
  }

  void setForm() {
    _cnpj.text = widget.supplier!.cnpj;
    _name.text = widget.supplier!.name;
    _fantasyName.text = widget.supplier!.fantasyName;
  }
}
