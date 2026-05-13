import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../models/restaurant.dart';
import '../providers/user_provider.dart';
import '../constants/app_colors.dart';

class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;
  final VoidCallback onTap;

  const RestaurantCard({
    Key? key,
    required this.restaurant,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Изображение ресторана
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  child:
                      restaurant.imageUrl.startsWith('assets/')
                          ? Image.asset(
                            restaurant.imageUrl,
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                          : Image.network(
                            restaurant.imageUrl,
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 150,
                                width: double.infinity,
                                color: AppColors.background,
                                child: const Icon(
                                  Icons.restaurant,
                                  size: 50,
                                  color: AppColors.primary,
                                ),
                              );
                            },
                          ),
                ),
                // Кнопка добавления в избранное
                Positioned(
                  top: 8,
                  right: 8,
                  child: Consumer<UserProvider>(
                    builder: (context, userProvider, child) {
                      final isFavorite = userProvider.isRestaurantFavorite(
                        restaurant.id.toString(),
                      );
                      return GestureDetector(
                        onTap: () {
                          userProvider.toggleFavoriteRestaurant(
                            restaurant.id.toString(),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color:
                                isFavorite
                                    ? AppColors.accent
                                    : AppColors.textLight,
                            size: 22,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            // Информация о ресторане
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Название ресторана
                  Text(
                    restaurant.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Категории
                  Text(
                    restaurant.categories.join(' • '),
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Рейтинг, время доставки, мин. заказ
                  Row(
                    children: [
                      // Рейтинг
                      RatingBar.builder(
                        initialRating: restaurant.rating,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: 16,
                        ignoreGestures: true,
                        itemBuilder:
                            (context, _) =>
                                const Icon(Icons.star, color: Colors.amber),
                        onRatingUpdate: (_) {},
                      ),
                      const SizedBox(width: 4),
                      Text(
                        restaurant.rating.toString(),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Время доставки
                      const Icon(
                        Icons.access_time,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${restaurant.deliveryTimeMinutes} мин',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Мин. заказ
                      const Icon(
                        Icons.shopping_bag,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'от ${restaurant.minOrder.toStringAsFixed(0)} ₽',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Стоимость доставки
                  Text(
                    'Доставка: ${restaurant.deliveryFee.toStringAsFixed(0)} ₽',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
