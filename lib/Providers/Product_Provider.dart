import 'package:flutter/material.dart';

class ProductProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _products = [];

  List<Map<String, dynamic>> get products => List.unmodifiable(_products);

  void addProduct(Map<String, dynamic> product) {
    _products.add(product);
    notifyListeners();
  }

  void updateProduct(int id, Map<String, dynamic> updatedProduct) {
    final index = _products.indexWhere((p) => p['id'] == id);
    if (index != -1) {
      _products[index] = updatedProduct;
      notifyListeners();
    }
  }

  void removeProduct(int id) {
    _products.removeWhere((p) => p['id'] == id);
    notifyListeners();
  }

  int get nextProductId {
    if (_products.isEmpty) return 1;
    return _products.map((p) => p['id'] as int).reduce((a, b) => a > b ? a : b) + 1;
  }
}
