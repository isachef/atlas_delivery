class Restaurant {
  final int id;
  final String name;
  final String description;
  final String imageUrl;
  final double rating;
  final String address;
  final double deliveryFee;
  final double minOrder;
  final int deliveryTimeMinutes;
  final List<String> categories;
  final double latitude;
  final double longitude;

  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.rating,
    required this.address,
    required this.deliveryFee,
    required this.minOrder,
    required this.deliveryTimeMinutes,
    required this.categories,
    required this.latitude,
    required this.longitude,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      rating: json['rating'].toDouble(),
      address: json['address'],
      deliveryFee: json['deliveryFee'].toDouble(),
      minOrder: json['minOrder'].toDouble(),
      deliveryTimeMinutes: json['deliveryTimeMinutes'],
      categories: List<String>.from(json['categories']),
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'rating': rating,
      'address': address,
      'deliveryFee': deliveryFee,
      'minOrder': minOrder,
      'deliveryTimeMinutes': deliveryTimeMinutes,
      'categories': categories,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
