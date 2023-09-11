import 'package:flutter/material.dart';
import 'package:nike_ecommerce_flutter/data/repo/auth_repository.dart';
import 'package:nike_ecommerce_flutter/ui/auth/register.dart';
import 'package:nike_ecommerce_flutter/ui/auth/text_field.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController(text: 'test@gmail.com');
  final TextEditingController passwordController = TextEditingController(text: '123456');
  LoginScreen({super.key});

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
            EmailTextField(
              controller: usernameController,
            ),
            const SizedBox(
              height: 16,
            ),
            PasswordTextField(
              controller: passwordController,
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton(
              onPressed: () {
                authRepository.login(
                  username: usernameController.text,
                  password: passwordController.text,
                );
              },
              child: const Text(
                'ورود',
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
                      return RegisterScreen();
                    },
                  ),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'حساب کاربری ندارید؟',
                    style: TextStyle(),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    'ثبت نام',
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
  }
}
