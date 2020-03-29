import 'package:flutter/foundation.dart';

import './cart.dart';

class OrderItem {
  final String id;
  final double totalAmount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({this.id, this.totalAmount, this.products, this.dateTime});
}

class Order with ChangeNotifier {
  List<OrderItem> _orderProducts = [];

  List<OrderItem> get orderProducts {
    return [..._orderProducts];
  }

  void addOrder(List<CartItem> orderProducts, double total) {
    _orderProducts.insert(
      0,
      OrderItem(
        id: DateTime.now().toString(),
        totalAmount: total,
        products: orderProducts,
        dateTime: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
