import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lml/src/navigation/route.dart';
import 'package:flutter/material.dart';

import 'bloc/navigation_bloc.dart';
import 'bloc/navigation_events.dart';
import 'bloc/navigation_states.dart';

///
/// A basic implementation of [RouterDelegate] that handle navigation app state with the
/// provided [NavigationBloc] which handle [NavigationEvents] like [PagePushed], [PagePopped] and more
///

class RootNavigationDelegate extends RouterDelegate<AppRoute>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRoute> {
  final NavigationBloc navigationBloc;
  final AppRoute defaultAppRoute;

  RootNavigationDelegate({required this.navigationBloc, required this.defaultAppRoute}) {
    navigationBloc.stream.listen((event) => notifyListeners());
  }

  @override
  AppRoute get currentConfiguration {
    var navState = navigationBloc.state;
    if (navState is NavigationInitialState) return defaultAppRoute;
    if (navState is NavigationSnapshot && navState.routes.isNotEmpty) {
      return navState.routes.last;
    } else {
      return defaultAppRoute;
    }
  }

  @override
  GlobalKey<NavigatorState> get navigatorKey => navigationBloc.navigatorKey;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationBloc, NavigationState>(
      bloc: navigationBloc,
      builder: (context, state) => Navigator(
        key: navigatorKey,
        pages: [
          if (state is NavigationSnapshot)
            ...List.unmodifiable(state.pages)
          else if (state is NavigationInitialState) ...[defaultAppRoute.builder()]
        ],
        onPopPage: (route, result) {
          if (!route.didPop(result)) return false;
          navigationBloc.add(PagePopped());
          return true;
        },
      ),
    );
  }

  @override
  Future<void> setNewRoutePath(AppRoute configuration) {
    navigationBloc.add(ExternalPageRequestReceived(route: configuration));
    return Future.value();
  }

  @override
  Future<void> setInitialRoutePath(AppRoute configuration) {
    return Future.value();
  }
}
