import 'package:flutter/material.dart';
import 'package:nike_ecommerce_flutter/data/auth.dart';
import 'package:nike_ecommerce_flutter/data/repo/auth_repository.dart';
import 'package:nike_ecommerce_flutter/ui/auth/login/login.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('سبد خرید'),
      ),
      body: ValueListenableBuilder<AuthInfo?>(
        valueListenable: AuthRepository.authChangeNotifier,
        builder: (BuildContext context, authInfo, Widget? child) {
          bool isAuthenticated = authInfo?.accessToken != null;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(isAuthenticated ? 'خوش آمدید' : 'لطفا وارد حساب کاربری خود شوید'),
              if (!isAuthenticated)
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) {
                          return LoginScreen();
                        },
                      ),
                    );
                  },
                  child: Text('ورود'),
                )
            ],
          );
        },
      ),
    );
  }
}
