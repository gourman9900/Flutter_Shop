import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/user_product_screen.dart';
import '../screens/order_screen.dart';

import '../widgets/navigation_items.dart';

import '../providers/auth.dart';

class MainDrawer extends StatelessWidget {
  // Widget buildDrawerItems(Icon icon, String title, Function tapHandler) {
  //   return ListTile(
  //     leading: icon,
  //     title: Text(
  //       title,
  //       style: TextStyle(
  //         fontWeight: FontWeight.bold,
  //         fontSize: 20,
  //       ),
  //     ),
  //     onTap: tapHandler,
  //   );
  // }

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
          NavigationItem(
            title: "Shop",
            icon: Icon(Icons.shop),
            tapHandler: () => Navigator.of(context).pushReplacementNamed("/"),
          ),

          Divider(height: 7.0,),
          NavigationItem(
            title: "Orders",
            icon: Icon(Icons.credit_card),
            tapHandler: () => Navigator.of(context)
                .pushReplacementNamed(OrderScreen.routeName),
          ),
          // buildDrawerItems(
          //     Icon(Icons.credit_card),
          //     "Orders",
          //     () => Navigator.of(context)
          //         .pushReplacementNamed(OrderScreen.routeName)),
          Divider(height: 7.0,),
          // buildDrawerItems(Icon(Icons.edit), "Manage Products", () => Navigator.of(context).pushReplacementNamed(UserProductScreen.routeName),),
          NavigationItem(
            title: "Manage Products",
            icon: Icon(Icons.edit),
            tapHandler: () => Navigator.of(context)
                .pushReplacementNamed(UserProductScreen.routeName),
          ),
          Divider(height: 7.0,),
          NavigationItem(
            title: "Logout",
            icon: Icon(Icons.exit_to_app),
            tapHandler: () {
              Navigator.of(context).pop();
              Provider.of<Auth>(context,listen: false).logout();
            },
          ),
        ],
      ),
    );
  }
}
