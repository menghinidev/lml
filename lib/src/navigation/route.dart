import 'package:flutter/material.dart';

abstract class AppRoute {
  final String path;
  final Page Function() builder;

  AppRoute({required this.path, required this.builder});
}
