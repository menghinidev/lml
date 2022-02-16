import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/navigator.dart';
import 'package:lml/navigation.dart';
import 'package:lml/src/navigation/bloc/navigator_bloc.dart';
import 'package:lml/src/navigation/bloc/navigator_events.dart';
import 'package:test/test.dart';

class FirstAppRoute extends AppRoute {
  FirstAppRoute() : super(path: 'First', builder: () => MaterialPage(child: Container()));
}

class SecondAppRoute extends AppRoute {
  SecondAppRoute() : super(path: 'Second', builder: () => MaterialPage(child: Container()));
}

class ThirdAppRoute extends AppRoute {
  ThirdAppRoute() : super(path: 'Third', builder: () => MaterialPage(child: Container()));
}

void main() {
  var firstRoute = FirstAppRoute();
  var secondRoute = SecondAppRoute();
  var thirdRoute = ThirdAppRoute();

  group('Navigator Test', () {
    late NavigatorBloc bloc = NavigatorBloc();
    StreamSubscription? currentSub;

    setUp(() {
      if (currentSub != null) {
        currentSub!.cancel();
        currentSub = null;
      }
    });

    test('Intialization Test', () {
      currentSub = bloc.stream.listen((event) {
        expect(bloc.state.runtimeType, NavigatorLoadSuccess);
        expect((bloc.state as NavigatorLoadSuccess).pages.length, 1);
      });
      bloc.add(InitialPagePushed(route: firstRoute));
    });

    test('PagePushed Event', () {
      currentSub = bloc.stream.listen((event) {
        expect(event.runtimeType, NavigatorLoadSuccess);
        expect((event as NavigatorLoadSuccess).pages.length, 2);
        expect(event.routes[1].runtimeType, SecondAppRoute);
      });
      bloc.add(PagePushed(route: secondRoute));
    });

    test('PagePushedAsFirst Event', () {
      currentSub = bloc.stream.listen((event) {
        expect(event.runtimeType, NavigatorLoadSuccess);
        expect((event as NavigatorLoadSuccess).pages.length, 1);
        expect(event.routes.first.runtimeType, FirstAppRoute);
      });
      bloc.add(PagePushedAsFirst(route: firstRoute));
    });

    test('Populating navigator stack', () {
      bloc.add(PagePushed(route: thirdRoute));
      bloc.add(PagePushed(route: secondRoute));
    });

    test('PagePopped Event', () {
      currentSub = bloc.stream.listen((event) {
        expect(event.runtimeType, NavigatorLoadSuccess);
        expect((event as NavigatorLoadSuccess).routes.last.runtimeType, ThirdAppRoute);
      });
      bloc.add(PagePopped());
    });

    test('PagePoppedUntil Event', () {
      currentSub = bloc.stream.listen((event) {
        expect(event.runtimeType, NavigatorLoadSuccess);
        expect((event as NavigatorLoadSuccess).routes.isEmpty, false);
        expect(event.routes.first.runtimeType, FirstAppRoute);
      });
      bloc.add(PagePoppedUntilRoute(routeName: firstRoute.path));
    });
  });
}
