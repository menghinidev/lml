import 'package:flutter/material.dart';
import 'package:lml/src/navigation/navigator_delegate.dart';
import 'package:lml/src/navigation/route_parser.dart';

///
/// Extend this class to add new [AppRoute] ot your application
///
/// Check out [NavigatorDelegate] and [NavigatorRouteParser] to understand how a route is used.
///
/// * [path] is the address (in web use the URL) where the route is available.
/// * [builder] is the [Page] builder that will be used by the [Router] widget.
///

abstract class AppRoute {
  final String path;
  final Page Function() builder;

  AppRoute({required this.path, required this.builder});
}

abstract class AppRouteFinalizer<T extends AppRoute> {
  final bool Function()? requirements;

  AppRouteFinalizer({this.requirements});

  T generateRoute(Map<String, String> values);
  bool hasMatch(Uri uri);
}
