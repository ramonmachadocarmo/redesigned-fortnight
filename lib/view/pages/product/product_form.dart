// ignore_for_file: use_build_context_synchronously

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:monarch/controller/product_controller.dart';
import 'package:monarch/model/enum/category.dart';
import 'package:monarch/model/enum/unity_measure.dart';
import 'package:monarch/model/product.dart';
import 'package:monarch/utils/validate.dart';
import 'package:monarch/view/components/loading_dialog.dart';
import 'package:monarch/view/components/toasty.dart';
import 'package:monarch/view/style/style.dart';

class ViewProductForm extends StatefulWidget {
  const ViewProductForm({super.key, this.product});
  final Product? product;

  @override
  State<ViewProductForm> createState() => _ViewProductFormState();
}

class _ViewProductFormState extends State<ViewProductForm> {
  bool isEditing = false;
  final _formKey = GlobalKey<FormState>();
  List<Step> _steps = [];
  int _currentStep = 0;
  ProductController pc = ProductController();
  UnityMeasure selectedUnityMeasure = UnityMeasure.box;
  UnityMeasure selectedUnityMeasure2 = UnityMeasure.box;
  CategoryPrd? selectedCategory;
  int prodSize = 0;
  final TextEditingController _code = TextEditingController(text: 'AAA000000');
  final TextEditingController _name = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _minStock = TextEditingController();
  final TextEditingController _maxStock = TextEditingController();
  final TextEditingController _curStock = TextEditingController();
  final TextEditingController _purchasePrice = TextEditingController();
  final TextEditingController _salePrice = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _steps = getSteps();
    if (widget.product != null) {
      fillFormWhenUpdate();
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Produtos"),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Stepper(
              controlsBuilder: (context, details) => const SizedBox.shrink(),
              type: StepperType.horizontal,
              currentStep: _currentStep,
              onStepCancel: () =>
                  _currentStep == 0 ? null : setState(() => _currentStep -= 1),
              onStepContinue: () {
                bool isLastStep = (_currentStep == _steps.length - 1);
                if (isLastStep) {
                } else {
                  setState(() => _currentStep += 1);
                }
              },
              onStepTapped: (value) => setState(() => _currentStep = value),
              steps: _steps,
            ),
          ),
        ),
      ),
    );
  }

  List<Step> getSteps() {
    return <Step>[
      formRequiredFields(),
      formAdmFields(),
      Step(
        state: _currentStep > 2 ? StepState.complete : StepState.indexed,
        isActive: _currentStep >= 2,
        title: const Text('Finalizar'),
        content: ElevatedButton(
          onPressed: () => sendProd(context),
          child: const Text('Cadastrar'),
        ),
      ),
    ];
  }

  sendProd(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      Toasty.toast(context, "Existem campos obrigatórios não preenchidos",
          backgroundColor: Colors.red);
      return;
    }
    loadingDialog(context);

    Product prod = Product(_code.text, selectedCategory!.cod, _name.text,
        _description.text, selectedUnityMeasure.name);
    try {
      double? minStock = double.tryParse(_minStock.text);
      if (minStock != null) prod.setStockMin(minStock);
      double? maxStock = double.tryParse(_maxStock.text);
      if (maxStock != null) prod.setStockMax(maxStock);
      double? currentStock = double.tryParse(_curStock.text);
      if (currentStock != null) prod.setStock(currentStock);
      double? purchasePrice = double.tryParse(_purchasePrice.text);
      if (purchasePrice != null) prod.setPurchasePrice(purchasePrice);
      double? salePrice = double.tryParse(_salePrice.text);
      if (salePrice != null) prod.setSalePrice(salePrice);
    } on Exception {
      Toasty.toast(context, "Campos complementares inválidos",
          backgroundColor: Colors.red);
      return;
    }
    if (kDebugMode) {
      print(prod);
    }
    try {
      if (isEditing) {
        await pc.edit(prod);
      } else {
        await pc.save(prod);
      }
    } on Exception catch (e) {
      Toasty.toast(context, e.toString(), backgroundColor: Colors.red);
    }
    Navigator.pop(context);
  }

  getCode(CategoryPrd data) async {
    loadingDialog(context, message: "Carregando código...");
    _code.text = await pc.getNextCode(data.cod);
    selectedCategory = data;
    Navigator.pop(context);
  }

  fillFormWhenUpdate() {
    _code.text = widget.product!.code;
    _name.text = widget.product!.name;
    _description.text = widget.product!.description;
    _minStock.text = widget.product!.stockMin == null
        ? ''
        : widget.product!.stockMin.toString();
    _maxStock.text = widget.product!.stockMax == null
        ? ''
        : widget.product!.stockMax.toString();
    _curStock.text = widget.product!.stockCurrent == null
        ? ''
        : widget.product!.stockCurrent.toString();
    _purchasePrice.text = widget.product!.pricePurchase == null
        ? ''
        : widget.product!.pricePurchase.toString();
    _salePrice.text = widget.product!.priceSale == null
        ? ''
        : widget.product!.priceSale.toString();
    isEditing = true;
    selectedCategory = CategoryPrd.getByCode(widget.product!.category);
    selectedUnityMeasure = UnityMeasure.getByCode(widget.product!.measureUnit);
    selectedUnityMeasure2 =
        UnityMeasure.getByCode(widget.product!.measureUnit2 ?? '');
  }

  Step formRequiredFields() {
    return Step(
      state: _currentStep > 0 ? StepState.complete : StepState.indexed,
      isActive: _currentStep >= 0,
      title: const Text('Obrigatório'),
      content: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Visibility(
              visible: !isEditing,
              child: AutoCompleteTextField<CategoryPrd>(
                key: GlobalKey(),
                decoration: StyleConst.getInputDecoration(
                    'Qual categoria do produto?', 'Categoria'),
                clearOnSubmit: true,
                textInputAction: TextInputAction.next,
                suggestions: CategoryPrd.values,
                itemBuilder: (context, CategoryPrd category) => ListTile(
                  title: Text(category.getLabel()),
                ),
                itemSubmitted: (data) async {
                  await getCode(data);
                  setState(() {});
                },
                itemSorter: (a, b) => a.getLabel().compareTo(b.getLabel()),
                itemFilter: (suggestion, query) => suggestion
                    .getLabel()
                    .toLowerCase()
                    .contains(query.toLowerCase()),
              ),
            ),
          ),
          Text(
            selectedCategory?.getFullLabel() ?? "Selecione uma categoria",
            style: StyleConst.textAlertLabel,
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: TextField(
              enabled: false,
              controller: _code,
              decoration: StyleConst.getInputDecoration(
                  'Código gerado automaticamente', 'Código'),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: TextFormField(
              enabled: !isEditing,
              controller: _name,
              textInputAction: TextInputAction.next,
              decoration:
                  StyleConst.getInputDecoration('Nome do produto', 'Nome'),
              validator: (value) {
                return ValidateCustom.isTextNotEmpty(value);
              },
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: TextFormField(
              enabled: !isEditing,
              controller: _description,
              textInputAction: TextInputAction.next,
              decoration: StyleConst.getInputDecoration(
                  'Descreva o produto detalhadamente', 'Descrição'),
              validator: (value) {
                return ValidateCustom.isTextNotEmpty(value);
              },
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Seleciona a Unidade de Medida',
                  style: StyleConst.textFieldLabel,
                ),
                DropdownButton<UnityMeasure>(
                  style: StyleConst.textFieldLabel,
                  value: selectedUnityMeasure,
                  onChanged: (UnityMeasure? newUM) {
                    setState(() {
                      selectedUnityMeasure = newUM ?? selectedUnityMeasure;
                    });
                  },
                  items: UnityMeasure.values.map((UnityMeasure um) {
                    return DropdownMenuItem<UnityMeasure>(
                      value: um,
                      child: Text(
                        um.getLabel(),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Step formAdmFields() {
    return Step(
        state: _currentStep > 1 ? StepState.complete : StepState.indexed,
        isActive: _currentStep >= 1,
        title: const Text("Adm."),
        content: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Seleciona a Unidade de Medida',
                    style: StyleConst.textFieldLabel,
                  ),
                  DropdownButton<UnityMeasure>(
                    style: StyleConst.textFieldLabel,
                    value: selectedUnityMeasure2,
                    onChanged: (UnityMeasure? newUM) {
                      setState(() {
                        selectedUnityMeasure2 = newUM ?? selectedUnityMeasure2;
                      });
                    },
                    items: UnityMeasure.values.map((UnityMeasure um) {
                      return DropdownMenuItem<UnityMeasure>(
                        value: um,
                        child: Text(
                          um.getLabel(),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: TextFormField(
                controller: _minStock,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                decoration: StyleConst.getInputDecoration(
                    'Quantidade mínima em estoque', 'Estoque mínimo'),
                validator: (value) {
                  return ValidateCustom.isTextDoubleNonObrigat(value);
                },
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: TextFormField(
                controller: _maxStock,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                decoration: StyleConst.getInputDecoration(
                    'Quantidade máxima em estoque', 'Estoque máxima'),
                validator: (value) {
                  return ValidateCustom.isTextDoubleNonObrigat(value);
                },
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: TextFormField(
                controller: _curStock,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                decoration: StyleConst.getInputDecoration(
                    'Quantidade atual em estoque', 'Estoque atual'),
                validator: (value) {
                  return ValidateCustom.isTextDoubleNonObrigat(value);
                },
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: TextFormField(
                controller: _purchasePrice,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                decoration: StyleConst.getInputDecoration(
                    'Último preço de compra', 'Preço de compra'),
                validator: (value) {
                  return ValidateCustom.isTextDoubleNonObrigat(value);
                },
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: TextFormField(
                controller: _salePrice,
                textInputAction: TextInputAction.next,
                decoration: StyleConst.getInputDecoration(
                    'Preço de venda atual', 'Preço de venda'),
                validator: (value) {
                  return ValidateCustom.isTextDoubleNonObrigat(value);
                },
              ),
            ),
          ],
        ));
  }
}
