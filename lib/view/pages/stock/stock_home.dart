import 'package:flutter/material.dart';
import 'package:monarch/view/pages/stock/stock_by_product.dart';
import 'package:monarch/view/pages/stock/stock_by_warehouse.dart';
import 'package:monarch/view/pages/stock/stock_form.dart';

class ViewStockHome extends StatefulWidget {
  const ViewStockHome({super.key});

  @override
  State<ViewStockHome> createState() => _ViewStockHomeState();
}

class _ViewStockHomeState extends State<ViewStockHome> {
  final List<Widget> _views = [
    const ScreenStockForm(),
    const ScreenStockByWarehouse(),
    const ScreenStockByProduct()
  ];
  int _currentIndex = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estoque'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _views[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (value) => setState(() => _currentIndex = value),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Endereçar'),
          BottomNavigationBarItem(
              icon: Icon(Icons.warehouse), label: 'Saldo por armazém'),
          BottomNavigationBarItem(
              icon: Icon(Icons.category), label: 'Saldo por produto'),
        ],
      ),
    );
  }
}
