import 'package:flutter/material.dart';
import 'package:lml/src/bloc/states.dart';
import 'package:lml/src/navigation/route.dart';

class NavigatorLoadSuccess extends BlocState {
  final List<AppRoute> routes;
  late List<Page> pages;

  NavigatorLoadSuccess({required this.routes}) {
    pages = routes.map((e) => e.builder()).toList();
  }
}
