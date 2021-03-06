import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/edit_user_products.dart';
import '../widgets/main_drawer.dart';
import '../providers/products.dart';
import '../widgets/user_products_item.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = "/user-products-screen";

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    // final productsData = Provider.of<Products>(context);
    print("Rebuilding");
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Products"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () =>
                Navigator.of(context).pushNamed(EditUserProducts.routeName),
          ),
        ],
      ),
      drawer: MainDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshProducts(context),
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Consumer<Products>(
                        builder: (ctx, productsData, _) => ListView.builder(
                          itemBuilder: (ctx, index) => Column(
                            children: <Widget>[
                              UserProductsItem(
                                id: productsData.items[index].id,
                                title: productsData.items[index].title,
                                imageUrl: productsData.items[index].imageUrl,
                              ),
                              Divider(),
                            ],
                          ),
                          itemCount: productsData.items.length,
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
