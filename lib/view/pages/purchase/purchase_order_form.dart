// ignore_for_file: use_build_context_synchronously

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:monarch/controller/product_controller.dart';
import 'package:monarch/controller/purchase_order_controller.dart';
import 'package:monarch/controller/supplier_controller.dart';
import 'package:monarch/model/product.dart';
import 'package:monarch/model/purchase_order.dart';
import 'package:monarch/model/purchase_order_item.dart';
import 'package:monarch/model/supplier.dart';
import 'package:monarch/utils/formatter.dart';
import 'package:monarch/view/components/loading_dialog.dart';
import 'package:monarch/view/components/progress.dart';
import 'package:monarch/view/components/toasty.dart';
import 'package:monarch/view/style/style.dart';

class ViewPurchaseOrderForm extends StatefulWidget {
  const ViewPurchaseOrderForm({super.key, this.purchaseOrder});
  final PurchaseOrder? purchaseOrder;

  @override
  State<ViewPurchaseOrderForm> createState() => _ViewPurchaseOrderFormState();
}

class _ViewPurchaseOrderFormState extends State<ViewPurchaseOrderForm> {
  PurchaseOrderController poController = PurchaseOrderController();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _number = TextEditingController();
  final TextEditingController _purchaseDate = TextEditingController();
  double totalValue = 0;
  double totalDiscount = 0;
  final TextEditingController _quantity = TextEditingController();
  final TextEditingController _price = TextEditingController();
  final TextEditingController _itemDiscount = TextEditingController();
  final String _status = 'pendent'; //! ENUM
  // final String _paymentCondition = "A VISTA"; //! ENUM
  List<Supplier> suppliers = [];
  Supplier? supplierSelected;
  List<Product> products = [];
  Product? productSelected;
  List<Step> _steps = [];
  List<PurchaseOrderItem> items = [];
  int _currentStep = 0;
  String code = '';

  getSuppliers() async {
    suppliers = await SupplierController().get();
  }

  getProducts() async {
    products = await ProductController().get();
  }

  getNextNumber() async {
    code = await poController.getNextCode();
    _number.text = code;
  }

