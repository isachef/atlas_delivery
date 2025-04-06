import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../providers/user_provider.dart';
import '../constants/app_colors.dart';
import '../constants/food_images.dart';
import '../utils/screen_utils.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final String restaurantName;

  const ProductCard({
    Key? key,
    required this.product,
    required this.restaurantName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final screenUtils = ScreenUtils(context);

    // Получаем изображение для продукта на основе его категории
    final productImage =
        product.imageUrl.contains('placeholder') || product.imageUrl.isEmpty
            ? FoodImages.getRandomForCategory(product.category)
            : product.imageUrl;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => _buildProductDetails(context),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Изображение продукта
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  child: Image.network(
                    productImage,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 120,
                        width: double.infinity,
                        color: AppColors.background,
                        child: const Icon(
                          Icons.fastfood,
                          size: 40,
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
                      final isFavorite = userProvider.isProductFavorite(
                        product.id.toString(),
                      );
                      return GestureDetector(
                        onTap: () {
                          userProvider.toggleFavoriteProduct(
                            product.id.toString(),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 2,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color:
                                isFavorite
                                    ? AppColors.accent
                                    : AppColors.textLight,
                            size: 18,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            // Информация о продукте
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Название продукта
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // Рейтинг
                    Row(
                      children: [
                        RatingBar.builder(
                          initialRating: product.rating,
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 12,
                          ignoreGestures: true,
                          itemBuilder:
                              (context, _) =>
                                  const Icon(Icons.star, color: Colors.amber),
                          onRatingUpdate: (_) {},
                        ),
                        const SizedBox(width: 4),
                        Text(
                          product.rating.toString(),
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Цена и кнопка добавления в корзину
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${product.price.toStringAsFixed(0)} ₽',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            cartProvider.addToCart(product, restaurantName);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Добавлено в корзину'),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductDetails(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final screenUtils = ScreenUtils(context);

    // Получаем изображение для продукта на основе его категории
    final productImage =
        product.imageUrl.contains('placeholder') || product.imageUrl.isEmpty
            ? FoodImages.getRandomForCategory(product.category)
            : product.imageUrl;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(screenUtils.getRadius(16)),
          topRight: Radius.circular(screenUtils.getRadius(16)),
        ),
      ),
      padding: EdgeInsets.all(screenUtils.getPadding(16)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Изображение продукта
          ClipRRect(
            borderRadius: BorderRadius.circular(screenUtils.getRadius(12)),
            child: Image.network(
              productImage,
              height: screenUtils.getHeight(200),
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: screenUtils.getHeight(200),
                  width: double.infinity,
                  color: AppColors.background,
                  child: Icon(
                    Icons.fastfood,
                    size: screenUtils.getSize(60),
                    color: AppColors.primary,
                  ),
                );
              },
            ),
          ),
          SizedBox(height: screenUtils.getHeight(16)),

          // Название продукта
          Text(
            product.name,
            style: TextStyle(
              fontSize: screenUtils.getFontSize(22),
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: screenUtils.getHeight(8)),

          // Рейтинг
          Row(
            children: [
              RatingBar.builder(
                initialRating: product.rating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: screenUtils.getSize(16),
                ignoreGestures: true,
                itemBuilder:
                    (context, _) => const Icon(Icons.star, color: Colors.amber),
                onRatingUpdate: (_) {},
              ),
              SizedBox(width: screenUtils.getWidth(8)),
              Text(
                product.rating.toString(),
                style: TextStyle(
                  fontSize: screenUtils.getFontSize(14),
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          SizedBox(height: screenUtils.getHeight(16)),

          // Описание продукта
          Text(
            'Описание',
            style: TextStyle(
              fontSize: screenUtils.getFontSize(18),
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: screenUtils.getHeight(8)),
          Text(
            product.description.isNotEmpty
                ? product.description
                : 'Нет описания',
            style: TextStyle(
              fontSize: screenUtils.getFontSize(16),
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: screenUtils.getHeight(24)),

          // Информация о калориях и весе
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildInfoItem(
                context,
                icon: Icons.local_fire_department,
                value: '${product.calories} ккал',
                label: 'Калории',
              ),
              _buildInfoItem(
                context,
                icon: Icons.scale,
                value: '${product.weight} г',
                label: 'Вес',
              ),
            ],
          ),
          SizedBox(height: screenUtils.getHeight(24)),

          // Кнопка добавления в корзину
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                cartProvider.addToCart(product, restaurantName);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${product.name} добавлен в корзину'),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
              icon: const Icon(Icons.shopping_cart),
              label: Text(
                'Добавить за ${product.price.toStringAsFixed(0)} ₽',
                style: TextStyle(
                  fontSize: screenUtils.getFontSize(16),
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  vertical: screenUtils.getPadding(12),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(screenUtils.getRadius(8)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(
    BuildContext context, {
    required IconData icon,
    required String value,
    required String label,
  }) {
    final screenUtils = ScreenUtils(context);

    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: screenUtils.getSize(24)),
        SizedBox(height: screenUtils.getHeight(4)),
        Text(
          value,
          style: TextStyle(
            fontSize: screenUtils.getFontSize(14),
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: screenUtils.getFontSize(12),
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
