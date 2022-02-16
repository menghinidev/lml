import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lml/src/bloc/events.dart';
import 'package:lml/src/bloc/states.dart';
import 'package:lml/src/navigation/route.dart';
import 'navigator_events.dart';
import 'navigator_states.dart';

///
/// The [Bloc] entity that receives [BlocEvent] sent through the [add] function and emits
/// [BlocState] depending on the current configuration
///
/// States:
/// * [NavigatorLoadSuccess] is the state where the navigator is loaded and a snapshot of it is available.
///
/// Events:
/// * [PagePushed] event to request a new route on top
/// * [PagePushedAsFirst] to clean the navigation navigation stack and push a new route on top
/// * [PagePopped] to pop from the current route
/// * [PagePoppedUntilRoute] to pop all the latest route until a matching route is found
///

class NavigatorBloc extends Bloc<BlocEvent, BlocState> {
  final navigatorKey = GlobalKey<NavigatorState>();

  NavigatorBloc() : super(InitialBlocState()) {
    on<PagePopped>((event, emit) => _handlePagePopped(emit));
    on<PagePoppedUntilRoute>((event, emit) => _handlePagePoppedUntilRoute(event, emit));
    on<PagePushed>((event, emit) => _handlePagePushed(event, emit));
    on<PagePushedAsFirst>((event, emit) => _handlePagePushedAsFirst(event, emit));
    on<ExternalPageRequestReceived>((event, emit) => _handleExternalPageRequested(event, emit));
    on<InitialPagePushed>((event, emit) => _handleInitialPagePushed(event, emit));
  }

  Future _handlePagePopped(Emitter<BlocState> emitter) async {
    var actualState = state;
    if (actualState is NavigatorLoadSuccess) {
      var routes = actualState.routes;
      if (routes.length == 1) return Future.value();
      var newRoutes = List<AppRoute>.from(routes)..removeLast();
      emitter.call(NavigatorLoadSuccess(routes: newRoutes));
    }
  }

  Future _handlePagePoppedUntilRoute(PagePoppedUntilRoute event, Emitter<BlocState> emitter) async {
    var actualState = state;
    if (actualState is NavigatorLoadSuccess) {
      var routes = actualState.routes;
      var matching = routes.where((element) => element.path == event.routeName);
      if (matching.isNotEmpty) {
        var index = actualState.routes.indexOf(matching.first);
        if (index.isNegative) return;
        var newRoutes = List<AppRoute>.from(routes)..removeRange(index + 1, actualState.routes.length);
        emitter.call(NavigatorLoadSuccess(routes: newRoutes));
      }
    }
  }

  Future _handlePagePushed(PagePushed event, Emitter<BlocState> emitter) async {
    var actualState = state;
    if (actualState is InitialBlocState) {
      return await _handlePagePushedAsFirst(PagePushedAsFirst(route: event.route), emitter);
    }
    if (actualState is NavigatorLoadSuccess) {
      var routes = actualState.routes;
      var matching = routes.where((element) => element.path == event.route.path);
      if (matching.isNotEmpty) {
        return await _handlePagePoppedUntilRoute(PagePoppedUntilRoute(routeName: event.route.path), emitter);
      }
      var newRoutes = List<AppRoute>.from(routes)..add(event.route);
      emitter.call(NavigatorLoadSuccess(routes: newRoutes));
    }
  }

  Future _handlePagePushedAsFirst(PagePushedAsFirst event, Emitter<BlocState> emitter) async {
    emitter.call(NavigatorLoadSuccess(routes: <AppRoute>[event.route]));
  }

  Future _handleInitialPagePushed(InitialPagePushed event, Emitter<BlocState> emitter) async {
    return _handlePagePushedAsFirst(PagePushedAsFirst(route: event.route), emitter);
  }

  Future _handleExternalPageRequested(ExternalPageRequestReceived event, Emitter<BlocState> emitter) async {
    var actualState = state;
    if (actualState is NavigatorLoadSuccess) {
      var routes = actualState.routes;
      var isInRoutes = routes.where((element) => element.path == event.route.path).isNotEmpty;
      if (isInRoutes) {
        return await _handlePagePoppedUntilRoute(PagePoppedUntilRoute(routeName: event.route.path), emitter);
      }
      return await _handlePagePushed(PagePushed(route: event.route), emitter);
    }
  }
}
