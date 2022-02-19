import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

///
/// Mixin that allows to access more quickly the [X] bloc implementation through the provider [BuildContext]
///
/// [getAnyBloc] returns a custom [Bloc] of type [T]
///

mixin BlocRequester<X extends BlocBase<Object>> {
  X getRegBloc(BuildContext context) => BlocProvider.of<X>(context);

  T getAnyBloc<T extends BlocBase<Object>>(BuildContext context) => BlocProvider.of<T>(context);
}
