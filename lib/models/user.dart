class User {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final String? photoUrl;
  final List<String> favoriteRestaurants;
  final List<String> favoriteProducts;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.photoUrl,
    this.favoriteRestaurants = const [],
    this.favoriteProducts = const [],
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      photoUrl: json['photoUrl'],
      favoriteRestaurants: List<String>.from(json['favoriteRestaurants'] ?? []),
      favoriteProducts: List<String>.from(json['favoriteProducts'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'photoUrl': photoUrl,
      'favoriteRestaurants': favoriteRestaurants,
      'favoriteProducts': favoriteProducts,
    };
  }

  User copyWith({
    String? name,
    String? email,
    String? phoneNumber,
    String? photoUrl,
    List<String>? favoriteRestaurants,
    List<String>? favoriteProducts,
  }) {
    return User(
      id: this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photoUrl: photoUrl ?? this.photoUrl,
      favoriteRestaurants: favoriteRestaurants ?? this.favoriteRestaurants,
      favoriteProducts: favoriteProducts ?? this.favoriteProducts,
    );
  }
}
