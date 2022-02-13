import 'package:flutter/material.dart';

abstract class AppRoute {
  final String path;
  final Page Function() builder;
  final bool Function()? requirements;

  AppRoute({required this.path, required this.builder, this.requirements});
}

abstract class AppRouteFinalizer<T extends AppRoute> {
  T generateRoute(Map<String, String> values);
  bool hasMatch(Uri uri);
}
