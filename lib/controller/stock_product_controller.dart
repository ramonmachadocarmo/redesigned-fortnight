import 'package:monarch/controller/stock_controller.dart';
import 'package:monarch/model/stock.dart';
import 'package:monarch/model/stock_product.dart';

class StockProductController {
  Future<List<StockProduct>> get() async {
    List<StockProduct> list = [];
    List<Stock> stocks = await StockController().get();
    Set<String> warehouseList = getProducts(stocks);

    for (var element in warehouseList) {
      List<Stock> stocksByWarehouse = getProductsByWarehouse(element, stocks);
      StockProduct item = StockProduct(element, stocksByWarehouse);
      list.add(item);
    }

    return list;
  }

  Set<String> getProducts(List<Stock> stocks) {
    return stocks.map((e) => e.product.code).toSet();
  }

  List<Stock> getProductsByWarehouse(String product, List<Stock> stocks) {
    return stocks.where((element) => element.product.code == product).toList();
  }
}