  Future<bool> _loadData() async {
    if (suppliers.isEmpty || products.isEmpty) {
      List<Future> futures = [
        getSuppliers(),
        getProducts(),
        getNextNumber(),
      ];

      await Future.wait(futures);
    }
    _steps = getSteps();
    return true;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _loadData().then((value) => setState(() {}));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo pedido de compra'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder(
          future: _loadData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  Flexible(
                    flex: 5,
                    child: Form(
                      key: _formKey,
                      child: Stepper(
                        controlsBuilder: (context, details) =>
                            const SizedBox.shrink(),
                        type: StepperType.horizontal,
                        currentStep: _currentStep,
                        onStepCancel: () => _currentStep == 0
                            ? null
                            : setState(() => _currentStep -= 1),
                        onStepContinue: () {
                          bool isLastStep = (_currentStep == _steps.length - 1);
                          if (isLastStep) {
                          } else {
                            setState(() => _currentStep += 1);
                          }
                        },
                        onStepTapped: (value) =>
                            setState(() => _currentStep = value),
                        steps: _steps,
                      ),
                    ),
                  ),
                  const Divider(),
                  Flexible(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        StyleConst.getTextSecondary(
                            'Valor total: ${FormatterCustom.currencyToString(totalValue)}'),
                        StyleConst.getTextSecondary(
                            'Desconto total: ${FormatterCustom.currencyToString(totalDiscount)}'),
                        StyleConst.getTextSecondary(
                            'Qntd. itens: ${items.length}'),
                      ],
                    ),
                  ),
                ],
              );
            }
            return const Progress();
          },
        ),
      ),
    );
  }

  List<Step> getSteps() {
    return <Step>[
      Step(
        state: _currentStep > 0 ? StepState.complete : StepState.indexed,
        isActive: _currentStep >= 0,
        title: const Text('Cabeçalho'),
        content: Column(
          children: [
            TextFormField(
              enabled: false,
              controller: _number,
              decoration:
                  StyleConst.getInputDecoration('Número pedido', 'Número'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: supplierSelected == null
                  ? AutoCompleteTextField<Supplier>(
                      key: GlobalKey(),
                      decoration: StyleConst.getInputDecoration(
                          'Qual fornecedor do pedido?', 'Fornecedor'),
                      clearOnSubmit: true,
                      textInputAction: TextInputAction.next,
                      suggestions: suppliers,
                      itemBuilder: (context, Supplier supplier) => ListTile(
                        title: Text(supplier.fantasyName),
                      ),
                      itemSubmitted: (data) async {
                        setState(() {
                          supplierSelected = data;
                        });
                      },
                      itemSorter: (a, b) =>
                          a.fantasyName.compareTo(b.fantasyName),
                      itemFilter: (suggestion, query) => suggestion.fantasyName
                          .toLowerCase()
                          .contains(query.toLowerCase()),
                    )
                  : Center(
                      child: StyleConst.getTextImportant(
                          supplierSelected!.fantasyName),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextFormField(
                keyboardType: TextInputType.datetime,
                controller: _purchaseDate,
                decoration: StyleConst.getInputDecoration(
                    'Data da previsão de compra', 'Data compra'),
                inputFormatters: [
                  FormatterCustom.dateFormatter(),
                ],
              ),
            ),
          ],
        ),
      ),
      Step(
        state: _currentStep > 1 ? StepState.complete : StepState.indexed,
        isActive: _currentStep >= 1,
        title: const Text('Itens'),
        content: Column(
          children: [
            productSelected == null
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: AutoCompleteTextField<Product>(
                      key: GlobalKey(),
                      decoration: StyleConst.getInputDecoration(
                          'Digite um produto', 'Produtos'),
                      clearOnSubmit: true,
                      textInputAction: TextInputAction.next,
                      suggestions: products,
                      itemBuilder: (context, Product product) => ListTile(
                        title: Text(product.name),
                      ),
                      itemSubmitted: (data) async {
                        setState(() {
                          productSelected = data;
                          _price.text = FormatterCustom.numberToString(
                              data.priceSale.toString());
                        });
                      },
                      itemSorter: (a, b) => a.name.compareTo(b.name),
                      itemFilter: (suggestion, query) => suggestion.name
                          .toLowerCase()
                          .contains(query.toLowerCase()),
                    ),
                  )
                : Center(
                    child: StyleConst.getText(productSelected?.name ?? '')),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextFormField(
                controller: _price,
                decoration: StyleConst.getInputDecoration('', 'Preço'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: TextFormField(
                        controller: _quantity,
                        decoration:
                            StyleConst.getInputDecoration('', 'Quantidade'),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: TextFormField(
                        controller: _itemDiscount,
                        decoration:
                            StyleConst.getInputDecoration('', 'Desconto'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                children: [
                  ElevatedButton(
                      onPressed: () => addPOItem(),
                      child: const Text('Adicionar item')),
                  ElevatedButton(
                      onPressed: () => clearPOItemForm(),
                      child: const Text('Limpar formulário')),
                ],
              ),
            ),
          ],
        ),
      ),
      Step(
        state: _currentStep > 2 ? StepState.complete : StepState.indexed,
        isActive: _currentStep >= 2,
        title: const Text('Enviar pedido'),
        content: Column(
          children: [
            ElevatedButton(
              onPressed: () => sendPO(context),
              child: const Text('Gravar'),
            ),
            const Divider(),
            items.isEmpty
                ? Center(
                    child: StyleConst.getTextImportant(
                      "Sem itens no pedido",
                    ),
                  )
                : SizedBox(
                    height: (MediaQuery.of(context).size.height / 2),
                    child: ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        PurchaseOrderItem item = items[index];
                        return Card(
                          child: ListTile(
                            title: Text(item.product.name),
                            trailing: IconButton(
                                onPressed: () => removeItem(item),
                                icon: const Icon(Icons.delete_forever)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    'Preço: ${FormatterCustom.currencyToString(item.price)}'),
                                Text(
                                    'Desconto: ${FormatterCustom.currencyToString(item.discount)}'),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )
          ],
        ),
      ),
    ];
  }

  sendPO(BuildContext context) async {
    if (!_formKey.currentState!.validate() ||
        supplierSelected == null ||
        items.isEmpty ||
        totalValue <= 0) {
      Toasty.toast(context, "Existem campos obrigatórios não preenchidos",
          backgroundColor: Colors.red);
      return;
    }
    loadingDialog(context);
    try {
      DateTime? date =
          DateTime.tryParse(FormatterCustom.brDateToUs(_purchaseDate.text));
      PurchaseOrder po = PurchaseOrder(
        _number.text,
        supplierSelected!,
        date ?? DateTime.now(),
        totalValue,
        totalDiscount,
        _status,
        items,
      );
      await poController.save(po);
    } on Exception catch (e) {
      Toasty.toast(context, e.toString(), backgroundColor: Colors.red);
    }
    Navigator.pop(context);
  }

  addPOItem() {
    if (_quantity.text.isEmpty || _price.text.isEmpty) {
      Toasty.toast(context, 'Preço e quantidade são obrigatórios',
          backgroundColor: Colors.red);
      return;
    }
    PurchaseOrderItem poItem = PurchaseOrderItem(
        productSelected!,
        double.tryParse(_quantity.text) ?? 0,
        double.tryParse(_price.text) ?? 0,
        double.tryParse(_itemDiscount.text) ?? 0);

    setState(() {
      sumPOTotals(poItem);
      items.add(poItem);
      clearPOItemForm();
    });
  }

  clearPOItemForm() {
    setState(() {
      productSelected = null;
      _price.text = '';
      _quantity.text = '';
      _itemDiscount.text = '';
    });
  }

  sumPOTotals(PurchaseOrderItem item) {
    totalValue += (item.price * item.quantity);
    totalDiscount += (item.discount * item.quantity);
  }

  subtractPOTotals(PurchaseOrderItem item) {
    totalValue -= (item.price * item.quantity);
    totalDiscount -= (item.discount * item.quantity);
  }

  removeItem(PurchaseOrderItem item) {
    setState(() {
      subtractPOTotals(item);
      items.remove(item);
    });
  }
}
