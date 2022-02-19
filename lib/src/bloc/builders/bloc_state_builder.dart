import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lml/src/bloc/events.dart';
import 'package:lml/src/bloc/states.dart';
import 'bloc_state_builder_binder.dart';

///
/// A [Widget] that depending on [T] bloc state renders a different [BlocStateBuilderBinder] builder.
///
/// If the [bloc] parameter is omitted, [BlocStateBuilder] will automatically perform a lookup using [BlocProvider] and the current [BuildContext].
///

class BlocStateBuilder<T extends Bloc<BlocEvent, BlocState>> extends BlocBuilder<T, BlocState> {
  BlocStateBuilder({required List<BlocStateBuilderBinder> stateBinders, T? bloc})
      : super(
          bloc: bloc,
          buildWhen: (previous, current) => stateBinders.where((element) => element.isActive(current)).isNotEmpty,
          builder: (context, state) {
            if (stateBinders.isEmpty) return Container();
            var activeBinders = stateBinders.where((element) => element.isActive(state));
            if (activeBinders.isEmpty) return Container();
            return activeBinders.first.build(context, state);
          },
        );
}
