import 'package:flutter/material.dart';
import 'package:monarch/controller/stock_warehouse_controller.dart';
import 'package:monarch/model/stock.dart';
import 'package:monarch/model/stock_warehouse.dart';
import 'package:monarch/utils/formatter.dart';
import 'package:monarch/view/components/progress.dart';
import 'package:monarch/view/style/style.dart';

class ScreenStockByWarehouse extends StatefulWidget {
  const ScreenStockByWarehouse({super.key});

  @override
  State<ScreenStockByWarehouse> createState() => _ScreenStockByWarehouseState();
}

class _ScreenStockByWarehouseState extends State<ScreenStockByWarehouse> {
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
            child: FutureBuilder<List<StockWarehouse>>(
              future: StockWarehouseController().get(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<StockWarehouse> stocks = snapshot.data ?? [];
                  if (stocks.isEmpty) {
                    return const Center(
                      child: Text("Sem saldos"),
                    );
                  }
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: stocks.length,
                    itemBuilder: (context, index) {
                      StockWarehouse stock = stocks[index];
                      return SizedBox(
                        width: MediaQuery.of(context).size.width * .7,
                        child: Card(
                          child: ListTile(
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  StyleConst.getTextLabel('Armazém'),
                                  StyleConst.getText(stock.warehouse),
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
                                  SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height * .5,
                                    child: ListView.builder(
                                      itemCount: stock.items.length,
                                      itemBuilder: (context, index) {
                                        Stock productStock = stock.items[index];
                                        return Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                StyleConst.getText(
                                                    productStock.product.name),
                                                StyleConst.getTextSecondary(
                                                    FormatterCustom
                                                        .numberToString(
                                                            productStock
                                                                .quantity)),
                                                StyleConst.getTextSecondary(
                                                    FormatterCustom
                                                        .numberToString(
                                                            productStock
                                                                .blocked)),
                                                StyleConst.getTextSecondary(
                                                    FormatterCustom
                                                        .numberToString(
                                                            productStock
                                                                .reserved)),
                                              ],
                                            ),
                                            const Divider(),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              )),
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
