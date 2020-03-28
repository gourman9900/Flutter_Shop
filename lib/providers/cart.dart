import 'package:flutter/foundation.dart';

class CartItem {
  @required
  final String id;
  @required
  final String title;
  @required
  final int quantity;
  @required
  final double price;

  CartItem({this.id, this.title, this.price, this.quantity});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key,cart) {
      total = total + (cart.price * cart.quantity);
    });
    return total;
  }

  void addProductCart(String addId, String addTitle, double addPrice) {
    if (_items.containsKey((addId))) {
      _items.update(
        addId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
          addId,
          () => CartItem(
              id: addId, title: addTitle, price: addPrice, quantity: 1));
    }
    notifyListeners();
  }

  void removeItem(String productId){
    _items.remove(productId);
    notifyListeners();
  }
}
