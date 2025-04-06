class CartItem {
  final int id;
  final int productId;
  final String productName;
  final double price;
  final String imageUrl;
  final int restaurantId;
  final String restaurantName;
  int quantity;

  CartItem({
    required this.id,
    required this.productId,
    required this.productName,
    required this.price,
    required this.imageUrl,
    required this.restaurantId,
    required this.restaurantName,
    this.quantity = 1,
  });

  double get total => price * quantity;

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      productId: json['productId'],
      productName: json['productName'],
      price: json['price'].toDouble(),
      imageUrl: json['imageUrl'],
      restaurantId: json['restaurantId'],
      restaurantName: json['restaurantName'],
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'productName': productName,
      'price': price,
      'imageUrl': imageUrl,
      'restaurantId': restaurantId,
      'restaurantName': restaurantName,
      'quantity': quantity,
    };
  }
}

class Cart {
  final List<CartItem> items;
  final int restaurantId;
  final String restaurantName;

  Cart({
    required this.items,
    required this.restaurantId,
    required this.restaurantName,
  });

  double get subtotal => items.fold(0, (total, item) => total + item.total);
  double get deliveryFee => 3.99;
  double get total => subtotal + deliveryFee;

  factory Cart.empty() {
    return Cart(items: [], restaurantId: 0, restaurantName: '');
  }

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      items:
          (json['items'] as List)
              .map((item) => CartItem.fromJson(item))
              .toList(),
      restaurantId: json['restaurantId'],
      restaurantName: json['restaurantName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
      'restaurantId': restaurantId,
      'restaurantName': restaurantName,
    };
  }

  bool get isEmpty => items.isEmpty;
}
