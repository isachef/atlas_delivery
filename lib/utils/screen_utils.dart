import 'package:flutter/material.dart';

class ScreenUtils {
  final BuildContext context;
  final double _designWidth = 375.0; // Базовая ширина для дизайна (iPhone X)
  final double _designHeight = 812.0; // Базовая высота для дизайна (iPhone X)

  ScreenUtils(this.context);

  /// Возвращает текущую ширину экрана
  double get screenWidth => MediaQuery.of(context).size.width;

  /// Возвращает текущую высоту экрана
  double get screenHeight => MediaQuery.of(context).size.height;

  /// Возвращает отношение текущей ширины к ширине дизайна
  double get widthRatio => screenWidth / _designWidth;

  /// Возвращает отношение текущей высоты к высоте дизайна
  double get heightRatio => screenHeight / _designHeight;

  /// Адаптирует размер по ширине экрана
  double getWidth(double width) => width * widthRatio;

  /// Адаптирует размер по высоте экрана
  double getHeight(double height) => height * heightRatio;

  /// Адаптирует размер по высоте и ширине экрана (берет среднее)
  double getSize(double size) => (getWidth(size) + getHeight(size)) / 2;

  /// Адаптирует размер шрифта
  double getFontSize(double fontSize) => getSize(fontSize);

  /// Адаптирует размер отступа
  double getPadding(double padding) => getSize(padding);

  /// Адаптирует радиус скругления
  double getRadius(double radius) => getSize(radius);

  /// Проверяет, является ли экран широким (планшет)
  bool get isTablet => screenWidth > 600;

  /// Проверяет, является ли экран компактным (маленький телефон)
  bool get isCompactPhone => screenWidth < 360;

  /// Возвращает соответствующий размер в зависимости от размера экрана
  double responsiveSize({
    required double small,
    required double medium,
    required double large,
  }) {
    if (isTablet) {
      return large;
    } else if (isCompactPhone) {
      return small;
    }
    return medium;
  }

  /// Возвращает безопасную область экрана
  EdgeInsets get padding => MediaQuery.of(context).padding;

  /// Возвращает размер иконки в зависимости от размера экрана
  double get iconSize => responsiveSize(small: 20, medium: 24, large: 28);

  /// Возвращает высоту AppBar в зависимости от размера экрана
  double get appBarHeight => responsiveSize(small: 56, medium: 60, large: 70);

  /// Возвращает горизонтальный отступ для страницы
  double get pageHorizontalPadding =>
      responsiveSize(small: 16, medium: 20, large: 24);

  /// Получить отступ по ширине и высоте
  EdgeInsets symmetricPadding({double horizontal = 0, double vertical = 0}) {
    return EdgeInsets.symmetric(
      horizontal: getPadding(horizontal),
      vertical: getPadding(vertical),
    );
  }

  /// Получить отступ со всех сторон
  EdgeInsets allPadding(double value) {
    return EdgeInsets.all(getPadding(value));
  }
}
