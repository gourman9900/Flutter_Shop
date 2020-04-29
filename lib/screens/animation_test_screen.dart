import 'package:flutter/material.dart';

class AnimationScreen extends StatefulWidget {
  AnimationScreen({Key key}) : super(key: key);

  @override
  _AnimationScreenState createState() => _AnimationScreenState();
}

// void toggleAnimation() {
//   animation = !animation;
// }

class _AnimationScreenState extends State<AnimationScreen>
    with SingleTickerProviderStateMixin {
  var animation = false;
  AnimationController _controller;
  Animation<Offset> _slideanimation;
  Animation<double> _fadeanimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _slideanimation = Tween<Offset>(begin: Offset(0, -1.5), end: Offset(0, 0))
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _fadeanimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void transitions() {
    if (animation == false) {
      setState(() {
        animation = true;
      });
      _controller.forward();
    }
    else {
      setState(() {
        animation = false;
      });
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    print(animation);
    return Scaffold(
      appBar: AppBar(
        title: Text("Animation"),
      ),
      body: Center(
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeIn,
          height: animation ? 340 : 270,
          width: 250,
          margin: EdgeInsets.all(50),
          color: Colors.white,
          child: Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text("Animation are great"),
                TextField(
                  decoration: InputDecoration(
                    labelText: "Enter Text",
                  ),
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: "Enter Text",
                  ),
                ),
                FadeTransition(
                    opacity: _fadeanimation,
                    child: SlideTransition(
                        position: _slideanimation,
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: "Enter Text",
                          ),
                        ))),
                OutlineButton(
                    child: Text("Submit"),
                    onPressed: () {
                      transitions();
                    })
              ],
            ),
            elevation: 8,
          ),
        ),
      ),
    );
  }
}
