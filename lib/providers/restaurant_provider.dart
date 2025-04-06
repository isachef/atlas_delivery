import 'package:flutter/material.dart';
import '../models/restaurant.dart';
import '../models/product.dart';

class RestaurantProvider extends ChangeNotifier {
  bool _isLoading = false;
  List<Restaurant> _restaurants = [];
  Map<int, List<Product>> _restaurantProducts = {};
  List<Restaurant> _favoriteRestaurants = [];
  String _searchQuery = '';
  String _selectedCategory = 'Все';

  bool get isLoading => _isLoading;
  List<Restaurant> get restaurants =>
      isSearching ? _filteredRestaurants : _restaurants;
  List<Restaurant> get favoriteRestaurants => _favoriteRestaurants;

  bool get isSearching => _searchQuery.isNotEmpty;
  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;

  List<Restaurant> get _filteredRestaurants =>
      _restaurants
          .where(
            (restaurant) =>
                restaurant.name.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ) ||
                restaurant.description.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ) ||
                restaurant.categories.any(
                  (category) => category.toLowerCase().contains(
                    _searchQuery.toLowerCase(),
                  ),
                ),
          )
          .toList();

  List<String> get allCategories {
    final Set<String> categories = {};
    categories.add('Все');

    for (final restaurant in _restaurants) {
      categories.addAll(restaurant.categories);
    }

    return categories.toList()..sort();
  }

  List<Restaurant> getFilteredRestaurants() {
    if (_selectedCategory == 'Все') {
      return restaurants;
    }

    return restaurants
        .where(
          (restaurant) => restaurant.categories.contains(_selectedCategory),
        )
        .toList();
  }

  List<Product> getProductsByRestaurant(int restaurantId) {
    return _restaurantProducts[restaurantId] ?? [];
  }

  List<Product> getProductsByCategory(int restaurantId, String category) {
    final products = getProductsByRestaurant(restaurantId);

    if (category == 'Все') {
      return products;
    }

    return products.where((product) => product.category == category).toList();
  }

  List<String> getProductCategories(int restaurantId) {
    final products = getProductsByRestaurant(restaurantId);
    final Set<String> categories = {};
    categories.add('Все');

    for (final product in products) {
      categories.add(product.category);
    }

    return categories.toList()..sort();
  }

  Restaurant? getRestaurantById(int id) {
    try {
      return _restaurants.firstWhere((restaurant) => restaurant.id == id);
    } catch (e) {
      return null;
    }
  }

  Product? getProductById(int id) {
    for (final products in _restaurantProducts.values) {
      try {
        return products.firstWhere((product) => product.id == id);
      } catch (e) {}
    }
    return null;
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setSelectedCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  Future<void> loadRestaurants() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    _restaurants = [
      Restaurant(
        id: 1,
        name: 'Макдоналдс',
        description: 'Бургеры, картофель фри, напитки',
        imageUrl:
            'https://www.mcdonalds.com/content/dam/sites/ua/nfl/icons/navigation/restaurant.png',
        rating: 4.2,
        address: 'ул. Киевская, 148, Бишкек',
        deliveryFee: 150,
        minOrder: 500,
        deliveryTimeMinutes: 30,
        categories: ['Фастфуд', 'Бургеры', 'Американская кухня'],
        latitude: 42.876407,
        longitude: 74.569884,
      ),
      Restaurant(
        id: 2,
        name: 'Додо Пицца',
        description: 'Пицца, закуски, десерты',
        imageUrl:
            'https://dodopizza-a.akamaihd.net/site-static/dist/f30f1ab8cd7a7a54476d.svg',
        rating: 4.5,
        address: 'пр. Чуй, 102, Бишкек',
        deliveryFee: 120,
        minOrder: 600,
        deliveryTimeMinutes: 40,
        categories: ['Пицца', 'Итальянская кухня', 'Десерты'],
        latitude: 42.874532,
        longitude: 74.590371,
      ),
      Restaurant(
        id: 3,
        name: 'Суши Мастер',
        description: 'Суши, роллы, японская кухня',
        imageUrl: 'https://sushimaster.ru/assets/app/img/logo-circle.png',
        rating: 4.3,
        address: 'ул. Тоголок Молдо, 53, Бишкек',
        deliveryFee: 180,
        minOrder: 800,
        deliveryTimeMinutes: 50,
        categories: ['Суши', 'Роллы', 'Японская кухня'],
        latitude: 42.865853,
        longitude: 74.583854,
      ),
      Restaurant(
        id: 4,
        name: 'KFC',
        description: 'Курица, сэндвичи, снэки',
        imageUrl: 'https://www.kfc.ru/static/images/logo_kfc_mainpage.svg',
        rating: 4.1,
        address: 'ул. Абдрахманова, 155, Бишкек',
        deliveryFee: 140,
        minOrder: 450,
        deliveryTimeMinutes: 25,
        categories: ['Фастфуд', 'Курица', 'Американская кухня'],
        latitude: 42.870931,
        longitude: 74.592934,
      ),
      Restaurant(
        id: 5,
        name: 'Фаиза',
        description: 'Национальная и восточная кухня',
        imageUrl: 'https://tanuki.ru/upload/files/general/tanuki_logo.png',
        rating: 4.6,
        address: 'ул. Абдумомунова, 221, Бишкек',
        deliveryFee: 160,
        minOrder: 700,
        deliveryTimeMinutes: 45,
        categories: ['Лагман', 'Плов', 'Кыргызская кухня', 'Восточная кухня'],
        latitude: 42.867323,
        longitude: 74.598723,
      ),
    ];

    _restaurantProducts = {
      1: [
        Product(
          id: 101,
          name: 'Биг Мак',
          description:
              'Булочка, две говяжьи котлеты, соус, салат, сыр, маринованные огурцы, лук',
          price: 4.99,
          imageUrl:
              'https://www.mcdonalds.com/is/image/content/dam/usa/nfl/nutrition/items/hero/desktop/t-mcdonalds-Big-Mac.jpg',
          category: 'Бургеры',
          rating: 4.5,
          restaurantId: 1,
        ),
        Product(
          id: 102,
          name: 'Картофель Фри (средний)',
          description: 'Горячий хрустящий картофель фри с солью',
          price: 2.49,
          imageUrl:
              'https://www.mcdonalds.com/is/image/content/dam/usa/nfl/nutrition/items/hero/desktop/t-mcdonalds-Fries-Medium.jpg',
          category: 'Закуски',
          rating: 4.7,
          restaurantId: 1,
        ),
        Product(
          id: 103,
          name: 'Кока-Кола (средняя)',
          description: 'Освежающий газированный напиток',
          price: 1.99,
          imageUrl:
              'https://www.mcdonalds.com/is/image/content/dam/usa/nfl/nutrition/items/hero/desktop/t-mcdonalds-Coca-Cola-Medium.jpg',
          category: 'Напитки',
          rating: 4.3,
          restaurantId: 1,
        ),
        Product(
          id: 104,
          name: 'Чикен МакНаггетс (9 шт.)',
          description: 'Сочные куриные наггетсы из белого мяса',
          price: 5.49,
          imageUrl:
              'https://www.mcdonalds.com/is/image/content/dam/usa/nfl/nutrition/items/hero/desktop/t-mcdonalds-Chicken-McNuggets-9pc.jpg',
          category: 'Курица',
          rating: 4.6,
          restaurantId: 1,
        ),
      ],
      2: [
        Product(
          id: 201,
          name: 'Пепперони',
          description: 'Томатный соус, моцарелла, пепперони',
          price: 10.99,
          imageUrl:
              'https://dodopizza-a.akamaihd.net/static/Img/Products/Pizza/ru-RU/29570023-1fe1-46bd-921a-67197365b917.jpg',
          category: 'Пицца',
          rating: 4.8,
          restaurantId: 2,
        ),
        Product(
          id: 202,
          name: 'Маргарита',
          description: 'Томатный соус, моцарелла, томаты, итальянские травы',
          price: 8.99,
          imageUrl:
              'https://dodopizza-a.akamaihd.net/static/Img/Products/Pizza/ru-RU/12abb6bb-8f3c-43fd-bcaf-200286cb4eb9.jpg',
          category: 'Пицца',
          rating: 4.5,
          restaurantId: 2,
        ),
        Product(
          id: 203,
          name: 'Куриные крылышки (8 шт.)',
          description: 'Куриные крылышки со специями и соусом барбекю',
          price: 7.49,
          imageUrl:
              'https://dodopizza-a.akamaihd.net/static/Img/Products/Wings/ru-RU/a85d5e10-7579-4b71-b8b7-e82f76ea0974.jpg',
          category: 'Закуски',
          rating: 4.4,
          restaurantId: 2,
        ),
        Product(
          id: 204,
          name: 'Тирамису',
          description: 'Итальянский десерт с маскарпоне и кофе',
          price: 4.49,
          imageUrl:
              'https://dodopizza-a.akamaihd.net/static/Img/Products/Dessert/ru-RU/9e71077c-e641-4916-a1ee-cf29286e5f93.jpg',
          category: 'Десерты',
          rating: 4.7,
          restaurantId: 2,
        ),
      ],
      3: [
        Product(
          id: 301,
          name: 'Филадельфия',
          description: 'Сливочный сыр, лосось, огурец, авокадо',
          price: 12.99,
          imageUrl:
              'https://sushimaster.ru/assets/app/img/menu/rolls/philadelphia.jpg',
          category: 'Роллы',
          rating: 4.9,
          restaurantId: 3,
        ),
        Product(
          id: 302,
          name: 'Калифорния',
          description: 'Снежный краб, авокадо, огурец, тобико',
          price: 10.99,
          imageUrl:
              'https://sushimaster.ru/assets/app/img/menu/rolls/california.jpg',
          category: 'Роллы',
          rating: 4.6,
          restaurantId: 3,
        ),
        Product(
          id: 303,
          name: 'Суши с лососем (2 шт.)',
          description: 'Рис, лосось, васаби',
          price: 4.99,
          imageUrl:
              'https://sushimaster.ru/assets/app/img/menu/sushi/salmon.jpg',
          category: 'Суши',
          rating: 4.8,
          restaurantId: 3,
        ),
        Product(
          id: 304,
          name: 'Мисо суп',
          description: 'Традиционный японский суп с тофу и водорослями',
          price: 3.49,
          imageUrl: 'https://sushimaster.ru/assets/app/img/menu/soup/miso.jpg',
          category: 'Супы',
          rating: 4.3,
          restaurantId: 3,
        ),
      ],
      4: [
        Product(
          id: 401,
          name: 'Баскет 8 ножек',
          description: 'Острые куриные ножки в панировке',
          price: 11.99,
          imageUrl: 'https://www.kfc.ru/static/images/menu/basket_8_legs.png',
          category: 'Курица',
          rating: 4.7,
          restaurantId: 4,
        ),
        Product(
          id: 402,
          name: 'Твистер Оригинальный',
          description: 'Куриная грудка, салат, томаты, соус в тортилье',
          price: 4.99,
          imageUrl:
              'https://www.kfc.ru/static/images/menu/twister_original.png',
          category: 'Сэндвичи',
          rating: 4.5,
          restaurantId: 4,
        ),
        Product(
          id: 403,
          name: 'Картофель Фри (средний)',
          description: 'Хрустящий картофель фри',
          price: 2.49,
          imageUrl: 'https://www.kfc.ru/static/images/menu/fries_medium.png',
          category: 'Закуски',
          rating: 4.4,
          restaurantId: 4,
        ),
        Product(
          id: 404,
          name: 'Милкшейк Ванильный',
          description: 'Нежный молочный коктейль с ванильным вкусом',
          price: 3.49,
          imageUrl:
              'https://www.kfc.ru/static/images/menu/milkshake_vanilla.png',
          category: 'Напитки',
          rating: 4.6,
          restaurantId: 4,
        ),
      ],
      5: [
        Product(
          id: 501,
          name: 'Дракон Ролл',
          description: 'Угорь, авокадо, огурец, соус унаги',
          price: 14.99,
          imageUrl:
              'https://tanuki.ru/upload/iblock/6aa/6aa38f66242a2d0a6b9c00a0af3bae6f.jpg',
          category: 'Роллы',
          rating: 4.9,
          restaurantId: 5,
        ),
        Product(
          id: 502,
          name: 'Том Ям с креветками',
          description:
              'Острый тайский суп с креветками, грибами и лемонграссом',
          price: 8.99,
          imageUrl:
              'https://tanuki.ru/upload/iblock/c52/c52e20a3ad171c7a7c7c25dd56d1a33a.jpg',
          category: 'Супы',
          rating: 4.7,
          restaurantId: 5,
        ),
        Product(
          id: 503,
          name: 'Лапша Пад Тай',
          description: 'Рисовая лапша с курицей, яйцом, овощами и арахисом',
          price: 9.49,
          imageUrl:
              'https://tanuki.ru/upload/iblock/15e/15edd1c00e03e2a0ecf973e5f3009bac.jpg',
          category: 'Горячие блюда',
          rating: 4.6,
          restaurantId: 5,
        ),
        Product(
          id: 504,
          name: 'Моти',
          description: 'Японские рисовые пирожные с разными начинками',
          price: 5.99,
          imageUrl:
              'https://tanuki.ru/upload/iblock/1c0/1c0cd5f0b71c1fc91f24d2a0a71f0ff9.jpg',
          category: 'Десерты',
          rating: 4.5,
          restaurantId: 5,
        ),
      ],
    };

    _isLoading = false;
    notifyListeners();
  }

  void updateFavorites(List<String> favoriteIds) {
    _favoriteRestaurants =
        _restaurants
            .where(
              (restaurant) => favoriteIds.contains(restaurant.id.toString()),
            )
            .toList();
    notifyListeners();
  }
}
