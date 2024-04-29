import 'package:flutter/material.dart';
import 'package:monarch/view/style/style.dart';

class ScreenStockForm extends StatefulWidget {
  const ScreenStockForm({super.key});

  @override
  State<ScreenStockForm> createState() => _ScreenStockFormState();
}

class _ScreenStockFormState extends State<ScreenStockForm> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
          child: Column(
        children: [
          TextFormField(
            decoration: StyleConst.getInputDecoration('Armazém', 'Armazém'),
          )
        ],
      )),
    );
  }
}
