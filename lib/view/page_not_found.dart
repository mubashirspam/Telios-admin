import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../settings/router.dart';

class PageNotFound extends StatelessWidget {
  const PageNotFound(this.url, {super.key});

  final String url;

  @override
  Widget build(BuildContext context) {
    void handleHomePressed() => context.go(ScreenPaths.home);
    final style = Theme.of(context).textTheme;
    final color = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: color.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: handleHomePressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: color.primary,
                foregroundColor: color.onPrimary,
                minimumSize: const Size(double.maxFinite, 50),
              ),
              child: Text(
                "Back to Home",
                style: style.titleMedium,
              ),
            )
          ],
        ),
      ),
    );
  }
}
