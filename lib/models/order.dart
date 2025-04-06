import 'cart.dart';

enum OrderStatus { pending, processing, delivering, delivered, cancelled }

class PaymentMethod {
  final String id;
  final String name;
  final String icon;
  final String lastFourDigits;
  final bool isDefault;
  final String? type;
  final String? last4;

  PaymentMethod({
    required this.id,
    required this.name,
    required this.icon,
    required this.lastFourDigits,
    this.isDefault = false,
    this.type,
    this.last4,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['id'],
      name: json['name'] ?? json['title'] ?? '',
      icon: json['icon'] ?? json['type'] ?? '',
      lastFourDigits: json['lastFourDigits'] ?? json['last4'] ?? '',
      isDefault: json['isDefault'] ?? false,
      type: json['type'],
      last4: json['last4'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'lastFourDigits': lastFourDigits,
      'isDefault': isDefault,
      'type': type,
      'last4': last4,
    };
  }
}

class Address {
  final String id;
  final String street;
  final String city;
  final String postalCode;
  final String country;
  final String label;
  final double latitude;
  final double longitude;
  final bool isDefault;
  final String? title;
  final String? address;

  Address({
    required this.id,
    required this.street,
    required this.city,
    required this.postalCode,
    required this.country,
    required this.label,
    required this.latitude,
    required this.longitude,
    this.isDefault = false,
    this.title,
    this.address,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      id: json['id'],
      street: json['street'] ?? json['address'] ?? '',
      city: json['city'] ?? 'Бишкек',
      postalCode: json['postalCode'] ?? '720000',
      country: json['country'] ?? 'Кыргызстан',
      label: json['label'] ?? json['title'] ?? '',
      latitude: (json['latitude'] ?? 42.87).toDouble(),
      longitude: (json['longitude'] ?? 74.59).toDouble(),
      isDefault: json['isDefault'] ?? false,
      title: json['title'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'street': street,
      'city': city,
      'postalCode': postalCode,
      'country': country,
      'label': label,
      'latitude': latitude,
      'longitude': longitude,
      'isDefault': isDefault,
      'title': title ?? label,
      'address': address ?? street,
    };
  }

  String get fullAddress => '$street, $city, $postalCode, $country';
}

class Order {
  final String id;
  final int restaurantId;
  final String restaurantName;
  final List<CartItem> items;
  final double subtotal;
  final double deliveryFee;
  final double total;
  final OrderStatus status;
  final DateTime createdAt;
  final Address deliveryAddress;
  final PaymentMethod paymentMethod;
  final String? note;
  final String? couponCode;
  final double? discount;

  Order({
    required this.id,
    required this.restaurantId,
    required this.restaurantName,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
    required this.status,
    required this.createdAt,
    required this.deliveryAddress,
    required this.paymentMethod,
    this.note,
    this.couponCode,
    this.discount,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      restaurantId: json['restaurantId'],
      restaurantName: json['restaurantName'],
      items:
          (json['items'] as List)
              .map((item) => CartItem.fromJson(item))
              .toList(),
      subtotal: json['subtotal'].toDouble(),
      deliveryFee: json['deliveryFee'].toDouble(),
      total: json['total'].toDouble(),
      status: OrderStatus.values[json['status']],
      createdAt: DateTime.parse(json['createdAt']),
      deliveryAddress: Address.fromJson(json['deliveryAddress']),
      paymentMethod: PaymentMethod.fromJson(json['paymentMethod']),
      note: json['note'],
      couponCode: json['couponCode'],
      discount: json['discount']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'restaurantId': restaurantId,
      'restaurantName': restaurantName,
      'items': items.map((item) => item.toJson()).toList(),
      'subtotal': subtotal,
      'deliveryFee': deliveryFee,
      'total': total,
      'status': status.index,
      'createdAt': createdAt.toIso8601String(),
      'deliveryAddress': deliveryAddress.toJson(),
      'paymentMethod': paymentMethod.toJson(),
      'note': note,
      'couponCode': couponCode,
      'discount': discount,
    };
  }

  factory Order.fromCart(
    Cart cart, {
    required String id,
    required OrderStatus status,
    required DateTime createdAt,
    required Address deliveryAddress,
    required PaymentMethod paymentMethod,
    String? note,
    String? couponCode,
    double? discount,
  }) {
    return Order(
      id: id,
      restaurantId: cart.restaurantId,
      restaurantName: cart.restaurantName,
      items: cart.items,
      subtotal: cart.subtotal,
      deliveryFee: cart.deliveryFee,
      total: cart.total - (discount ?? 0),
      status: status,
      createdAt: createdAt,
      deliveryAddress: deliveryAddress,
      paymentMethod: paymentMethod,
      note: note,
      couponCode: couponCode,
      discount: discount,
    );
  }
}
