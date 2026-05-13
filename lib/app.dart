import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'constants/app_colors.dart';
import 'providers/cart_provider.dart';
import 'providers/order_provider.dart';
import 'providers/restaurant_provider.dart';
import 'providers/user_provider.dart';
import 'providers/voice_assistant_provider.dart';
import 'screens/cart_screen.dart';
import 'screens/checkout_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/order_success_screen.dart';
import 'screens/profile_screen.dart';
import 'widgets/connection_status.dart';
import 'widgets/floating_assistant_button.dart';

class DeliveryApp extends StatelessWidget {
  const DeliveryApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RestaurantProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => VoiceAssistantProvider()),
      ],
      child: MaterialApp(
        title: 'Atlas Доставка',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: AppColors.primary,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            primary: AppColors.primary,
            secondary: AppColors.accent,
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            titleTextStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            elevation: 4,
            centerTitle: false,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
          ),
          scaffoldBackgroundColor: AppColors.background,
          dividerTheme: const DividerThemeData(color: AppColors.divider, thickness: 1, space: 1),
          cardTheme: CardThemeData(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            color: AppColors.card,
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.divider),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.divider),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          tabBarTheme: const TabBarThemeData(
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.primary,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        home: ConnectionStatus(
          child: Stack(
            children: [
              Navigator(
                onGenerateRoute: (settings) {
                  Widget page;
                  switch (settings.name) {
                    case '/':
                      page = const HomeScreen();
                      break;
                    case '/cart':
                      page = const CartScreen();
                      break;
                    case '/checkout':
                      page = const CheckoutScreen();
                      break;
                    case '/profile':
                      page = const ProfileScreen();
                      break;
                    case '/login':
                      page = const LoginScreen();
                      break;
                    case '/order-success':
                      final String orderId = settings.arguments as String;
                      page = OrderSuccessScreen(orderId: orderId);
                      break;
                    default:
                      page = Scaffold(
                        appBar: AppBar(title: const Text('Страница не найдена')),
                        body: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.error_outline, size: 80, color: AppColors.error),
                              const SizedBox(height: 16),
                              const Text(
                                'Страница не найдена',
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Маршрут ${settings.name} не существует',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pushReplacementNamed(context, '/');
                                },
                                child: const Text('На главную'),
                              ),
                            ],
                          ),
                        ),
                      );
                  }
                  return MaterialPageRoute(builder: (_) => page);
                },
                initialRoute: '/',
              ),
              const FloatingAssistantButton(),
            ],
          ),
        ),
      ),
    );
  }
}
