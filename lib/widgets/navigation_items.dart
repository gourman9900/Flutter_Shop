import 'package:flutter/material.dart';

class NavigationItem extends StatelessWidget {
  const NavigationItem({
    Key key,
    this.title,
    this.icon,
    this.tapHandler,
  }) : super(key: key);
  final String title;
  final Icon icon;
  final Function tapHandler;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(1),
      hoverColor: Colors.amber,
      splashColor: Colors.cyan,
      onTap: tapHandler,
          child: Container(
        width: double.infinity,
        height: 30,
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: icon,
            ),
            Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  // fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
