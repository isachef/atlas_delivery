import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/order_provider.dart';
import '../constants/app_colors.dart';
import '../models/order.dart';

class OrderSuccessScreen extends StatelessWidget {
  final String orderId;

  const OrderSuccessScreen({Key? key, required this.orderId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Заказ оформлен'),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Consumer<OrderProvider>(
        builder: (context, orderProvider, child) {
          if (orderProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          final order = orderProvider.orders.firstWhere(
            (order) => order.id == orderId,
            orElse:
                () => Order(
                  id: 'not_found',
                  restaurantId: 0,
                  restaurantName: 'Не найдено',
                  items: [],
                  subtotal: 0,
                  deliveryFee: 0,
                  total: 0,
                  status: OrderStatus.pending,
                  createdAt: DateTime.now(),
                  deliveryAddress: Address(
                    id: '',
                    street: '',
                    city: '',
                    postalCode: '',
                    country: '',
                    label: '',
                    latitude: 0,
                    longitude: 0,
                  ),
                  paymentMethod: PaymentMethod(
                    id: '',
                    name: '',
                    icon: '',
                    lastFourDigits: '',
                  ),
                ),
          );

          // Если заказ не найден
          if (order.id == 'not_found') {
            return const Center(child: Text('Заказ не найден'));
          }

          // Отображаем информацию о статусе заказа
          final statusText = _getStatusText(order.status);
          final statusIcon = _getStatusIcon(order.status);
          final statusColor = _getStatusColor(order.status);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                // Иконка успеха
                Icon(Icons.check_circle, size: 100, color: AppColors.success),
                const SizedBox(height: 24),

                // Заголовок
                const Text(
                  'Спасибо за заказ!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),

                // Номер заказа
                Text(
                  'Номер заказа: #${order.id}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Статус заказа
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Статус заказа',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(statusIcon, color: statusColor, size: 24),
                          const SizedBox(width: 8),
                          Text(
                            statusText,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: statusColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Информация о доставке
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Информация о доставке',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Ресторан
                      Row(
                        children: [
                          const Icon(
                            Icons.store,
                            color: AppColors.textSecondary,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Ресторан:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              order.restaurantName,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Адрес доставки
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: AppColors.textSecondary,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Адрес:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              order.deliveryAddress.fullAddress,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Сумма заказа
                      Row(
                        children: [
                          const Icon(
                            Icons.payments,
                            color: AppColors.textSecondary,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Сумма:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${order.total.toStringAsFixed(0)} ₽',
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Spacer(),

                // Кнопка возврата на главный экран
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/',
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Вернуться к ресторанам',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Методы для определения статуса заказа
  String _getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'Ожидает обработки';
      case OrderStatus.processing:
        return 'Готовится';
      case OrderStatus.delivering:
        return 'В пути';
      case OrderStatus.delivered:
        return 'Доставлен';
      case OrderStatus.cancelled:
        return 'Отменен';
      default:
        return 'Неизвестный статус';
    }
  }

  IconData _getStatusIcon(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Icons.access_time;
      case OrderStatus.processing:
        return Icons.restaurant;
      case OrderStatus.delivering:
        return Icons.delivery_dining;
      case OrderStatus.delivered:
        return Icons.check_circle;
      case OrderStatus.cancelled:
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return AppColors.warning;
      case OrderStatus.processing:
        return AppColors.info;
      case OrderStatus.delivering:
        return AppColors.primary;
      case OrderStatus.delivered:
        return AppColors.success;
      case OrderStatus.cancelled:
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }
}
