import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';
import './product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  final String authToken;

  Products(this.authToken,this._items);

  List<Product> get items {
    return [..._items];
  }

  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  List<Product> get itemsFavorites {
    return _items.where((productItem) => productItem.isFavourite).toList();
  }

  Future<void> addProduct(Product product) async {
    final url = "https://flutter-shop-dcd01.firebaseio.com/products.json?auth=$authToken";
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            "title": product.title,
            "price": product.price,
            "isFavorite": false,
            "description": product.description,
            "imageUrl": product.imageUrl,
          },
        ),
      );
      var validProduct = Product(
        id: json.decode(response.body)["name"],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _items.add(validProduct);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product product) async {
    final productIndex = _items.indexWhere((item) => item.id == id);
    if (productIndex >= 0) {
      final url = "https://flutter-shop-dcd01.firebaseio.com/products/$id.json?auth=$authToken";
      await http.patch(
        url,
        body: json.encode(
          {
            "title": product.title,
            "description": product.description,
            "price": product.price,
            "imageUrl": product.imageUrl,
          },
        ),
      );
      _items[productIndex] = product;
      notifyListeners();
    } else {
      print("...");
    }
  }

  Future<void> deleteProducts(String id) async {
    final url = "https://flutter-shop-dcd01.firebaseio.com/products/$id.json?auth=$authToken";
    final existingProductIndex = _items.indexWhere((item) => item.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    await http.delete(url).then(
      (response) {
        if (response.statusCode >= 400) {
          _items.add(existingProduct);
          notifyListeners();
          throw HttpException("Something Went Wrong");
        }
      },
    );
  }

  Future<void> fetchProducts() async {
    // print(authToken);
    try {
      final url = "https://flutter-shop-dcd01.firebaseio.com/products.json?auth=$authToken";
      final response = await http.get(url);
      final responseBody = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      if (responseBody == null) {
        return;
      }
      responseBody.forEach(
        (prodId, productsData) {
          loadedProducts.add(
            Product(
              id: prodId,
              title: productsData["title"],
              description: productsData["description"],
              price: productsData["price"],
              isFavourite: productsData["isFavorite"],
              imageUrl: productsData["imageUrl"],
            ),
          );
        },
      );
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
