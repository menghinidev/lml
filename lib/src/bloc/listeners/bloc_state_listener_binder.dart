import 'package:lml/src/bloc/listeners/bloc_state_listener.dart';
import 'package:lml/src/bloc/states.dart';
import 'package:flutter/material.dart';

///
/// Bind a [BlocState] to a custom callback
///
/// The [trigger] callback is called **just once** when the [isActive] returns 'true'
///
/// Use it inside a [BlocStateListener].
///

class BlocStateListenerBinder<S extends BlocState> {
  final Function(BuildContext, S) trigger;

  const BlocStateListenerBinder({required this.trigger});

  bool isActive(BlocState state) => state is S;

  void listener(BuildContext context, BlocState state) => trigger(context, state as S);
}
