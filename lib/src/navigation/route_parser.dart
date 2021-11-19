import 'package:flutter/material.dart';
import 'package:lml/src/navigation/route.dart';
import '../collections/iterable_utilities.dart';

class AppRouteParser extends RouteInformationParser<AppRoute> {
  final List<AppRoute> supportedRoutes;
  final AppRoute defaultAppRoute;

  AppRouteParser({required this.supportedRoutes, required this.defaultAppRoute});

  @override
  Future<AppRoute> parseRouteInformation(RouteInformation routeInformation) {
    var uri = Uri.tryParse(routeInformation.location ?? '') ?? Uri(path: '');
    var route = supportedRoutes.getWhere((element) => element.path == uri.path) ?? defaultAppRoute;
    return Future.value(route);
  }

  @override
  RouteInformation restoreRouteInformation(AppRoute configuration) => RouteInformation(location: configuration.path);
}
