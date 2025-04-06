import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../constants/app_colors.dart';
import '../utils/screen_utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      final result = await userProvider.login(
        _emailController.text,
        _passwordController.text,
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        if (result) {
          // Если успешно авторизован, возвращаемся на предыдущий экран
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Неверный email или пароль'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenUtils = ScreenUtils(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Вход'),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(screenUtils.getPadding(16)),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: screenUtils.getHeight(30)),

                  // Логотип или иконка
                  Icon(
                    Icons.account_circle,
                    size: screenUtils.getHeight(100),
                    color: AppColors.primary,
                  ),

                  SizedBox(height: screenUtils.getHeight(30)),

                  // Заголовок
                  Text(
                    'Вход в аккаунт',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: screenUtils.getFontSize(24),
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  SizedBox(height: screenUtils.getHeight(16)),

                  // Форма входа
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Пожалуйста, введите email';
                      }
                      if (!RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      ).hasMatch(value)) {
                        return 'Введите корректный email';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: screenUtils.getHeight(16)),

                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Пароль',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: _togglePasswordVisibility,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Пожалуйста, введите пароль';
                      }
                      if (value.length < 6) {
                        return 'Пароль должен содержать минимум 6 символов';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: screenUtils.getHeight(8)),

                  // Кнопка "Забыли пароль"
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Функция восстановления пароля пока недоступна',
                            ),
                          ),
                        );
                      },
                      child: Text(
                        'Забыли пароль?',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: screenUtils.getFontSize(14),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: screenUtils.getHeight(24)),

                  // Кнопка входа
                  SizedBox(
                    height: screenUtils.getHeight(50),
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _login,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            screenUtils.getRadius(8),
                          ),
                        ),
                      ),
                      child:
                          _isLoading
                              ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                              : Text(
                                'Войти',
                                style: TextStyle(
                                  fontSize: screenUtils.getFontSize(16),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                    ),
                  ),

                  SizedBox(height: screenUtils.getHeight(40)),

                  // Демо-данные
                  Container(
                    padding: EdgeInsets.all(screenUtils.getPadding(16)),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(
                        screenUtils.getRadius(8),
                      ),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Данные для демо-входа:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: screenUtils.getFontSize(14),
                          ),
                        ),
                        SizedBox(height: screenUtils.getHeight(8)),
                        Text(
                          'Email: demo@example.com',
                          style: TextStyle(
                            fontSize: screenUtils.getFontSize(14),
                          ),
                        ),
                        Text(
                          'Пароль: password',
                          style: TextStyle(
                            fontSize: screenUtils.getFontSize(14),
                          ),
                        ),
                        SizedBox(height: screenUtils.getHeight(8)),
                        TextButton(
                          onPressed: () {
                            _emailController.text = 'demo@example.com';
                            _passwordController.text = 'password';
                          },
                          child: const Text('Использовать демо-данные'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
