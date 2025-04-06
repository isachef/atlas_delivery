class FoodImages {
  static const String _basePath = 'https://images.unsplash.com/photo-';

  static String burger1 =
      '${_basePath}1568901346375-23c9450c58cd?w=500&auto=format';
  static String burger2 =
      '${_basePath}1550317138-6a8b75f3c4a3?w=500&auto=format';
  static String burger3 =
      '${_basePath}1550547660-d9450f859349?w=500&auto=format';
  static String burger4 =
      '${_basePath}1586190848861-99aa4a171e90?w=500&auto=format';

  static String pizza1 =
      '${_basePath}1565299624946-b28f40a0ae38?w=500&auto=format';
  static String pizza2 =
      '${_basePath}1593504049359-74330189a345?w=500&auto=format';
  static String pizza3 =
      '${_basePath}1628840042765-356cda07367e?w=500&auto=format';
  static String pizza4 =
      '${_basePath}1513104890138-7c749659a591?w=500&auto=format';

  static String sushi1 =
      '${_basePath}1553621042-f6e147245754?w=500&auto=format';
  static String sushi2 =
      '${_basePath}1579871494447-9811cf80d66c?w=500&auto=format';
  static String sushi3 =
      '${_basePath}1617196034796-73dfa7b1fb52?w=500&auto=format';
  static String sushi4 =
      '${_basePath}1583623025453-7fc93c9a4882?w=500&auto=format';

  static String salad1 =
      '${_basePath}1546069901-ba9599a7e63c?w=500&auto=format';
  static String salad2 =
      '${_basePath}1540420773420-3366772f4999?w=500&auto=format';
  static String salad3 =
      '${_basePath}1505253716362-36a40f8523fa?w=500&auto=format';
  static String salad4 =
      '${_basePath}1564675803565-4395a9a2c4d3?w=500&auto=format';

  static String pasta1 =
      '${_basePath}1627308595229-7830a5c91f9f?w=500&auto=format';
  static String pasta2 =
      '${_basePath}1556761223-4c60b45f51cd?w=500&auto=format';
  static String pasta3 =
      '${_basePath}1563379926898-05f4575a45d8?w=500&auto=format';
  static String pasta4 =
      '${_basePath}1473093295043-cdd812d0e601?w=500&auto=format';

  static String dessert1 =
      '${_basePath}1587314168485-3236d6710814?w=500&auto=format';
  static String dessert2 =
      '${_basePath}1551024709-8f23befc6f87?w=500&auto=format';
  static String dessert3 =
      '${_basePath}1488477181946-6428a0291777?w=500&auto=format';
  static String dessert4 =
      '${_basePath}1563805042-7684c019e1cb?w=500&auto=format';

  static String drink1 =
      '${_basePath}1544145945-f9347d4e26a8?w=500&auto=format';
  static String drink2 =
      '${_basePath}1513558161293-cdaf765ed2fd?w=500&auto=format';
  static String drink3 =
      '${_basePath}1527661650979-e04638a3a171?w=500&auto=format';
  static String drink4 =
      '${_basePath}1497534446932-c925b458314e?w=500&auto=format';

  static String breakfast1 =
      '${_basePath}1533089860892-a886cc845dbc?w=500&auto=format';
  static String breakfast2 =
      '${_basePath}1533089860892-a886cc845dbc?w=500&auto=format';
  static String breakfast3 =
      '${_basePath}1494597564530-0bc83d4237d4?w=500&auto=format';
  static String breakfast4 =
      '${_basePath}1484723091739-30a097e8f929?w=500&auto=format';

  static String getRandomForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'burger':
      case 'бургер':
      case 'бургеры':
        return [burger1, burger2, burger3, burger4][DateTime.now().microsecond %
            4];
      case 'pizza':
      case 'пицца':
      case 'пиццы':
        return [pizza1, pizza2, pizza3, pizza4][DateTime.now().microsecond % 4];
      case 'sushi':
      case 'суши':
      case 'роллы':
        return [sushi1, sushi2, sushi3, sushi4][DateTime.now().microsecond % 4];
      case 'salad':
      case 'салат':
      case 'салаты':
        return [salad1, salad2, salad3, salad4][DateTime.now().microsecond % 4];
      case 'pasta':
      case 'паста':
      case 'макароны':
        return [pasta1, pasta2, pasta3, pasta4][DateTime.now().microsecond % 4];
      case 'dessert':
      case 'десерт':
      case 'десерты':
        return [
          dessert1,
          dessert2,
          dessert3,
          dessert4,
        ][DateTime.now().microsecond % 4];
      case 'drink':
      case 'напиток':
      case 'напитки':
        return [drink1, drink2, drink3, drink4][DateTime.now().microsecond % 4];
      case 'breakfast':
      case 'завтрак':
      case 'завтраки':
        return [
          breakfast1,
          breakfast2,
          breakfast3,
          breakfast4,
        ][DateTime.now().microsecond % 4];
      default:
        final allImages = [
          burger1,
          burger2,
          pizza1,
          pizza2,
          sushi1,
          sushi2,
          salad1,
          salad2,
          pasta1,
          pasta2,
          dessert1,
          dessert2,
          drink1,
          drink2,
          breakfast1,
          breakfast2,
        ];
        return allImages[DateTime.now().microsecond % allImages.length];
    }
  }
}
