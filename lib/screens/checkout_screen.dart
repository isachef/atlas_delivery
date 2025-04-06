import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/user_provider.dart';
import '../providers/order_provider.dart';
import '../constants/app_colors.dart';
import '../models/order.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _currentStep = 0;
  final _noteController = TextEditingController();
  String _selectedAddressId = '';
  String _selectedPaymentMethodId = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Инициализируем выбранные значения
    Future.microtask(() {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      if (userProvider.addresses.isNotEmpty) {
        setState(() {
          _selectedAddressId = userProvider.addresses.first.id;
        });
      }
      if (userProvider.paymentMethods.isNotEmpty) {
        setState(() {
          _selectedPaymentMethodId = userProvider.paymentMethods.first.id;
        });
      }
    });
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _placeOrder() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final cartProvider = Provider.of<CartProvider>(context, listen: false);
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final orderProvider = Provider.of<OrderProvider>(context, listen: false);

      // Получаем выбранный адрес и способ оплаты
      final selectedAddress = userProvider.addresses.firstWhere(
        (addr) => addr.id == _selectedAddressId,
      );

      final selectedPaymentMethod = userProvider.paymentMethods.firstWhere(
        (method) => method.id == _selectedPaymentMethodId,
      );

      // Создаем заказ
      final order = await orderProvider.placeOrder(
        cart: cartProvider.cart,
        deliveryAddress: selectedAddress,
        paymentMethod: selectedPaymentMethod,
        note: _noteController.text.isNotEmpty ? _noteController.text : null,
      );

      // Очищаем корзину
      await cartProvider.clearCart();

      // Имитируем прогресс выполнения заказа (для демо)
      // В реальном приложении это будет происходить через push-уведомления
      Future.delayed(const Duration(seconds: 1), () {
        orderProvider.simulateOrderProgress();
      });

      // Переходим на экран успешного оформления
      if (mounted) {
        Navigator.pushReplacementNamed(
          context,
          '/order-success',
          arguments: order.id,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка при оформлении заказа: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Оформление заказа'),
        elevation: 0,
      ),
      body: Consumer3<CartProvider, UserProvider, OrderProvider>(
        builder: (context, cartProvider, userProvider, orderProvider, child) {
          if (cartProvider.isLoading ||
              userProvider.isLoading ||
              orderProvider.isLoading ||
              _isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          final cart = cartProvider.cart;
          final addresses = userProvider.addresses;
          final paymentMethods = userProvider.paymentMethods;

          return Stepper(
            currentStep: _currentStep,
            onStepContinue: () {
              if (_currentStep < 2) {
                setState(() {
                  _currentStep += 1;
                });
              } else {
                _placeOrder();
              }
            },
            onStepCancel: () {
              if (_currentStep > 0) {
                setState(() {
                  _currentStep -= 1;
                });
              } else {
                Navigator.pop(context);
              }
            },
            controlsBuilder: (context, details) {
              return Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Row(
                  children: [
                    ElevatedButton(
                      onPressed: details.onStepContinue,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                      ),
                      child: Text(_currentStep == 2 ? 'Подтвердить' : 'Далее'),
                    ),
                    const SizedBox(width: 12),
                    TextButton(
                      onPressed: details.onStepCancel,
                      child: Text(_currentStep == 0 ? 'Отмена' : 'Назад'),
                    ),
                  ],
                ),
              );
            },
            steps: [
              // Шаг 1: Адрес доставки
              Step(
                title: const Text('Адрес доставки'),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...addresses.map(
                      (address) => RadioListTile<String>(
                        title: Text(address.label),
                        subtitle: Text(address.fullAddress),
                        value: address.id,
                        groupValue: _selectedAddressId,
                        onChanged: (value) {
                          setState(() {
                            _selectedAddressId = value!;
                          });
                        },
                      ),
                    ),
                    if (addresses.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'У вас нет сохраненных адресов. Пожалуйста, добавьте адрес для доставки.',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ),
                    TextButton.icon(
                      onPressed: () {
                        // В реальном приложении здесь будет переход на экран добавления адреса
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Функция будет доступна в полной версии',
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Добавить новый адрес'),
                    ),
                  ],
                ),
                isActive: _currentStep >= 0,
                state:
                    _currentStep > 0 ? StepState.complete : StepState.indexed,
              ),

              // Шаг 2: Способ оплаты
              Step(
                title: const Text('Способ оплаты'),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...paymentMethods.map(
                      (method) => RadioListTile<String>(
                        title: Text(
                          '${method.name} **** ${method.lastFourDigits}',
                        ),
                        secondary: Icon(
                          method.name == 'Visa'
                              ? Icons.credit_card
                              : Icons.payment,
                          color: AppColors.primary,
                        ),
                        value: method.id,
                        groupValue: _selectedPaymentMethodId,
                        onChanged: (value) {
                          setState(() {
                            _selectedPaymentMethodId = value!;
                          });
                        },
                      ),
                    ),
                    if (paymentMethods.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'У вас нет сохраненных способов оплаты. Пожалуйста, добавьте способ оплаты.',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ),
                    TextButton.icon(
                      onPressed: () {
                        // В реальном приложении здесь будет переход на экран добавления карты
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Функция будет доступна в полной версии',
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Добавить новую карту'),
                    ),
                  ],
                ),
                isActive: _currentStep >= 1,
                state:
                    _currentStep > 1 ? StepState.complete : StepState.indexed,
              ),

              // Шаг 3: Подтверждение заказа
              Step(
                title: const Text('Подтверждение заказа'),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Сводка заказа
                    const Text(
                      'Ваш заказ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Список товаров
                    ...cart.items.map(
                      (item) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          children: [
                            Text(
                              '${item.quantity}x',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(child: Text(item.productName)),
                            Text(
                              '${(item.price * item.quantity).toStringAsFixed(0)} ₽',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(),

                    // Стоимость
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Сумма заказа:'),
                        Text('${cart.subtotal.toStringAsFixed(0)} ₽'),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Доставка:'),
                        Text('${cart.deliveryFee.toStringAsFixed(0)} ₽'),
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Итого:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          '${cart.total.toStringAsFixed(0)} ₽',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Комментарий к заказу
                    const Text(
                      'Комментарий к заказу',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _noteController,
                      decoration: const InputDecoration(
                        hintText:
                            'Например: звонить в дверь / подъезд 2, этаж 4',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2,
                    ),
                  ],
                ),
                isActive: _currentStep >= 2,
                state: StepState.indexed,
              ),
            ],
          );
        },
      ),
    );
  }
}
