import 'package:flutter/material.dart';

import '../screens/user_product_screen.dart';
import '../screens/order_screen.dart';

class MainDrawer extends StatelessWidget {
  Widget buildDrawerItems(Icon icon, String title, Function tapHandler) {
    return ListTile(
      leading: icon,
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      onTap: tapHandler,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Center(
              child: Text(
                "Shop",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryTextTheme.title.color,
                ),
              ),
            ),
            automaticallyImplyLeading: false,
          ),
          buildDrawerItems(Icon(Icons.shop), "Shop",
              () => Navigator.of(context).pushReplacementNamed("/")),
          Divider(),
          buildDrawerItems(
              Icon(Icons.credit_card),
              "Orders",
              () => Navigator.of(context)
                  .pushReplacementNamed(OrderScreen.routeName)),
          Divider(),
          buildDrawerItems(Icon(Icons.edit), "Manage Products", () => Navigator.of(context).pushReplacementNamed(UserProductScreen.routeName),),
        ],
      ),
    );
  }
}
