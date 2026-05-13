class FoodImages {
  // Изображения ресторанов
  static String mcdonalds = 'assets/images/restaurants/mcdonalds.png';
  static String dodoPizza = 'assets/images/restaurants/dodo_pizza.png';
  static String sushiMaster = 'assets/images/restaurants/sushi_hero.png';
  static String kfc = 'assets/images/restaurants/kfc.png';
  static String restaurant = 'assets/images/restaurants/restaurant_hero.jpg';
  static String faiza = 'assets/images/restaurants/faiza.png';

  // Изображения категорий блюд
  static String burger = 'assets/images/food/categories/burger.jpg';
  static String pizza = 'assets/images/food/categories/pizza.jpg';
  static String sushi = 'assets/images/food/categories/sushi.jpg';
  static String fries = 'assets/images/food/categories/chicken.jpeg';
  static String drink = 'assets/images/food/categories/drink.jpg';
  static String dessert = 'assets/images/food/categories/dessert.jpg';

  static String getImageForRestaurant(String restaurantName) {
    final name = restaurantName.toLowerCase();
    if (name.contains('макдоналдс')) return mcdonalds;
    if (name.contains('додо') || name.contains('пицца')) return dodoPizza;
    if (name.contains('суши')) return sushiMaster;
    if (name.contains('kfc')) return kfc;
    if (name.contains('фаиза')) return faiza;
    return restaurant;
  }

  static String getImageForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'burger':
      case 'бургер':
      case 'бургеры':
        return burger;
      case 'pizza':
      case 'пицца':
      case 'пиццы':
        return pizza;
      case 'sushi':
      case 'суши':
      case 'роллы':
        return sushi;
      case 'fries':
      case 'картофель':
      case 'картофель фри':
      case 'закуски':
        return fries;
      case 'dessert':
      case 'десерт':
      case 'десерты':
        return dessert;
      case 'drink':
      case 'напиток':
      case 'напитки':
        return drink;
      default:
        // Если категория неизвестна, вернем первое подходящее изображение
        if (category.contains('кур')) return burger;
        if (category.contains('суп')) return burger;
        if (category.contains('салат')) return burger;
        return burger;
    }
  }
}
