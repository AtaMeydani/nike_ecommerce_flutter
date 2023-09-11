import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nike_ecommerce_flutter/ui/cart/cart.dart';
import 'package:nike_ecommerce_flutter/ui/home/home.dart';

const int homeIndex = 0;
const int cartIndex = 1;
const int profileIndex = 2;

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedScreenIndex = 0;
  final List<int> _navBarHistory = [];

  final GlobalKey<NavigatorState> _homeKey = GlobalKey();
  final GlobalKey<NavigatorState> _cartKey = GlobalKey();
  final GlobalKey<NavigatorState> _profileKey = GlobalKey();

  late final map = {
    homeIndex: _homeKey,
    cartIndex: _cartKey,
    profileIndex: _profileKey,
  };

  Future<bool> _onWillPop() async {
    final NavigatorState currentTabNavigatorState = map[selectedScreenIndex]!.currentState!;

    if (currentTabNavigatorState.canPop()) {
      currentTabNavigatorState.pop();
      return false;
    } else if (_navBarHistory.isNotEmpty) {
      setState(() {
        selectedScreenIndex = _navBarHistory.last;
        _navBarHistory.removeLast();
      });
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedScreenIndex,
          onTap: (selectedIndex) {
            setState(() {
              _navBarHistory.remove(selectedScreenIndex);
              _navBarHistory.add(selectedScreenIndex);
              selectedScreenIndex = selectedIndex;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                CupertinoIcons.home,
              ),
              label: 'خانه',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                CupertinoIcons.cart,
              ),
              label: 'سبد خرید',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                CupertinoIcons.person,
              ),
              label: 'پروفایل',
            ),
          ],
        ),
        body: IndexedStack(
          index: selectedScreenIndex,
          children: [
            _navigator(key: _homeKey, index: homeIndex, child: const HomeScreen()),
            _navigator(key: _cartKey, index: cartIndex, child: const CartScreen()),
            _navigator(key: _profileKey, index: profileIndex, child: const HomeScreen()),
          ],
        ),
      ),
    );
  }

  Widget _navigator({required GlobalKey<NavigatorState> key, required int index, required Widget child}) {
    return key.currentState == null && selectedScreenIndex != index
        ? const SizedBox()
        : Navigator(
            key: key,
            onGenerateRoute: (settings) => MaterialPageRoute(
              builder: (context) => Offstage(
                offstage: selectedScreenIndex != index,
                child: child,
              ),
            ),
          );
  }
}
