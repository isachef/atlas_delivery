import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../providers/order_provider.dart';
import '../constants/app_colors.dart';
import '../models/order.dart';
import '../utils/screen_utils.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Загружаем данные при инициализации экрана
    Future.microtask(() {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);

      userProvider.loadUser();
      orderProvider.loadOrders();
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

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Профиль'),
        elevation: 0,
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          if (userProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          // Если пользователь не авторизован, показываем экран входа
          if (!userProvider.isLoggedIn) {
            return _buildLoginView();
          }

          final user = userProvider.user!;

          return Column(
            children: [
              // Верхняя часть профиля с информацией о пользователе
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Аватар пользователя
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      backgroundImage:
                          user.photoUrl != null
                              ? NetworkImage(user.photoUrl!)
                              : null,
                      child:
                          user.photoUrl == null
                              ? Text(
                                user.name.substring(0, 1).toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 40,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                              : null,
                    ),
                    const SizedBox(height: 16),

                    // Имя пользователя
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Email пользователя
                    Text(
                      user.email,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Телефон пользователя
                    Text(
                      user.phoneNumber,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),

              // TabBar для разных секций профиля
              TabBar(
                controller: _tabController,
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.textSecondary,
                indicatorColor: AppColors.primary,
                tabs: const [
                  Tab(text: 'Заказы'),
                  Tab(text: 'Адреса'),
                  Tab(text: 'Способы оплаты'),
                ],
              ),

              // TabBarView для содержимого вкладок
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Вкладка с заказами
                    _buildOrdersTab(),

                    // Вкладка с адресами
                    _buildAddressesTab(userProvider),

                    // Вкладка со способами оплаты
                    _buildPaymentMethodsTab(userProvider),
                  ],
                ),
              ),

              // Кнопка выхода из аккаунта
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            title: const Text('Выйти из аккаунта?'),
                            content: const Text(
                              'Вы уверены, что хотите выйти из аккаунта?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Отмена'),
                              ),
                              TextButton(
                                onPressed: () {
                                  userProvider.logout();
                                  Navigator.pop(context);
                                },
                                child: const Text('Выйти'),
                              ),
                            ],
                          ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Выйти из аккаунта',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Виджет для отображения экрана входа
  Widget _buildLoginView() {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Заголовок
          const Text(
            'Вход в аккаунт',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          // Поле для email
          TextField(
            controller: emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.email),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),

          // Поле для пароля
          TextField(
            controller: passwordController,
            decoration: const InputDecoration(
              labelText: 'Пароль',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.lock),
            ),
            obscureText: true,
          ),
          const SizedBox(height: 24),

          // Кнопка входа
          ElevatedButton(
            onPressed: () async {
              final userProvider = Provider.of<UserProvider>(
                context,
                listen: false,
              );

              // Для демо используем фиксированные данные
              final result = await userProvider.login(
                emailController.text.isNotEmpty
                    ? emailController.text
                    : 'demo@example.com',
                passwordController.text.isNotEmpty
                    ? passwordController.text
                    : 'password',
              );

              if (!result && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Неверный email или пароль'),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text(
              'Войти',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),

          // Подсказка для демо
          const Text(
            'Для демо используйте: user@example.com / password',
            style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Виджет для отображения вкладки с заказами
  Widget _buildOrdersTab() {
    return Consumer<OrderProvider>(
      builder: (context, orderProvider, child) {
        if (orderProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        final orders = orderProvider.orders;

        if (orders.isEmpty) {
          return const Center(
            child: Text(
              'У вас пока нет заказов',
              style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
            ),
          );
        }

        // Сортируем заказы по дате (новые сверху)
        final sortedOrders = List<Order>.from(orders)
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: sortedOrders.length,
          itemBuilder: (context, index) {
            final order = sortedOrders[index];
            final statusText = _getStatusText(order.status);
            final statusColor = _getStatusColor(order.status);

            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Шапка заказа
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Заказ #${order.id}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            statusText,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: statusColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Дата заказа
                    Text(
                      'от ${_formatDate(order.createdAt)}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const Divider(),

                    // Ресторан
                    Text(
                      'Ресторан: ${order.restaurantName}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Список товаров
                    if (order.items.length <= 3)
                      ...order.items.map(
                        (item) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Text(
                            '${item.quantity}x ${item.productName}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      )
                    else
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...order.items
                              .take(2)
                              .map(
                                (item) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 2,
                                  ),
                                  child: Text(
                                    '${item.quantity}x ${item.productName}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                              ),
                          Text(
                            'и еще ${order.items.length - 2} позиций',
                            style: const TextStyle(
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 8),

                    // Итоговая сумма
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Итого:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          '${order.total.toStringAsFixed(0)} ₽',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Виджет для отображения вкладки с адресами
  Widget _buildAddressesTab(UserProvider userProvider) {
    final addresses = userProvider.addresses;

    if (addresses.isEmpty) {
      return const Center(
        child: Text(
          'У вас пока нет сохраненных адресов',
          style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: addresses.length,
      itemBuilder: (context, index) {
        final address = addresses[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Название адреса
                Row(
                  children: [
                    const Icon(Icons.location_on, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text(
                      address.label,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Полный адрес
                Text(
                  address.fullAddress,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Виджет для отображения вкладки со способами оплаты
  Widget _buildPaymentMethodsTab(UserProvider userProvider) {
    final paymentMethods = userProvider.paymentMethods;

    if (paymentMethods.isEmpty) {
      return const Center(
        child: Text(
          'У вас пока нет сохраненных способов оплаты',
          style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: paymentMethods.length,
      itemBuilder: (context, index) {
        final method = paymentMethods[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Иконка карты
                Container(
                  width: 50,
                  height: 30,
                  decoration: BoxDecoration(
                    color: method.name == 'Visa' ? Colors.blue : Colors.red,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: Text(
                      method.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Информация о карте
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      method.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      '**** **** **** ${method.lastFourDigits}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Вспомогательные методы
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

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    return '$day.$month.$year $hour:$minute';
  }
}
