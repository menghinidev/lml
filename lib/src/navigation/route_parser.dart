import 'package:flutter/material.dart';
import 'package:lml/src/navigation/route.dart';
import 'package:lml/src/utils/extensions/list_extensions.dart';

class AppRouteParser extends RouteInformationParser<AppRoute> {
  final List<AppRouteFinalizer> supportedRoutes;
  final AppRouteFinalizer defaultAppRoute;

  AppRouteParser({required this.supportedRoutes, required this.defaultAppRoute});

  @override
  Future<AppRoute> parseRouteInformation(RouteInformation routeInformation) {
    var uri = Uri.tryParse(routeInformation.location ?? '') ?? Uri(path: '');
    var route = supportedRoutes.getWhere((element) => element.hasMatch(uri)) ?? defaultAppRoute;
    return Future.value(route.generateRoute(uri.queryParameters));
  }

  @override
  RouteInformation restoreRouteInformation(AppRoute configuration) => RouteInformation(location: configuration.path);
}
