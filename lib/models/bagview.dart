import 'package:ecom_store_riv/models/product.dart';
import 'package:flutter/cupertino.dart';

class BagViewModel extends ChangeNotifier {
  final List<Product> productBag;

  BagViewModel() : productBag = [];

  void addProduct(Product product) {
    productBag.add(product);
    notifyListeners();
  }

  void removeProduct(Product product) {
    productBag.remove(product);
  }

  void clearBag() {
    productBag.clear();
    notifyListeners();
  }

  //getters
  int get totalProducts => productBag.length;

  double get totalPrice => productBag.fold(
        0,
        (total, product) {
          return total + product.price;
        },
      );

  bool get isBagEmpty => productBag.isEmpty;
}
