import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lml/bloc.dart';
import 'package:lml/src/bloc/states.dart';
import 'package:lml/src/navigation/route.dart';
import 'package:flutter/material.dart';

import 'bloc/navigator_bloc.dart';
import 'bloc/navigator_events.dart';
import 'bloc/navigator_states.dart';

///
/// A basic implementation of [RouterDelegate] that listen to [NavigatorBloc] state stream and updates the [Navigator] wigdget properly.
///

class NavigatorDelegate extends RouterDelegate<AppRoute>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRoute> {
  final NavigatorBloc navigatorBloc;

  NavigatorDelegate({required this.navigatorBloc}) {
    navigatorBloc.stream.listen((event) => notifyListeners());
  }

  @override
  AppRoute? get currentConfiguration {
    var navState = navigatorBloc.state;
    if (navState is InitialBlocState) return null;
    if (navState is NavigatorLoadSuccess && navState.routes.isNotEmpty) return navState.routes.last;
    return null;
  }

  @override
  GlobalKey<NavigatorState> get navigatorKey => navigatorBloc.navigatorKey;

  @override
  Widget build(BuildContext context) {
    return BlocStateBuilder<NavigatorBloc>(
      bloc: navigatorBloc,
      stateBinders: [
        BlocStateBuilderBinder<NavigatorLoadSuccess>(
          builder: (context, state) => Navigator(
            key: navigatorKey,
            pages: List<Page<dynamic>>.unmodifiable(state.pages),
            onPopPage: (route, result) {
              if (route.didPop(result)) return false;
              navigatorBloc.add(PagePopped());
              return true;
            },
          ),
        ),
      ],
    );
  }

  @override
  Future<void> setNewRoutePath(AppRoute configuration) {
    navigatorBloc.add(ExternalPageRequestReceived(route: configuration));
    return Future.value();
  }

  @override
  Future<void> setInitialRoutePath(AppRoute configuration) {
    navigatorBloc.add(InitialPagePushed(route: configuration));
    return Future.value();
  }
}
