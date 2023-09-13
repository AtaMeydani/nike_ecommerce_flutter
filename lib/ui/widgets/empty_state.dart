import 'package:flutter/material.dart';

class EmptyStateWidget extends StatelessWidget {
  final String message;
  final Widget? callToAction;
  final Widget image;

  const EmptyStateWidget({
    super.key,
    required this.message,
    this.callToAction,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        image,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Text(
            message,
            style: themeData.textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
        ),
        if (callToAction != null) callToAction!,
      ],
    );
  }
}
