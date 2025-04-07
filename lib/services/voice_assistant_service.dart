import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

class VoiceAssistantService {
  final FlutterTts _flutterTts = FlutterTts();
  final SpeechToText _speechToText = SpeechToText();
  bool _isInitialized = false;
  bool _isSpeechInitialized = false;
  String _activeLocaleId = 'en_US'; // По умолчанию используем английский

  Future<bool> initialize() async {
    if (_isInitialized) return true;

    try {
      await _flutterTts.setLanguage('ru-RU');
      await _flutterTts.setSpeechRate(0.5);
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(1.0);
    } catch (e) {
      debugPrint('Ошибка при инициализации TTS: $e');
    }

    _isInitialized = true;
    return _isInitialized;
  }

  Future<bool> initializeSpeech() async {
    try {
      bool initialized = await _speechToText.initialize(
        onError: (error) {
          debugPrint('Ошибка инициализации речи: $error');
        },
        onStatus: (status) {
          debugPrint('Статус речи: $status');
        },
        debugLogging: true,
      );

      debugPrint('Инициализация речи: $initialized');
      _isSpeechInitialized = initialized;

      if (initialized) {
        // Получаем доступные локали
        try {
          final locales = await _speechToText.locales();
          debugPrint(
            'Доступные локали: ${locales.map((e) => '${e.localeId} (${e.name})').join(', ')}',
          );

          // Сначала ищем русскую локаль
          final russianLocale =
              locales
                  .where(
                    (locale) =>
                        locale.localeId.toLowerCase().startsWith('ru') ||
                        locale.name.toLowerCase().contains('русск'),
                  )
                  .toList();

          debugPrint(
            'Русские локали: ${russianLocale.map((e) => '${e.localeId} (${e.name})').join(', ')}',
          );

          // Устанавливаем активную локаль
          if (russianLocale.isNotEmpty) {
            _activeLocaleId = russianLocale.first.localeId;
            debugPrint('Выбрана русская локаль: $_activeLocaleId');
          } else if (locales.isNotEmpty) {
            // Если русской нет, берем первую доступную
            _activeLocaleId = locales.first.localeId;
            debugPrint('Выбрана доступная локаль: $_activeLocaleId');
          }
        } catch (e) {
          debugPrint('Ошибка при получении локалей: $e');
        }
      } else {
        debugPrint('Инициализация речи не удалась!');
      }

      return _isSpeechInitialized;
    } catch (e) {
      debugPrint('Ошибка при инициализации распознавания речи: $e');
      _isSpeechInitialized = false;
      return false;
    }
  }

  Future<void> startListening(Function(String) onRecognitionResult) async {
    debugPrint('Пытаемся начать прослушивание...');

    // Проверяем, инициализирован ли сервис
    if (!_isSpeechInitialized) {
      debugPrint('Сначала инициализируем сервис речи');
      _isSpeechInitialized = await initializeSpeech();

      if (!_isSpeechInitialized) {
        debugPrint('Сервис речи не инициализирован!');
        onRecognitionResult('ERROR: Сервис речи не доступен');
        return;
      }
    }

    try {
      debugPrint('Начинаем прослушивание с локалью: $_activeLocaleId');

      await _speechToText.listen(
        onResult: (SpeechRecognitionResult result) {
          debugPrint(
            'Распознанные слова: ${result.recognizedWords}, Финальный: ${result.finalResult}',
          );
          if (result.recognizedWords.isNotEmpty) {
            onRecognitionResult(result.recognizedWords);
          }
        },
        localeId: _activeLocaleId,
        listenMode: ListenMode.confirmation,
        pauseFor: const Duration(seconds: 3),
        cancelOnError: false,
      );

      debugPrint('Прослушивание запущено успешно');
    } catch (e) {
      debugPrint('Ошибка при запуске прослушивания: $e');
      onRecognitionResult('ERROR: $e');
    }
  }

  Future<void> stopListening() async {
    try {
      debugPrint('Остановка прослушивания');
      await _speechToText.stop();
      debugPrint('Прослушивание остановлено');
    } catch (e) {
      debugPrint('Ошибка при остановке прослушивания: $e');
    }
  }

  bool get isListening => _speechToText.isListening;

  bool get isAvailable => _isSpeechInitialized;

  String get activeLocaleId => _activeLocaleId;

  Future<void> speak(String text) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      await _flutterTts.speak(text);
    } catch (e) {
      debugPrint('Ошибка при озвучивании: $e');
    }
  }

  Future<void> stop() async {
    try {
      await _flutterTts.stop();
    } catch (e) {
      debugPrint('Ошибка при остановке озвучивания: $e');
    }
  }

  void dispose() {
    try {
      _speechToText.cancel();
      _flutterTts.stop();
    } catch (e) {
      debugPrint('Ошибка при освобождении ресурсов: $e');
    }
  }
}
