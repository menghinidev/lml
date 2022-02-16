import 'package:lml/src/bloc/events.dart';
import 'package:lml/src/navigation/route.dart';

class PagePushed extends BlocEvent {
  final AppRoute route;

  PagePushed({required this.route});
}

class PagePushedAsFirst extends BlocEvent {
  final AppRoute route;

  PagePushedAsFirst({required this.route});
}

class PagePoppedUntilRoute extends BlocEvent {
  final String routeName;

  PagePoppedUntilRoute({required this.routeName});
}

class InitialPagePushed extends BlocEvent {
  final AppRoute route;

  InitialPagePushed({required this.route});
}

class ExternalPageRequestReceived extends BlocEvent {
  final AppRoute route;

  ExternalPageRequestReceived({required this.route});
}

class PagePopped extends BlocEvent {}

class Page404Requested extends BlocEvent {}
