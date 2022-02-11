import 'package:flutter/foundation.dart';

import '../entities/product.dart';

class CartController extends ChangeNotifier {
  var cart = <Product>[];

  void addProductToCart(Product product) {
    cart.add(product);
    notifyListeners();
  }

  void removeProductFromCart(Product product) {
    cart.remove(product);
    notifyListeners();
  }
}
