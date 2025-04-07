import 'package:flutter/material.dart';
import '../services/voice_assistant_service.dart';

class VoiceAssistantProvider extends ChangeNotifier {
  final VoiceAssistantService _service = VoiceAssistantService();
  String _userInput = '';
  String _assistantResponse = '';
  bool _isProcessing = false;
  bool _isVisible = false;
  bool _isListening = false;
  bool _isSpeechAvailable = false;
  String _recognitionStatus = '';
  String _activeLocale = 'en_US';

  String get userInput => _userInput;
  String get assistantResponse => _assistantResponse;
  bool get isProcessing => _isProcessing;
  bool get isVisible => _isVisible;
  bool get isListening => _isListening;
  bool get isSpeechAvailable => _isSpeechAvailable;
  String get recognitionStatus => _recognitionStatus;
  String get activeLocale => _activeLocale;

  void toggleVisibility() {
    _isVisible = !_isVisible;
    notifyListeners();
  }

  Future<void> initialize() async {
    await _service.initialize();

    // Инициализируем распознавание речи
    _isSpeechAvailable = await _service.initializeSpeech();
    _activeLocale = _service.activeLocaleId;

    debugPrint('Распознавание речи доступно: $_isSpeechAvailable');
    debugPrint('Активная локаль: $_activeLocale');

    if (_isSpeechAvailable) {
      _recognitionStatus = 'Голосовой ввод доступен (локаль: $_activeLocale)';
    } else {
      _recognitionStatus =
          'Голосовой ввод недоступен. Используйте текстовый ввод.';
    }

    notifyListeners();
  }

  void setUserInput(String text) {
    _userInput = text;
    notifyListeners();
  }

  Future<void> processWelcomeMessage() async {
    String welcomeMessage = 'Привет! Я ваш ИИ помощник для заказа еды.';

    if (_isSpeechAvailable) {
      welcomeMessage += ' Нажмите на микрофон и скажите, что хотите заказать.';
      if (_activeLocale.startsWith('en')) {
        welcomeMessage += ' Для распознавания доступен только английский язык.';
      }
    } else {
      welcomeMessage += ' Напишите, что хотите заказать.';
    }

    _assistantResponse = welcomeMessage;
    await _service.speak(_assistantResponse);
    notifyListeners();
  }

  Future<void> startListening() async {
    if (_isListening) return;

    _isListening = true;
    _recognitionStatus = 'Слушаю...';
    notifyListeners();

    debugPrint('Запускаем прослушивание');

    try {
      await _service.startListening((recognizedText) {
        debugPrint('Получен текст: $recognizedText');

        if (recognizedText.isNotEmpty) {
          if (recognizedText.startsWith('ERROR:')) {
            _recognitionStatus = 'Ошибка: невозможно использовать микрофон';
            _isListening = false;
          } else {
            _userInput = recognizedText;
            _recognitionStatus = 'Распознано: $recognizedText';
          }
        } else {
          _recognitionStatus = 'Не удалось распознать речь';
        }

        notifyListeners();
      });

      // Если сервис не начал прослушивание, сбрасываем состояние
      if (!_service.isListening) {
        _isListening = false;
        _recognitionStatus =
            'Нажмите на кнопку еще раз, чтобы начать прослушивание';
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Ошибка при запуске прослушивания: $e');
      _isListening = false;
      _recognitionStatus = 'Ошибка при активации микрофона';
      notifyListeners();
    }
  }

  Future<void> stopListening() async {
    if (!_isListening) return;

    await _service.stopListening();
    _isListening = false;
    _recognitionStatus = '';
    notifyListeners();

    if (_userInput.isNotEmpty) {
      await processInput();
    }
  }

  Future<void> processInput() async {
    if (_userInput.isEmpty) return;

    _isProcessing = true;
    notifyListeners();

    debugPrint('Обработка ввода: $_userInput');

    // Имитация обработки запроса
    await Future.delayed(const Duration(seconds: 1));

    final lowerInput = _userInput.toLowerCase();

    // Простая логика для отображения работы помощника с поддержкой английского
    if (lowerInput.contains('пицц') || lowerInput.contains('pizza')) {
      _assistantResponse =
          'Добавляю пиццу в корзину. Какую пиццу вы хотите заказать?';
    } else if (lowerInput.contains('маргарит') ||
        lowerInput.contains('margarita')) {
      _assistantResponse =
          'Добавляю пиццу Маргарита в корзину. Что-нибудь еще?';
    } else if (lowerInput.contains('pepperoni') ||
        lowerInput.contains('пеперони')) {
      _assistantResponse =
          'Добавляю пиццу Пепперони в корзину. Что-нибудь еще?';
    } else if (lowerInput.contains('суши') ||
        lowerInput.contains('sushi') ||
        lowerInput.contains('роллы') ||
        lowerInput.contains('rolls')) {
      _assistantResponse =
          'Добавляю суши в корзину. Какие именно роллы вы предпочитаете?';
    } else if (lowerInput.contains('доставк') ||
        lowerInput.contains('delivery')) {
      _assistantResponse =
          'Ваш заказ будет доставлен в течение 40 минут. Подтверждаете заказ?';
    } else if (lowerInput.contains('да') ||
        lowerInput.contains('yes') ||
        lowerInput.contains('подтверж') ||
        lowerInput.contains('confirm')) {
      _assistantResponse = 'Отлично! Ваш заказ оформлен. Ожидайте доставку.';
    } else {
      _assistantResponse =
          'Я могу помочь вам с заказом еды. Что вы хотите заказать?';
    }

    debugPrint('Ответ ассистента: $_assistantResponse');
    await _service.speak(_assistantResponse);

    _isProcessing = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _service.dispose();
    super.dispose();
  }
}
