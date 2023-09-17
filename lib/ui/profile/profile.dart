import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nike_ecommerce_flutter/common/utils.dart';
import 'package:nike_ecommerce_flutter/data/auth.dart';
import 'package:nike_ecommerce_flutter/data/repo/auth_repository.dart';
import 'package:nike_ecommerce_flutter/data/repo/cart_repository.dart';
import 'package:nike_ecommerce_flutter/ui/auth/login/login.dart';
import 'package:nike_ecommerce_flutter/ui/favorites/favorite_list.dart';
import 'package:nike_ecommerce_flutter/ui/order/order_history_screen.dart';

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
      body: ValueListenableBuilder<AuthInfo?>(
        valueListenable: AuthRepository.authChangeNotifier,
        builder: (context, authInfo, child) {
          final isLogin = authInfo != null && authInfo.accessToken.isNotEmpty;
          return Center(
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
                Text(isLogin ? authInfo.email : 'کاربر میهمان'),
                32.0.height,
                const Divider(
                  height: 1,
                ),
                _ProfileItem(
                  title: 'لیست علاقه مندی ها',
                  iconData: CupertinoIcons.heart,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return const FavoriteListScreen();
                        },
                      ),
                    );
                  },
                ),
                const Divider(
                  height: 1,
                ),
                _ProfileItem(
                  title: 'سوابق سفارش',
                  iconData: CupertinoIcons.cart,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return const OrderHistoryScreen();
                        },
                      ),
                    );
                  },
                ),
                const Divider(
                  height: 1,
                ),
                _ProfileItem(
                  title: isLogin ? 'خروج از حساب کاربری' : 'ورود به حساب کاربری',
                  iconData: isLogin ? CupertinoIcons.arrow_right_square : CupertinoIcons.arrow_left_square,
                  onTap: () {
                    if (isLogin) {
                      showDialog(
                        context: context,
                        useRootNavigator: false,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('خروج از حساب کاربری'),
                            content: const Text('آیا میخواهید از حساب خود خارج شوید؟'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('خیر'),
                              ),
                              TextButton(
                                onPressed: () {
                                  CartRepository.cartItemCountNotifier.value = 0;
                                  authRepository.logout();
                                  Navigator.pop(context);
                                },
                                child: const Text('بله'),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return LoginScreen();
                          },
                        ),
                      );
                    }
                  },
                ),
                const Divider(
                  height: 1,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ProfileItem extends StatelessWidget {
  final String title;
  final IconData iconData;
  final Function() onTap;

  const _ProfileItem({
    required this.title,
    required this.iconData,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
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
