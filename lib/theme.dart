part of 'demo.dart';

class AppTheme {
  static ThemeData theme1 = ThemeData(
    colorScheme: ColorScheme.light(
        primary: Colors.white , // Основной цвет
        secondary: Colors.black, // Акцентный
      onSecondary: Colors.black,
        surface: Color(0xffece9e9),//вторичный
        onPrimary: Color(0xffece9e9),
      tertiary: Colors.deepPurple,
    ),
    scaffoldBackgroundColor: Color(0xFFF4F4FB),
  );

  static ThemeData theme2 = ThemeData(
    colorScheme: ColorScheme.dark(
      primary: Colors.black, // Основной цвет
      secondary:Colors.black, // Акцентный
      onSecondary: Colors.white,
      surface: Colors.grey, // Вторичный
      onPrimary: Colors.grey,
      tertiary: Colors.deepPurple,
    ),
    scaffoldBackgroundColor: Colors.grey,
  );
}

class ThemeNotifier with ChangeNotifier {
  ThemeData _currentTheme = AppTheme.theme1;

  ThemeData get currentTheme => _currentTheme;

  void toggleTheme() {
    _currentTheme = _currentTheme == AppTheme.theme1
        ? AppTheme.theme2
        : AppTheme.theme1;
    notifyListeners();
  }
}