import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';

class EditUserProducts extends StatefulWidget {
  static const routeName = "edit-products";

  EditUserProducts({Key key}) : super(key: key);

  @override
  _EditUserProductsState createState() => _EditUserProductsState();
}

class _EditUserProductsState extends State<EditUserProducts> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct =
      Product(id: null, title: "", description: "", imageUrl: "", price: 0);
  var _initState = true;
  var _initialValues = {
    "title": "",
    "price": "",
    "description": "",
    "imageUrl": "",
  };
  var _isLoading = false;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImagePreview);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_initState) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct = Provider.of<Products>(context).findById(productId);
        _initialValues = {
          "title": _editedProduct.title,
          "price": _editedProduct.price.toString(),
          "description": _editedProduct.description,
          "imageUrl": _editedProduct.imageUrl,
        };
      }
      _imageUrlController.text = _editedProduct.imageUrl;
    }
    _initState = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImagePreview);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _updateImagePreview() {
    if (!_imageUrlController.text.isEmpty) {
      setState(() {
        Image.network(_imageUrlController.text);
      });
    } else {
      setState(() {
        Center(
          child: Text("Enter a valid url"),
        );
      });
    }
  }

  void _saveForm() {
    // var _validator = _form.currentState.validate();
    // if (!_validator){
    //   return;
    // }
    _form.currentState.save();
    _isLoading = true;
    if (_editedProduct.id != null) {
      Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
      setState(() {
        _isLoading = false;
      });
    } else {
      Provider.of<Products>(context, listen: false)
          .addProduct(_editedProduct)
          .then((_) {
        Navigator.of(context).pop();
        setState(() {
          _isLoading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Products"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              _saveForm();
            },
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: _form,
              autovalidate: true,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        initialValue: _initialValues["title"],
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Title",
                        ),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (value) => FocusScope.of(context)
                            .requestFocus(_priceFocusNode),
                        onSaved: (titleValue) {
                          _editedProduct = Product(
                            id: _editedProduct.id,
                            title: titleValue,
                            description: _editedProduct.description,
                            imageUrl: _editedProduct.imageUrl,
                            price: _editedProduct.price,
                            isFavourite: _editedProduct.isFavourite,
                          );
                        },
                        validator: (value) {
                          if (!value.isEmpty) {
                            return null;
                          }
                          return "Please Enter a value";
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        initialValue: _initialValues["price"],
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Price",
                        ),
                        textInputAction: TextInputAction.next,
                        focusNode: _priceFocusNode,
                        keyboardType: TextInputType.number,
                        onFieldSubmitted: (value) => FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode),
                        onSaved: (priceValue) {
                          _editedProduct = Product(
                            id: _editedProduct.id,
                            title: _editedProduct.title,
                            description: _editedProduct.description,
                            imageUrl: _editedProduct.imageUrl,
                            price: double.parse(priceValue),
                            isFavourite: _editedProduct.isFavourite,
                          );
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please Enter a price";
                          }
                          if (double.tryParse(value) == null) {
                            return "Please Enter a valid price";
                          }
                          if (double.parse(value) <= 0) {
                            return "Please Enter a value greater than zero";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        initialValue: _initialValues["description"],
                        decoration: InputDecoration(
                          labelText: "Description",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                        ),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.multiline,
                        focusNode: _descriptionFocusNode,
                        maxLines: 3,
                        onSaved: (descriptionValue) {
                          _editedProduct = Product(
                            id: _editedProduct.id,
                            title: _editedProduct.title,
                            description: descriptionValue,
                            imageUrl: _editedProduct.imageUrl,
                            price: _editedProduct.price,
                            isFavourite: _editedProduct.isFavourite,
                          );
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please Enter a description";
                          }
                          if (value.length < 10) {
                            return "Description should be 10 characters long";
                          }
                          return null;
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            width: 100,
                            height: 100,
                            margin: EdgeInsets.only(
                              top: 10,
                              right: 10,
                              left: 5,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context).primaryColor,
                                width: 1,
                              ),
                            ),
                            child: _imageUrlController.text.isEmpty
                                ? Center(
                                    child: Text(
                                      "Enter a valid URL",
                                      softWrap: true,
                                    ),
                                  )
                                : FittedBox(
                                    child: Image.network(
                                      _imageUrlController.text,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: "Image URL",
                                border: OutlineInputBorder(),
                              ),
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.url,
                              controller: _imageUrlController,
                              focusNode: _imageUrlFocusNode,
                              onFieldSubmitted: (value) {
                                _saveForm();
                              },
                              onSaved: (imageValue) {
                                _editedProduct = Product(
                                  id: _editedProduct.id,
                                  title: _editedProduct.title,
                                  description: _editedProduct.description,
                                  imageUrl: imageValue,
                                  price: _editedProduct.price,
                                  isFavourite: _editedProduct.isFavourite,
                                );
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Please Enter an image url";
                                }
                                if (!value.startsWith("http") ||
                                    !value.startsWith("https")) {
                                  return "Please enter a valid image url";
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
