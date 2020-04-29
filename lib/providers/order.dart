import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

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
  final String authToken;
  final String userId;

  Order(this.authToken,this.userId,this._orderProducts);

  List<OrderItem> get orderProducts {
    return [..._orderProducts];
  }

  Future<void> fetchAndSetOrders() async {
    final url = "https://flutter-shop-dcd01.firebaseio.com/orders/$userId.json?auth=$authToken";
    final response = await http.get(url);
    final List<OrderItem> loadedProducts = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach(
      (orderId, orderData) => {
        loadedProducts.add(
          OrderItem(
            id: orderId,
            dateTime: DateTime.parse(orderData["dateTime"]),
            totalAmount: orderData["amount"],
            products: (orderData["products"] as List<dynamic>)
                .map(
                  (item) => CartItem(
                    id: item["id"],
                    price: item["price"],
                    quantity: item["quantity"],
                    title: item["title"],
                  ),
                )
                .toList(),
          ),
        ),
      },
    );
    _orderProducts = loadedProducts.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> orderProducts, double total) async {
    final url = "https://flutter-shop-dcd01.firebaseio.com/orders/$userId.json?auth=$authToken";
    final timeStamp = DateTime.now();
    final response = await http.post(
      url,
      body: json.encode(
        {
          "amount": total,
          "dateTime": timeStamp.toIso8601String(),
          "products": orderProducts
              .map((op) => {
                    "id": op.id,
                    "title": op.title,
                    "quantity": op.quantity,
                    "price": op.price,
                  })
              .toList(),
        },
      ),
    );
    _orderProducts.insert(
      0,
      OrderItem(
        id: json.decode(response.body)["name"],
        totalAmount: total,
        products: orderProducts,
        dateTime: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
