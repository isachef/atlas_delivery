import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../models/order.dart';

class UserProvider extends ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  List<Address> _addresses = [];
  List<PaymentMethod> _paymentMethods = [];

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _user != null;
  List<Address> get addresses => _addresses;
  List<PaymentMethod> get paymentMethods => _paymentMethods;

  Future<void> loadUser() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('user');
      final addressesJson = prefs.getString('addresses');
      final paymentMethodsJson = prefs.getString('paymentMethods');

      if (userJson != null) {
        _user = User.fromJson(json.decode(userJson));
      }

      if (addressesJson != null) {
        final List<dynamic> addressesList = json.decode(addressesJson);
        _addresses = addressesList.map((e) => Address.fromJson(e)).toList();
      }

      if (paymentMethodsJson != null) {
        final List<dynamic> paymentList = json.decode(paymentMethodsJson);
        _paymentMethods =
            paymentList.map((e) => PaymentMethod.fromJson(e)).toList();
      }
    } catch (e) {
      debugPrint('Ошибка загрузки данных пользователя: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveUser() async {
    if (_user == null) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user', json.encode(_user!.toJson()));
      await prefs.setString(
        'addresses',
        json.encode(_addresses.map((e) => e.toJson()).toList()),
      );
      await prefs.setString(
        'paymentMethods',
        json.encode(_paymentMethods.map((e) => e.toJson()).toList()),
      );
    } catch (e) {
      debugPrint('Ошибка сохранения данных пользователя: $e');
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    if (email == 'user@example.com' && password == 'password') {
      _user = User(
        id: '1',
        name: 'Азамат Каримов',
        email: email,
        phoneNumber: '+996550123456',
        photoUrl: 'https://ui-avatars.com/api/?name=Demo+User',
      );

      _addresses = [
        Address(
          id: '1',
          street: 'ул. Токтогула, 214/1, кв. 42',
          city: 'Бишкек',
          postalCode: '720001',
          country: 'Кыргызстан',
          label: 'Дом',
          latitude: 42.876112,
          longitude: 74.603240,
        ),
        Address(
          id: '2',
          street: 'ул. Киевская, 96Б, офис 705',
          city: 'Бишкек',
          postalCode: '720010',
          country: 'Кыргызстан',
          label: 'Работа',
          latitude: 42.873583,
          longitude: 74.592364,
        ),
      ];

      _paymentMethods = [
        PaymentMethod(
          id: '1',
          name: 'Наличные',
          icon: 'cash',
          lastFourDigits: '',
        ),
        PaymentMethod(
          id: '2',
          name: 'Элкарт',
          icon: 'card',
          lastFourDigits: '4578',
        ),
      ];

      await saveUser();
      _isLoading = false;
      notifyListeners();
      return true;
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user');
      await prefs.remove('addresses');
      await prefs.remove('paymentMethods');

      _user = null;
      _addresses = [];
      _paymentMethods = [];
    } catch (e) {
      debugPrint('Ошибка при выходе: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addAddress(Address address) async {
    _addresses.add(address);
    await saveUser();
    notifyListeners();
  }

  Future<void> updateAddress(Address address) async {
    final index = _addresses.indexWhere((a) => a.id == address.id);
    if (index != -1) {
      _addresses[index] = address;
      await saveUser();
      notifyListeners();
    }
  }

  Future<void> deleteAddress(String addressId) async {
    _addresses.removeWhere((a) => a.id == addressId);
    await saveUser();
    notifyListeners();
  }

  Future<void> addPaymentMethod(PaymentMethod paymentMethod) async {
    _paymentMethods.add(paymentMethod);
    await saveUser();
    notifyListeners();
  }

  Future<void> deletePaymentMethod(String paymentMethodId) async {
    _paymentMethods.removeWhere((p) => p.id == paymentMethodId);
    await saveUser();
    notifyListeners();
  }

  Future<void> toggleFavoriteRestaurant(String restaurantId) async {
    if (_user == null) return;

    final List<String> favorites = List.from(_user!.favoriteRestaurants);
    if (favorites.contains(restaurantId)) {
      favorites.remove(restaurantId);
    } else {
      favorites.add(restaurantId);
    }

    _user = _user!.copyWith(favoriteRestaurants: favorites);
    await saveUser();
    notifyListeners();
  }

  Future<void> toggleFavoriteProduct(String productId) async {
    if (_user == null) return;

    final List<String> favorites = List.from(_user!.favoriteProducts);
    if (favorites.contains(productId)) {
      favorites.remove(productId);
    } else {
      favorites.add(productId);
    }

    _user = _user!.copyWith(favoriteProducts: favorites);
    await saveUser();
    notifyListeners();
  }

  bool isRestaurantFavorite(String restaurantId) {
    if (_user == null) return false;
    return _user!.favoriteRestaurants.contains(restaurantId);
  }

  bool isProductFavorite(String productId) {
    if (_user == null) return false;
    return _user!.favoriteProducts.contains(productId);
  }
}
