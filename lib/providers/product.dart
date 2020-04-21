import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  @required
  final String id;
  @required
  final String title;
  @required
  final String description;
  @required
  final double price;
  @required
  final String imageUrl;
  bool isFavourite;

  Product(
      {this.id,
      this.title,
      this.description,
      this.imageUrl,
      this.isFavourite = false,
      this.price});

  
  void _setFavValue (bool oldvalue) {
    isFavourite = oldvalue;
    notifyListeners();
  }

  Future<void> toggleFavorites() async {
    final oldState = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();
    final url = "https://flutter-shop-dcd01.firebaseio.com/products/$id.json";
    try {
      final response = await http.patch(
        url,
        body: json.encode(
          {"isFavorite": isFavourite},
        ),
      );
      if (response.statusCode >= 400) {
        _setFavValue(oldState);
      }
    } catch (error) {
     _setFavValue(oldState);
    }
  }
}
