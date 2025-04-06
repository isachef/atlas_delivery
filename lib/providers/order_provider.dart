import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart.dart';
import '../models/order.dart';

class OrderProvider extends ChangeNotifier {
  List<Order> _orders = [];
  bool _isLoading = false;

  List<Order> get orders => _orders;
  bool get isLoading => _isLoading;

  Future<void> loadOrders() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final ordersJson = prefs.getString('orders');

      if (ordersJson != null) {
        final List<dynamic> ordersList = json.decode(ordersJson);
        _orders = ordersList.map((e) => Order.fromJson(e)).toList();
      }
    } catch (e) {
      debugPrint('Ошибка загрузки заказов: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveOrders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        'orders',
        json.encode(_orders.map((e) => e.toJson()).toList()),
      );
    } catch (e) {
      debugPrint('Ошибка сохранения заказов: $e');
    }
  }

  Future<Order> placeOrder({
    required Cart cart,
    required Address deliveryAddress,
    required PaymentMethod paymentMethod,
    String? note,
    String? couponCode,
    double? discount,
  }) async {
    _isLoading = true;
    notifyListeners();

    // Имитация задержки сетевого запроса
    await Future.delayed(const Duration(seconds: 1));

    final newOrder = Order.fromCart(
      cart,
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      status: OrderStatus.pending,
      createdAt: DateTime.now(),
      deliveryAddress: deliveryAddress,
      paymentMethod: paymentMethod,
      note: note,
      couponCode: couponCode,
      discount: discount,
    );

    _orders.add(newOrder);
    await saveOrders();

    _isLoading = false;
    notifyListeners();

    return newOrder;
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    final index = _orders.indexWhere((order) => order.id == orderId);

    if (index != -1) {
      // Создаем новый обновленный заказ
      final updatedOrder = Order(
        id: _orders[index].id,
        restaurantId: _orders[index].restaurantId,
        restaurantName: _orders[index].restaurantName,
        items: _orders[index].items,
        subtotal: _orders[index].subtotal,
        deliveryFee: _orders[index].deliveryFee,
        total: _orders[index].total,
        status: status,
        createdAt: _orders[index].createdAt,
        deliveryAddress: _orders[index].deliveryAddress,
        paymentMethod: _orders[index].paymentMethod,
        note: _orders[index].note,
        couponCode: _orders[index].couponCode,
        discount: _orders[index].discount,
      );

      _orders[index] = updatedOrder;
      await saveOrders();
      notifyListeners();
    }
  }

  Future<void> cancelOrder(String orderId) async {
    await updateOrderStatus(orderId, OrderStatus.cancelled);
  }

  // Демо метод для обновления статусов заказов
  // в реальном приложении это будет происходить через push-уведомления или websocket
  Future<void> simulateOrderProgress() async {
    // Находим первый заказ со статусом pending
    final index = _orders.indexWhere(
      (order) => order.status == OrderStatus.pending,
    );

    if (index != -1) {
      await updateOrderStatus(_orders[index].id, OrderStatus.processing);
      await Future.delayed(const Duration(seconds: 5));
      await updateOrderStatus(_orders[index].id, OrderStatus.delivering);
      await Future.delayed(const Duration(seconds: 5));
      await updateOrderStatus(_orders[index].id, OrderStatus.delivered);
    }
  }
}
