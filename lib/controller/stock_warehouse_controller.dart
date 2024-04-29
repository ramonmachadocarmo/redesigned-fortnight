import 'package:monarch/controller/stock_controller.dart';
import 'package:monarch/model/stock.dart';
import 'package:monarch/model/stock_warehouse.dart';

class StockWarehouseController {
  Future<List<StockWarehouse>> get() async {
    List<StockWarehouse> list = [];
    List<Stock> stocks = await StockController().get();
    Set<String> warehouseList = getWarehouses(stocks);

    for (var element in warehouseList) {
      List<Stock> stocksByWarehouse = getStocksByWarehouse(element, stocks);
      StockWarehouse item = StockWarehouse(element, stocksByWarehouse);
      list.add(item);
    }

    return list;
  }

  Set<String> getWarehouses(List<Stock> stocks) {
    return stocks.map((e) => e.warehouse).toSet();
  }

  List<Stock> getStocksByWarehouse(String warehouse, List<Stock> stocks) {
    return stocks.where((element) => element.warehouse == warehouse).toList();
  }
}
