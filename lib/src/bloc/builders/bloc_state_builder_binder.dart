import 'package:flutter/material.dart';
import 'package:lml/src/bloc/states.dart';

///
/// Bind a [BlocState] to a [Widget] rapresentation
///
/// The [builder] callback is triggered when the [isActive] returns 'true'
///
/// Use it inside a [BlocStateBuilder].
///
/// There are some commonly used pre-built binders:
///
/// * [FailedBlocStateBuilderBinder] maps the [FailedBlocState]
/// * [LoadingBlocStateBuilderBinder] maps the [LoadingBlocState]
/// * [InitialBlocStateBuilderBinder] maps the [InitialBlocState]
///

class BlocStateBuilderBinder<S extends BlocState> {
  final Widget Function(BuildContext, S) builder;

  const BlocStateBuilderBinder({required this.builder});

  bool isActive(BlocState state) => state is S;

  Widget build(BuildContext context, BlocState state) => builder(context, state as S);
}

class FailedBlocStateBuilderBinder extends BlocStateBuilderBinder<FailedBlocState> {
  FailedBlocStateBuilderBinder({required Widget failWidget}) : super(builder: (context, state) => failWidget);
}

class LoadingBlocStateBuilderBinder extends BlocStateBuilderBinder<LoadingBlocState> {
  LoadingBlocStateBuilderBinder({required Widget loadingWidget}) : super(builder: (context, state) => loadingWidget);
}

class InitialBlocStateBuilderBinder extends BlocStateBuilderBinder<InitialBlocState> {
  InitialBlocStateBuilderBinder({required Widget initialWidget}) : super(builder: (context, state) => initialWidget);
}
