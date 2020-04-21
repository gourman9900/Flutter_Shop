import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/main_drawer.dart';
import '../providers/order.dart' show Order;
import '../widgets/order_item.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = "/order-screen";

  @override
  Widget build(BuildContext context) {
    // final orderData = Provider.of<Order>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Orders"),
      ),
      drawer: MainDrawer(),
      body: FutureBuilder(
        future: Provider.of<Order>(context, listen: false).fetchAndSetOrders(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (dataSnapshot.error != null) {
              return Center(
                child: Text("An Error Occured"),
              );
            } else {
              return Consumer<Order>(
                builder: (ctx, orderData, child) {
                  return ListView.builder(
                    itemCount: orderData.orderProducts.length,
                    itemBuilder: (ctx, index) =>
                        OrderItem(orderData.orderProducts[index]),
                  );
                },
              );
            }
          }
        },
      ),
    );
  }
}
