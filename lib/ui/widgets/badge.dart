import 'package:flutter/material.dart';

class BadgeWidget extends StatelessWidget {
  final int value;
  const BadgeWidget({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return Visibility(
      visible: value > 0,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: themeData.colorScheme.primary,
        ),
        padding: const EdgeInsets.all(5.0),
        child: Text(
          value.toString(),
          style: TextStyle(
            color: themeData.colorScheme.onPrimary,
            fontSize: 10,
          ),
        ),
      ),
    );
  }
}
