import 'package:flutter/material.dart';

abstract class AppRoute {
  final String path;
  final Page Function() builder;

  AppRoute({required this.path, required this.builder});
}

abstract class AppRouteFinalizer<T extends AppRoute> {
  T generateRoute(Map<String, String> values);
  bool hasMatch(Uri uri);
}
