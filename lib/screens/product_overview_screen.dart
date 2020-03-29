import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/main_drawer.dart';

import '../screens/cart_screen.dart';

import '../widgets/badge.dart';
import '../providers/cart.dart';

import '../widgets/prdoucts_grid.dart';

enum Favorites {
  Favourites,
  All,
}

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showFavorites = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Products"),
        actions: <Widget>[
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            onSelected: (Favorites showScreenItems) {
              setState(
                () {
                  if (showScreenItems == Favorites.Favourites) {
                    _showFavorites = true;
                  } else {
                    _showFavorites = false;
                  }
                },
              );
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text("Show Favorites"),
                value: Favorites.Favourites,
              ),
              PopupMenuItem(
                child: Text("Show All"),
                value: Favorites.All,
              )
            ],
          ),
          Consumer<Cart>(
            builder: (_, cartData, ch) => Badge(
              child: ch,
              value: cartData.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(
                Icons.shopping_cart,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      drawer: MainDrawer(),
      body: ProductsGrid(_showFavorites),
    );
  }
}
