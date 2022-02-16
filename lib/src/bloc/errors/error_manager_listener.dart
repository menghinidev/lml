import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lml/src/bloc/errors/error_manager_bloc.dart';
import 'package:lml/src/bloc/listeners/bloc_state_listener.dart';
import 'package:lml/src/bloc/listeners/bloc_state_listener_binder.dart';
import 'package:lml/src/bloc/utils.dart';

class ErrorBlocListener<T> extends StatelessWidget with BlocRequester<ErrorManagerBloc> {
  final Widget child;
  final Future<T> Function(BuildContext context, ErrorProcessing state) errorHandler;
  const ErrorBlocListener({required this.child, required this.errorHandler, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocStateListener<ErrorManagerBloc>(
      stateBinders: [
        BlocStateListenerBinder<ErrorProcessing>(
          trigger: (context, state) => errorHandler(context, state).then(
            (value) => getRegBloc(context).add(ErrorDismissed()),
          ),
        )
      ],
      child: child,
    );
  }
}
