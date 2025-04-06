import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/restaurant_provider.dart';
import '../providers/user_provider.dart';
import '../constants/app_colors.dart';
import '../widgets/restaurant_card.dart';
import '../widgets/category_filter.dart';
import '../widgets/search_bar.dart';
import 'restaurant_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Загружаем данные при инициализации экрана
    Future.microtask(() {
      final restaurantProvider = Provider.of<RestaurantProvider>(
        context,
        listen: false,
      );
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      restaurantProvider.loadRestaurants();
      userProvider.loadUser();

      // Обновляем избранные рестораны, если пользователь авторизован
      if (userProvider.user != null) {
        restaurantProvider.updateFavorites(
          userProvider.user!.favoriteRestaurants,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Row(
          children: [
            Image.asset(
              'assets/icons/logo_atlas.png',
              height: 30,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 8),
            const Text('Atlas Доставка'),
          ],
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              // Переход на экран корзины
              Navigator.pushNamed(context, '/cart');
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // Переход на экран профиля
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
      ),
      body: Consumer<RestaurantProvider>(
        builder: (context, restaurantProvider, child) {
          if (restaurantProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          final restaurants = restaurantProvider.getFilteredRestaurants();
          final categories = restaurantProvider.allCategories;

          return Column(
            children: [
              // Поисковая строка
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SearchBarWidget(
                  onSearch: (query) {
                    restaurantProvider.setSearchQuery(query);
                  },
                ),
              ),

              // Фильтр категорий
              SizedBox(
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: CategoryFilterWidget(
                    categories: categories,
                    selectedCategory: restaurantProvider.selectedCategory,
                    onSelectCategory: (category) {
                      restaurantProvider.setSelectedCategory(category);
                    },
                  ),
                ),
              ),

              // Список ресторанов
              Expanded(
                child:
                    restaurants.isEmpty
                        ? const Center(
                          child: Text(
                            'Рестораны не найдены',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 16,
                            ),
                          ),
                        )
                        : ListView.builder(
                          padding: const EdgeInsets.all(16.0),
                          itemCount: restaurants.length,
                          itemBuilder: (context, index) {
                            final restaurant = restaurants[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: RestaurantCard(
                                restaurant: restaurant,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => RestaurantDetailScreen(
                                            restaurantId: restaurant.id,
                                          ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
              ),
            ],
          );
        },
      ),
    );
  }
}
