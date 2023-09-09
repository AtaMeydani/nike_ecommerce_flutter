import 'package:flutter/material.dart';
import 'package:nike_ecommerce_flutter/theme.dart';
import 'package:nike_ecommerce_flutter/ui/home/home.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    const defaultTextStyle = TextStyle(
      fontFamily: 'IRAN',
      color: LightThemeColors.primaryTextColor,
    );
    return MaterialApp(
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: LightThemeColors.primaryColor,
          secondary: LightThemeColors.secondaryColor,
          onSecondary: Colors.white,
        ),
        textTheme: TextTheme(
          titleMedium: defaultTextStyle.apply(color: LightThemeColors.secondaryTextColor),
          labelLarge: defaultTextStyle,
          bodyMedium: defaultTextStyle,
          titleLarge: defaultTextStyle.copyWith(fontWeight: FontWeight.bold),
          bodySmall: defaultTextStyle.apply(color: LightThemeColors.secondaryTextColor),
        ),
      ),
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: HomeScreen(),
      ),
    );
  }
}
