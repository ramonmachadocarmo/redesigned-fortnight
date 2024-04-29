import 'package:flutter/material.dart';

class ViewHome extends StatefulWidget {
  const ViewHome({super.key});

  @override
  State<ViewHome> createState() => _ViewHomeState();
}

class _ViewHomeState extends State<ViewHome> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Monarch"),
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.purple,
                ),
                child: Text("Menu"),
              ),
              ListTile(
                title: const Text('Home'),
                selected: _selectedIndex == 0,
                onTap: () {
                  _onItemTapped(0);
                  Navigator.pushNamed(context, 'home');
                },
              ),
              ListTile(
                title: const Text('Produtos'),
                selected: _selectedIndex == 1,
                onTap: () {
                  _onItemTapped(1);
                  Navigator.pushNamed(context, 'product_list');
                },
              ),
              ListTile(
                title: const Text('Estoque'),
                selected: _selectedIndex == 2,
                onTap: () {
                  _onItemTapped(2);
                  Navigator.pushNamed(context, 'stock_list');
                },
              ),
              ListTile(
                title: const Text('Fornecedores'),
                selected: _selectedIndex == 3,
                onTap: () {
                  _onItemTapped(3);
                  Navigator.pushNamed(context, 'supplier_list');
                },
              ),
              ListTile(
                title: const Text('Pedidos de compra'),
                selected: _selectedIndex == 4,
                onTap: () {
                  _onItemTapped(4);
                  Navigator.pushNamed(context, 'purchaseOrder_list');
                },
              ),
            ],
          ),
        ),
        body: const Center(
          child: Text('Dashboards'),
        ));
  }
}
