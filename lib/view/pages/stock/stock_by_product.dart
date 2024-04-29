import 'package:flutter/material.dart';
import 'package:monarch/controller/stock_product_controller.dart';
import 'package:monarch/model/stock_product.dart';
import 'package:monarch/view/components/progress.dart';
import 'package:monarch/view/style/style.dart';

class ScreenStockByProduct extends StatefulWidget {
  const ScreenStockByProduct({super.key});

  @override
  State<ScreenStockByProduct> createState() => _ScreenStockByProductState();
}

class _ScreenStockByProductState extends State<ScreenStockByProduct> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          TextFormField(
            decoration: StyleConst.getInputDecoration(
                'Pesquisa um armazém ou produto', 'Pesquisar'),
          ),
          Expanded(
            flex: 9,
            child: FutureBuilder<List<StockProduct>>(
              future: StockProductController().get(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<StockProduct> stocks = snapshot.data ?? [];
                  if (stocks.isEmpty) {
                    return const Center(
                      child: Text("Sem saldos"),
                    );
                  }
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: stocks.length,
                    itemBuilder: (context, index) {
                      StockProduct stock = stocks[index];
                      return SizedBox(
                        width: MediaQuery.of(context).size.width * .7,
                        child: Card(
                          child: ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                StyleConst.getTextLabel('Produto'),
                                StyleConst.getText(stock.product),
                              ],
                            ),
                            subtitle: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    StyleConst.getTextLabel('Código'),
                                    StyleConst.getTextLabel('Quant.'),
                                    StyleConst.getTextLabel('Bloq.'),
                                    StyleConst.getTextLabel('Reserv.'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
                return const Progress();
              },
            ),
          ),
        ],
      ),
    );
  }
}
