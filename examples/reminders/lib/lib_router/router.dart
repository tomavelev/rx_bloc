// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../base/common_blocs/coordinator_bloc.dart';
import '../feature_dashboard/di/dashboard_page_with_dependencies.dart';
import '../feature_facebook_authentication/views/facebook_login_page.dart';
import '../feature_navigation/views/navigation_page.dart';
import '../feature_reminder_list/di/reminder_list_page_with_dependencies.dart';
import '../feature_splash/di/splash_page_with_dependencies.dart';
import 'models/routes_path.dart';
import 'views/error_page.dart';

part 'router.g.dart';
part 'routes/navigation_routes.dart';
part 'routes/root/login_routes.dart';
part 'routes/root/splash_routes.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shell');

class AppRouter {
  AppRouter(this._coordinatorBloc);

  final CoordinatorBlocType _coordinatorBloc;

  late final _GoRouterRefreshStream _refreshListener =
      _GoRouterRefreshStream(_coordinatorBloc.states.isAuthenticated);

  GoRouter get router => _goRouter;

  late final GoRouter _goRouter = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RoutesPath.splash,
    redirect: _pageRedirections,
    refreshListenable: _refreshListener,
    routes: [
      $splashRoute,
      $loginRoute,
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => NavigationPage(
          child: child,
        ),
        routes: [
          $dashboardRoute,
          $remindersRoute,
        ],
      ),
    ],
    errorPageBuilder: (context, state) => MaterialPage(
      key: state.pageKey,
      child: ErrorPage(
        error: state.error,
      ),
    ),
  );

  FutureOr<String?> _pageRedirections(
    BuildContext context,
    GoRouterState state,
  ) async {
    if (_refreshListener.isLoggedIn && state.queryParams['from'] != null) {
      return state.queryParams['from'];
    }
    if (_refreshListener.isLoggedIn && state.subloc == RoutesPath.login) {
      return RoutesPath.dashboard;
    }

    if (state.subloc == RoutesPath.splash) {
      return null;
    }

    if (!_refreshListener.isLoggedIn && state.subloc != RoutesPath.login) {
      return '${RoutesPath.login}?from=${state.location}';
    }

    return null;
  }
}

class _GoRouterRefreshStream extends ChangeNotifier {
  _GoRouterRefreshStream(Stream<bool> stream) {
    _subscription = stream.listen(
      (bool isLoggedIn) {
        this.isLoggedIn = isLoggedIn;
        notifyListeners();
      },
    );
  }

  late final StreamSubscription<bool> _subscription;
  late bool isLoggedIn = false;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

abstract class RouteData {
  String get routeLocation;
}
