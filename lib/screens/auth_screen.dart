import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/http_exception.dart';

import '../providers/auth.dart';

enum AuthType { SignUp, Login }

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key key}) : super(key: key);
  static const routeName = "/auth";
  static const gradient_start = Color(0xFF00c6fb);
  static const gradient_end = Color(0xFF005bea);

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: <Widget>[
          Container(
            height: deviceSize.height,
            width: deviceSize.width,
            // margin: EdgeInsets.all(10.0),
            padding: EdgeInsets.all(5.0),
            child: Center(),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  gradient_end,
                  gradient_start,
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: deviceSize.height * 0.2,
              left: deviceSize.width * 0.4,
            ),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 40.0,
              child: Icon(
                Icons.shopping_cart,
                color: gradient_end,
                size: 50,
              ),
            ),
          ),
          Transform.rotate(
            angle: 3 * pi / 2,
            origin: Offset(25, 80),
            alignment: Alignment.center,
            child: Container(
              // margin: EdgeInsets.only(right: deviceSize.height * 0.08,bottom: deviceSize.width * 0.2,top: deviceSize.width * 0.12),
              // padding: EdgeInsets.only(top: deviceSize.height * 0.2,right: deviceSize.width * 0.4,),
              // height: deviceSize.height * 0.4,
              // width: deviceSize.width * 0.9,
              child: Text(
                "Shop",
                style: TextStyle(
                  fontFamily: "Righteous",
                  fontSize: 70,
                  // fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              // transform: Matrix4.rotationZ(50 * pi / 180)..translate(10.0),
            ),
          ),
          Center(
            child: Container(
              margin: EdgeInsets.only(
                top: deviceSize.height * 0.3,
              ),
              height: deviceSize.height * 0.5,
              width: deviceSize.width * 0.8,
              child:
                  FormWidget(gradient_end: gradient_end, buildContext: context),
            ),
          )
        ],
      ),
    );
  }
}

class FormWidget extends StatefulWidget {
  const FormWidget({
    Key key,
    @required this.gradient_end,
    @required this.buildContext,
  }) : super(key: key);

  final Color gradient_end;
  final BuildContext buildContext;

  @override
  _FormWidgetState createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final _passwordController = TextEditingController();
  var _authMode = AuthType.Login;
  Map<String, String> _authData = {
    "email": "",
    "password": "",
  };

  var _isLoading = false;

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Something Went Wrong"),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text("Ok"),
            onPressed: () => Navigator.of(ctx).pop(),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_authMode == AuthType.Login) {
      try {
        await Provider.of<Auth>(context, listen: false)
            .signin(_authData["email"], _authData["password"]);
        
      } on HttpException catch (error) {
        var message = "Authentication Failed.Status Code : ${error}";
        showErrorDialog(message);
      } catch (error) {
        var message = "Something Went Wrong.Please try again later";
        showErrorDialog(message);
      }
    } else {
      try {
        await Provider.of<Auth>(context, listen: false)
            .signup(_authData["email"], _authData["password"]);
      } on HttpException catch (error) {
        var message = "Authentication Failed.Status Code : ${error}";
        showErrorDialog(message);
      } catch (error) {
        var message = "Something Went Wrong.Please try again later";
        showErrorDialog(message);
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  void toggleAuthMode() {
    if (_authMode == AuthType.Login) {
      _authMode = AuthType.SignUp;
    } else {
      _authMode = AuthType.Login;
    }
  }

  @override
  Widget build(BuildContext context) {
    // print(_authMode);
    return _isLoading
        ? CircularProgressIndicator(
            backgroundColor: Colors.white,
          )
        : SingleChildScrollView(
            child: Card(
              elevation: 5.0,
              child: Form(
                key: _formKey,
                autovalidate: true,
                child: Column(
                  children: <Widget>[
                    Theme(
                      data: ThemeData(
                          primaryColor: widget.gradient_end,
                          accentColor: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 8),
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: "E-mail",
                            labelStyle: TextStyle(),
                            border: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: widget.gradient_end),
                            ),
                            // border: OutlineInputBorder(borderSide: BorderSide(color: gradient_end)),
                            contentPadding: EdgeInsets.all(2.0),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value.isEmpty ||
                                !value.contains("@") ||
                                !value.contains(".")) {
                              return "Invalid Email";
                            }
                          },
                          onSaved: (value) {
                            _authData["email"] = value;
                          },
                        ),
                      ),
                    ),
                    Theme(
                      data: ThemeData(
                          primaryColor: widget.gradient_end,
                          accentColor: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 8),
                        child: TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: "Password",
                            labelStyle: TextStyle(),
                            border: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: widget.gradient_end),
                            ),
                            // border: OutlineInputBorder(borderSide: BorderSide(color: gradient_end)),
                            contentPadding: EdgeInsets.all(2.0),
                          ),
                          controller: _passwordController,
                          validator: (value) {
                            if (value.isEmpty || value.length < 8) {
                              return "Password should be atleast 8 characters long";
                            }
                          },
                          onSaved: (value) {
                            _authData["password"] = value;
                          },
                        ),
                      ),
                    ),
                    if (_authMode == AuthType.SignUp)
                      Theme(
                        data: ThemeData(
                            primaryColor: widget.gradient_end,
                            accentColor: Colors.white),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 8),
                          child: TextFormField(
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: "Confirm Password",
                                labelStyle: TextStyle(),
                                border: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: widget.gradient_end),
                                ),
                                // border: OutlineInputBorder(borderSide: BorderSide(color: gradient_end)),
                                contentPadding: EdgeInsets.all(2.0),
                              ),
                              validator: _authMode == AuthType.SignUp
                                  ? (value) {
                                      if (value != _passwordController.text) {
                                        return "Passwords do not match";
                                      }
                                    }
                                  : null),
                        ),
                      ),
                    if (_isLoading)
                      CircularProgressIndicator()
                    else
                      Container(
                        width: 140,
                        height: 40,
                        margin: EdgeInsets.only(top: 20),
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: Text(
                            _authMode == AuthType.Login ? "Log In" : "Sign Up",
                            style: TextStyle(fontSize: 20),
                          ),
                          onPressed: () {
                            _submit();
                          },
                          color: widget.gradient_end,
                          textColor: Colors.white,
                        ),
                      ),
                    FlatButton(
                      child: Text(
                        _authMode == AuthType.Login ? "Sign Up" : "Login",
                        style: TextStyle(fontSize: 18),
                      ),
                      onPressed: () {
                        setState(() {
                          toggleAuthMode();
                        });
                      },
                      textColor: widget.gradient_end,
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
