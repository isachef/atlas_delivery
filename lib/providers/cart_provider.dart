import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart.dart';
import '../models/product.dart';

class CartProvider extends ChangeNotifier {
  Cart _cart = Cart.empty();
  bool _isLoading = false;

  Cart get cart => _cart;
  bool get isLoading => _isLoading;
  bool get isEmpty => _cart.isEmpty;
  int get itemCount => _cart.items.length;
  double get subtotal => _cart.subtotal;
  double get deliveryFee => _cart.deliveryFee;
  double get total => _cart.total;

  Future<void> loadCart() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJson = prefs.getString('cart');

      if (cartJson != null) {
        _cart = Cart.fromJson(json.decode(cartJson));
      }
    } catch (e) {
      debugPrint('Ошибка загрузки корзины: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('cart', json.encode(_cart.toJson()));
    } catch (e) {
      debugPrint('Ошибка сохранения корзины: $e');
    }
  }

  Future<void> addToCart(Product product, String restaurantName) async {
    if (_cart.isEmpty || _cart.restaurantId == product.restaurantId) {
      final existingItemIndex = _cart.items.indexWhere(
        (item) => item.productId == product.id,
      );

      if (existingItemIndex != -1) {
        // Обновляем существующий товар
        final updatedItems = List<CartItem>.from(_cart.items);
        updatedItems[existingItemIndex].quantity += 1;

        _cart = Cart(
          items: updatedItems,
          restaurantId: product.restaurantId,
          restaurantName: restaurantName,
        );
      } else {
        // Добавляем новый товар
        final newItem = CartItem(
          id: DateTime.now().millisecondsSinceEpoch,
          productId: product.id,
          productName: product.name,
          price: product.price,
          imageUrl: product.imageUrl,
          restaurantId: product.restaurantId,
          restaurantName: restaurantName,
        );

        _cart = Cart(
          items: [..._cart.items, newItem],
          restaurantId: product.restaurantId,
          restaurantName: restaurantName,
        );
      }
    } else {
      // Начинаем новую корзину из другого ресторана
      _cart = Cart(
        items: [
          CartItem(
            id: DateTime.now().millisecondsSinceEpoch,
            productId: product.id,
            productName: product.name,
            price: product.price,
            imageUrl: product.imageUrl,
            restaurantId: product.restaurantId,
            restaurantName: restaurantName,
          ),
        ],
        restaurantId: product.restaurantId,
        restaurantName: restaurantName,
      );
    }

    await saveCart();
    notifyListeners();
  }

  Future<void> removeFromCart(int itemId) async {
    _cart = Cart(
      items: _cart.items.where((item) => item.id != itemId).toList(),
      restaurantId: _cart.restaurantId,
      restaurantName: _cart.restaurantName,
    );

    await saveCart();
    notifyListeners();
  }

  Future<void> updateQuantity(int itemId, int quantity) async {
    if (quantity <= 0) {
      await removeFromCart(itemId);
      return;
    }

    final updatedItems =
        _cart.items.map((item) {
          if (item.id == itemId) {
            item.quantity = quantity;
          }
          return item;
        }).toList();

    _cart = Cart(
      items: updatedItems,
      restaurantId: _cart.restaurantId,
      restaurantName: _cart.restaurantName,
    );

    await saveCart();
    notifyListeners();
  }

  Future<void> clearCart() async {
    _cart = Cart.empty();
    await saveCart();
    notifyListeners();
  }
}
