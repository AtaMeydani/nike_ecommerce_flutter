import 'package:flutter/material.dart';
import 'package:nike_ecommerce_flutter/ui/auth/login.dart';
import 'package:nike_ecommerce_flutter/ui/auth/text_field.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/nike_logo.png',
              height: 120,
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              'خوش آمدید',
              style: TextStyle(
                fontSize: 22,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              'لطفا وارد حساب کاربری خود شوید',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            const EmailTextField(),
            const SizedBox(
              height: 16,
            ),
            const PasswordTextField(),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text(
                'ثبت نام',
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) {
                      return const LoginScreen();
                    },
                  ),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'حساب کاربری دارید؟',
                    style: TextStyle(),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    'ورود',
                    style: TextStyle(
                      color: themeData.colorScheme.primary,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    ;
  }
}
