import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lml/src/navigation/route.dart';
import 'navigation_events.dart';
import 'navigation_states.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  final navigatorKey = GlobalKey<NavigatorState>();

  NavigationBloc() : super(NavigationInitialState()) {
    on<NavigationInitialized>((event, emit) => _handleNavigationInitialized(event.route, emit));
    on<PagePopped>((event, emit) => _handlePagePopped(emit));
    on<PagePoppedUntilRoute>((event, emit) => _handlePagePoppedUntilRoute(event, emit));
    on<PagePushed>((event, emit) => _handlePagePushed(event, emit));
    on<PagePushedAsFirst>((event, emit) => _handlePagePushedAsFirst(event, emit));
    on<ExternalPageRequestReceived>((event, emit) => _handleExternalPageRequested(event, emit));
  }

  Future _handleNavigationInitialized(AppRoute route, Emitter<NavigationState> emitter) async {
    return Future.value();
  }

  Future _handlePagePopped(Emitter<NavigationState> emitter) async {
    var actualState = state;
    if (actualState is NavigationSnapshot) {
      var routes = actualState.routes;
      if (routes.length == 1) return;
      var newRoutes = routes..removeLast();
      emitter.call(NavigationSnapshot(routes: newRoutes));
    }
  }

  Future _handlePagePoppedUntilRoute(PagePoppedUntilRoute event, Emitter<NavigationState> emitter) async {
    var actualState = state;
    if (actualState is NavigationSnapshot) {
      var routes = actualState.routes;
      var matching = routes.where((element) => element.path == event.routeName);
      if (matching.isNotEmpty) {
        var index = actualState.routes.indexOf(matching.first);
        if (index.isNegative) return;
        var routes = actualState.routes..removeRange(index + 1, actualState.routes.length);
        emitter.call(NavigationSnapshot(routes: routes));
      }
    }
  }

  Future _handlePagePushed(PagePushed event, Emitter<NavigationState> emitter) async {
    var actualState = state;
    if (actualState is NavigationInitialState) {
      return await _handlePagePushedAsFirst(PagePushedAsFirst(route: event.route), emitter);
    }
    if (actualState is NavigationSnapshot) {
      var routes = actualState.routes;
      var matching = routes.where((element) => element.path == event.route.path);
      if (matching.isNotEmpty) {
        return await _handlePagePoppedUntilRoute(PagePoppedUntilRoute(routeName: event.route.path), emitter);
      }
      var newRoutes = routes..add(event.route);
      emitter.call(NavigationSnapshot(routes: newRoutes));
    }
  }

  Future _handlePagePushedAsFirst(PagePushedAsFirst event, Emitter<NavigationState> emitter) async {
    emitter.call(NavigationSnapshot(routes: <AppRoute>[event.route]));
  }

  Future _handleExternalPageRequested(ExternalPageRequestReceived event, Emitter<NavigationState> emitter) async {
    var actualState = state;
    if (actualState is NavigationSnapshot) {
      var routes = actualState.routes;
      var isInRoutes = routes.where((element) => element.path == event.route.path).isNotEmpty;
      if (isInRoutes) {
        return await _handlePagePoppedUntilRoute(PagePoppedUntilRoute(routeName: event.route.path), emitter);
      }
      return await _handlePagePushed(PagePushed(route: event.route), emitter);
    }
  }
}
