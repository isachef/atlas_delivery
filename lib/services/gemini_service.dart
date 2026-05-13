import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  static const String _apiKey = 'AIzaSyDapLzIiKhigjWMRN3Sw5g7b_8TePc90AA';
  late final GenerativeModel _model;

  GeminiService() {
    _model = GenerativeModel(apiKey: _apiKey, model: 'gemini-1.5-flash-latest');
  }

  Future<String> sendMessage(String message) async {
    try {
      final prompt = Content.text(message);
      final response = await _model.generateContent([prompt]);
      final responseText = response.text;
      return responseText ?? 'Извините, не удалось получить ответ';
    } catch (e) {
      return 'Произошла ошибка: $e';
    }
  }

  // Метод для расчета базовой платы за доставку
  Future<double> calculateBaseFare({
    required double distance,
    required double weight,
    required String deliveryType,
  }) async {
    final prompt = '''
    Рассчитай базовую плату за доставку со следующими параметрами:
    - Расстояние: $distance км
    - Вес: $weight кг
    - Тип доставки: $deliveryType
    
    Учти, что базовая плата должна покрывать:
    1. Минимальные расходы на топливо
    2. Износ транспорта
    3. Время курьера
    4. Тип доставки (срочная/обычная)
    
    Верни только число без пояснений.
    ''';

    final response = await sendMessage(prompt);
    return double.tryParse(response) ?? 0.0;
  }
}
