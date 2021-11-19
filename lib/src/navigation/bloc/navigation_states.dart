import 'package:flutter/material.dart';
import 'package:lml/src/navigation/route.dart';

abstract class NavigationState {}

class NavigationInitialState extends NavigationState {}

class NavigationSnapshot extends NavigationState {
  final List<AppRoute> routes;
  late List<Page> pages;

  NavigationSnapshot({required this.routes}) {
    pages = routes.map((e) => e.builder()).toList();
  }
}
