import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../models/restaurant.dart';
import '../models/product.dart';
import '../providers/restaurant_provider.dart';
import '../providers/cart_provider.dart';
import '../constants/app_colors.dart';
import '../widgets/product_card.dart';
import '../utils/screen_utils.dart';

class RestaurantDetailScreen extends StatefulWidget {
  final int restaurantId;

  const RestaurantDetailScreen({Key? key, required this.restaurantId})
    : super(key: key);

  @override
  State<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedCategory = 'Все';

  @override
  void initState() {
    super.initState();
    _initTabController();
  }

  void _initTabController() {
    final restaurantProvider = Provider.of<RestaurantProvider>(
      context,
      listen: false,
    );
    final categories = restaurantProvider.getProductCategories(
      widget.restaurantId,
    );
    _tabController = TabController(length: categories.length, vsync: this);

    if (categories.isNotEmpty) {
      _selectedCategory = categories.first;
    }

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _selectedCategory = categories[_tabController.index];
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenUtils = ScreenUtils(context);

    return Consumer<RestaurantProvider>(
      builder: (context, restaurantProvider, child) {
        final restaurant = restaurantProvider.getRestaurantById(
          widget.restaurantId,
        );

        if (restaurant == null) {
          return const Scaffold(
            body: Center(child: Text('Ресторан не найден')),
          );
        }

        final productCategories = restaurantProvider.getProductCategories(
          widget.restaurantId,
        );
        final products = restaurantProvider.getProductsByCategory(
          widget.restaurantId,
          _selectedCategory,
        );

        return Scaffold(
          backgroundColor: AppColors.background,
          body: CustomScrollView(
            slivers: [
              // AppBar с изображением ресторана
              SliverAppBar(
                expandedHeight: 250.0,
                pinned: true,
                backgroundColor: AppColors.primary,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      restaurant.imageUrl.startsWith('assets/')
                          ? Image.asset(restaurant.imageUrl, fit: BoxFit.cover)
                          : Image.network(
                            restaurant.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: AppColors.primary.withOpacity(0.8),
                                child: const Center(
                                  child: Icon(
                                    Icons.restaurant,
                                    size: 80,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            },
                          ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.7),
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  title: Text(
                    restaurant.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                ),
                actions: [
                  // Кнопка корзины
                  Consumer<CartProvider>(
                    builder: (context, cartProvider, child) {
                      final itemCount = cartProvider.itemCount;
                      return Stack(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.shopping_cart),
                            onPressed: () {
                              Navigator.pushNamed(context, '/cart');
                            },
                          ),
                          if (itemCount > 0)
                            Positioned(
                              right: 8,
                              top: 8,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: AppColors.accent,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 16,
                                  minHeight: 16,
                                ),
                                child: Text(
                                  itemCount.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ],
              ),

              // Информация о ресторане
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Рейтинг и время доставки
                      Row(
                        children: [
                          RatingBar.builder(
                            initialRating: restaurant.rating,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 20,
                            ignoreGestures: true,
                            itemBuilder:
                                (context, _) =>
                                    const Icon(Icons.star, color: Colors.amber),
                            onRatingUpdate: (_) {},
                          ),
                          const SizedBox(width: 8),
                          Text(
                            restaurant.rating.toString(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Icon(
                            Icons.access_time,
                            size: 18,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${restaurant.deliveryTimeMinutes} мин',
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Описание
                      Text(
                        restaurant.description,
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Адрес
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 18,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              restaurant.address,
                              style: const TextStyle(
                                fontSize: 16,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Минимальный заказ и стоимость доставки
                      Row(
                        children: [
                          const Icon(
                            Icons.shopping_bag,
                            size: 18,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Мин. заказ: ${restaurant.minOrder.toStringAsFixed(0)} ₽',
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Icon(
                            Icons.delivery_dining,
                            size: 18,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Доставка: ${restaurant.deliveryFee.toStringAsFixed(0)} ₽',
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Вкладки категорий
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    labelColor: AppColors.primary,
                    unselectedLabelColor: AppColors.textSecondary,
                    indicatorColor: AppColors.primary,
                    padding: EdgeInsets.symmetric(
                      horizontal: screenUtils.getPadding(8),
                    ),
                    tabs:
                        productCategories
                            .map((category) => Tab(text: category))
                            .toList(),
                  ),
                  const Color(0xFFFFFFFF),
                ),
              ),

              // Список продуктов
              SliverPadding(
                padding: const EdgeInsets.all(16.0),
                sliver:
                    products.isEmpty
                        ? SliverToBoxAdapter(
                          child: Center(
                            child: Text(
                              'Нет доступных продуктов в этой категории',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        )
                        : SliverGrid(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.75,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                              ),
                          delegate: SliverChildBuilderDelegate((
                            context,
                            index,
                          ) {
                            final product = products[index];
                            return ProductCard(
                              product: product,
                              restaurantName: restaurant.name,
                            );
                          }, childCount: products.length),
                        ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Класс для создания закрепленного заголовка с категориями
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;
  final Color _backgroundColor;

  _SliverAppBarDelegate(this._tabBar, this._backgroundColor);

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(color: _backgroundColor, child: _tabBar);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
