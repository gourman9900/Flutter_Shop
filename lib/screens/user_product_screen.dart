import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/edit_user_products.dart';
import '../widgets/main_drawer.dart';
import '../providers/products.dart';
import '../widgets/user_products_item.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = "/user-products-screen";

  @override
  Widget build(BuildContext context) {
    final prodctsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Products"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => Navigator.of(context).pushNamed(EditUserProducts.routeName),
          ),
        ],
      ),
      drawer: MainDrawer(),
      body: ListView.builder(
        itemBuilder: (ctx, index) => Column(
          children: <Widget>[
            UserProductsItem(
              id: prodctsData.items[index].id,
              title: prodctsData.items[index].title,
              imageUrl: prodctsData.items[index].imageUrl,
            ),
            Divider(),
          ],
        ),
        itemCount: prodctsData.items.length,
      ),
    );
  }
}
