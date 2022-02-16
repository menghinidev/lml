import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lml/bloc.dart';
import 'package:lml/src/bloc/states.dart';
import 'package:lml/src/navigation/route.dart';
import 'package:flutter/material.dart';

import 'bloc/navigator_bloc.dart';
import 'bloc/navigator_events.dart';
import 'bloc/navigator_states.dart';

///
/// A basic implementation of [RouterDelegate] that supports [NavigationBloc] state stream and updates the [Navigator] wigdget properly
///

class NavigatorDelegate extends RouterDelegate<AppRoute>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRoute> {
  final NavigatorBloc navigationBloc;

  ///
  /// * [navigationBloc] is the referring [NavigationBloc] instance
  ///
  NavigatorDelegate({required this.navigationBloc}) {
    navigationBloc.stream.listen((event) => notifyListeners());
  }

  @override
  AppRoute? get currentConfiguration {
    var navState = navigationBloc.state;
    if (navState is InitialBlocState) return null;
    if (navState is NavigatorLoadSuccess && navState.routes.isNotEmpty) return navState.routes.last;
    return null;
  }

  @override
  GlobalKey<NavigatorState> get navigatorKey => navigationBloc.navigatorKey;

  @override
  Widget build(BuildContext context) {
    return BlocStateBuilder<NavigatorBloc>(
      bloc: navigationBloc,
      stateBinders: [
        BlocStateBuilderBinder<NavigatorLoadSuccess>(
          builder: (context, state) => Navigator(
            key: navigatorKey,
            pages: List<Page<dynamic>>.unmodifiable(state.pages),
            onPopPage: (route, result) {
              if (route.didPop(result)) return false;
              navigationBloc.add(PagePopped());
              return true;
            },
          ),
        ),
      ],
    );
  }

  @override
  Future<void> setNewRoutePath(AppRoute configuration) {
    navigationBloc.add(ExternalPageRequestReceived(route: configuration));
    return Future.value();
  }

  @override
  Future<void> setInitialRoutePath(AppRoute configuration) {
    navigationBloc.add(InitialPagePushed(route: configuration));
    return Future.value();
  }
}
