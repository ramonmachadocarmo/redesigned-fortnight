import 'package:flutter/material.dart';
import 'package:monarch/model/product.dart';
import 'package:monarch/model/purchase_order.dart';
import 'package:monarch/model/supplier.dart';
import 'package:monarch/view/home.dart';
import 'package:monarch/view/pages/product/product_detail.dart';
import 'package:monarch/view/pages/product/product_form.dart';
import 'package:monarch/view/pages/product/product_list.dart';
import 'package:monarch/view/pages/purchase/purchase_order_detail.dart';
import 'package:monarch/view/pages/purchase/purchase_order_form.dart';
import 'package:monarch/view/pages/purchase/purchase_order_list.dart';
import 'package:monarch/view/pages/stock/stock_home.dart';
import 'package:monarch/view/pages/supplier/supplier_detail.dart';
import 'package:monarch/view/pages/supplier/supplier_form.dart';
import 'package:monarch/view/pages/supplier/supplier_list.dart';

class RouterGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    String nextRoute = settings.name!;

    switch (nextRoute) {
      case 'home':
        return MaterialPageRoute(builder: (_) => const ViewHome());
      case 'product_list':
        return MaterialPageRoute(builder: (_) => const ViewProductList());
      case 'product_form':
        if (args is Product) {
          return MaterialPageRoute(
              builder: (_) => ViewProductForm(
                    product: args,
                  ));
        }
        return MaterialPageRoute(builder: (_) => const ViewProductForm());
      case 'product_detail':
        if (args is Product) {
          return MaterialPageRoute(
              builder: (_) => ViewProductDetail(product: args));
        }
        return MaterialPageRoute(builder: (_) => const ViewHome());
      case 'supplier_list':
        return MaterialPageRoute(builder: (_) => const ViewSupplierList());
      case 'supplier_form':
        if (args is Supplier) {
          return MaterialPageRoute(
              builder: (_) => ViewSupplierForm(
                    supplier: args,
                  ));
        }
        return MaterialPageRoute(builder: (_) => const ViewSupplierForm());
      case 'supplier_detail':
        if (args is Supplier) {
          return MaterialPageRoute(
              builder: (_) => ViewSupplierDetail(supplier: args));
        }
        return MaterialPageRoute(builder: (_) => const ViewHome());
      case 'purchaseOrder_list':
        return MaterialPageRoute(builder: (_) => const ViewPurchaseOrderList());
      case 'purchaseOrder_form':
        if (args is PurchaseOrder) {
          return MaterialPageRoute(
              builder: (_) => ViewPurchaseOrderForm(
                    purchaseOrder: args,
                  ));
        }
        return MaterialPageRoute(builder: (_) => const ViewPurchaseOrderForm());
      case 'purchaseOrder_detail':
        if (args is PurchaseOrder) {
          return MaterialPageRoute(
              builder: (_) => ViewPurchaseOrderDetail(purchaseOrder: args));
        }
        return MaterialPageRoute(builder: (_) => const ViewHome());
      case 'stock_list':
        return MaterialPageRoute(builder: (_) => const ViewStockHome());
      default:
        return MaterialPageRoute(builder: (_) => const ViewHome());
    }
  }
}
