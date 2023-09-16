import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nike_ecommerce_flutter/common/utils.dart';
import 'package:nike_ecommerce_flutter/data/repo/auth_repository.dart';
import 'package:nike_ecommerce_flutter/data/repo/cart_repository.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('پروفایل'),
        actions: [
          IconButton(
            onPressed: () {
              CartRepository.cartItemCountNotifier.value = 0;
              authRepository.logout();
            },
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              height: 65,
              width: 65,
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.only(top: 32, bottom: 8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: themeData.dividerColor,
                  width: 2,
                ),
              ),
              child: Image.asset(
                'assets/images/nike_logo.png',
              ),
            ),
            Text('email'),
            32.0.height,
            const Divider(
              height: 1,
            ),
            const _ProfileItem(
              title: 'لیست علاقه مندی ها',
              iconData: CupertinoIcons.heart,
            ),
            const Divider(
              height: 1,
            ),
            const _ProfileItem(
              title: 'سوابق سفارش',
              iconData: CupertinoIcons.cart,
            ),
            const Divider(
              height: 1,
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileItem extends StatelessWidget {
  final String title;
  final IconData iconData;

  const _ProfileItem({
    super.key,
    required this.title,
    required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Icon(iconData),
            16.0.width,
            Text(title),
          ],
        ),
      ),
    );
  }
}
