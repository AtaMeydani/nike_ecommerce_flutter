import 'package:flutter/material.dart';
import 'package:nike_ecommerce_flutter/ui/auth/login.dart';
import 'package:nike_ecommerce_flutter/ui/main.dart';
import 'package:nike_ecommerce_flutter/ui/theme/theme_controller.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeController().getTheme(),
      home: const Directionality(
        textDirection: TextDirection.rtl,
        child: LoginScreen(),
      ),
    );
  }
}
