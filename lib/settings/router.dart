import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


import '../view/view.dart';

class ScreenPaths {
  static String home = '/';
  // static String level2 = '/level2';

  static String level2(String? id) => '/level2${id != null ? '?t=$id' : ''}';

  static String level3(String? id) =>
      _appendToCurrentPath('/level3?t=${id ?? ''}');

  static String _appendToCurrentPath(String newPath) {
    final newPathUri = Uri.parse(newPath);
    final currentUri = appRouter.routeInformationProvider.value.uri;
    Map<String, dynamic> params = Map.of(currentUri.queryParameters);
    params.addAll(newPathUri.queryParameters);
    Uri? loc = Uri(
        path: '${currentUri.path}/${newPathUri.path}'.replaceAll('//', '/'),
        queryParameters: params);
    return loc.toString();
  }
}

final appRouter = GoRouter(
  errorPageBuilder: (context, state) =>
      MaterialPage(child: PageNotFound(state.uri.toString())),
  routes: [
    ShellRoute(
        builder: (context, router, navigator) {
          return navigator;
        },
        routes: [
          AppRoute(ScreenPaths.home, (_) => const HomeScreen()),
          AppRoute(
            '/level2',
            (s) {
              return Level2Screen(id: s.uri.queryParameters['t'] ?? '');
            },
            useFade: true,
            routes: [
              AppRoute(
            'level3',
            (s) {
              return Level3Screen(id: s.uri.queryParameters['t'] ?? '');
            },
            useFade: true,
           
          ),
            ]
          ),
        ]),
  ],
);

class AppRoute extends GoRoute {
  AppRoute(String path, Widget Function(GoRouterState s) builder,
      {List<GoRoute> routes = const [], this.useFade = false})
      : super(
          path: path,
          routes: routes,
          pageBuilder: (context, state) {
            final pageContent = Scaffold(
              body: builder(state),
              resizeToAvoidBottomInset: false,
            );
            if (useFade) {
              return CustomTransitionPage(
                key: state.pageKey,
                child: pageContent,
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
              );
            }
            return CupertinoPage(child: pageContent);
          },
        );
  final bool useFade;
}

// String? get initialDeeplink => _initialDeeplink;
// String? _initialDeeplink;

// String? _handleRedirect(BuildContext context, GoRouterState state) {
//   final appLogic = Get.find<AppServices>();
//   final authController = Get.find<AuthController>();

//   // Prevent anyone from navigating away from `/` if app is starting up.
//   if (!appLogic.isBootstrapComplete && state.uri.path != ScreenPaths.splash) {
//     debugPrint('Redirecting from ${state.uri.path} to ${ScreenPaths.splash}.');
//     _initialDeeplink ??= state.uri.toString();
//     return ScreenPaths.splash;
//   }
//   if (!authController.isAdminSignedIn &&
//       !authController.isUserSignedIn &&
//       state.uri.path != ScreenPaths.intro &&
//       state.uri.path == ScreenPaths.splash) {
//     return ScreenPaths.intro;
//   }
//   if (appLogic.isBootstrapComplete &&
//           authController.isUserSignedIn &&
//           !authController.isAdminSignedIn &&
//           state.uri.path == ScreenPaths.intro ||
//       state.uri.path == ScreenPaths.splash) {
//     debugPrint('Redirecting from ${state.uri.path} to ${ScreenPaths.home}');
//     return ScreenPaths.home;
//   }
//   if (appLogic.isBootstrapComplete &&
//           authController.isAdminSignedIn &&
//           state.uri.path == ScreenPaths.intro ||
//       state.uri.path == ScreenPaths.splash) {
//     return ScreenPaths.dashboard(tabIndex: 0);
//   }
//   if (!kIsWeb) debugPrint('Navigate to: ${state.uri}');
//   return null; // do nothing
// }
