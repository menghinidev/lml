import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lml/src/bloc/events.dart';
import 'package:lml/src/bloc/listeners/bloc_state_listener_binder.dart';
import 'package:lml/src/bloc/states.dart';

///
/// A [Widget] that depending on [T] bloc state calls a different [BlocStateListenerBinder] trigger.
///
/// If the [bloc] parameter is omitted, [BlocStateListener] will automatically perform a lookup using [BlocProvider] and the current [BuildContext].
///

class BlocStateListener<T extends Bloc<BlocEvent, BlocState>> extends BlocListener<T, BlocState> {
  BlocStateListener({required List<BlocStateListenerBinder> stateBinders, Widget? child, T? bloc})
      : super(
          child: child,
          bloc: bloc,
          listenWhen: (previous, state) => stateBinders.where((element) => element.isActive(state)).isNotEmpty,
          listener: (context, state) {
            var activeBinders = stateBinders.where((element) => element.isActive(state));
            if (activeBinders.isEmpty) return;
            activeBinders.first.listener(context, state);
          },
        );
}

///
/// A [Widget] that accepts muliple [BlocStateListener]
///

class MultiBlocStateListener extends StatelessWidget {
  final List<BlocStateListener> listeners;
  final Widget child;
  const MultiBlocStateListener({required this.child, this.listeners = const <BlocStateListener>[]});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(listeners: listeners, child: child);
  }
}
