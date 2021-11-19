import 'package:lml/src/navigation/route.dart';

abstract class NavigationEvent {}

class NavigationInitialized extends NavigationEvent {
  final AppRoute route;

  NavigationInitialized({required this.route});
}

class PagePushed extends NavigationEvent {
  final AppRoute route;

  PagePushed({required this.route});
}

class PagePushedAsFirst extends NavigationEvent {
  final AppRoute route;

  PagePushedAsFirst({required this.route});
}

class PagePoppedUntilRoute extends NavigationEvent {
  final String routeName;

  PagePoppedUntilRoute({required this.routeName});
}

class PagePopped extends NavigationEvent {}

class ExternalPageRequestReceived extends NavigationEvent {
  final AppRoute route;

  ExternalPageRequestReceived({required this.route});
}

class Page404Requested extends NavigationEvent {}
