import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lml/src/bloc/events.dart';
import 'package:lml/src/bloc/states.dart';
import 'package:lml/src/utils/error/error_details.dart';

class APIErrorRaised extends BlocEvent {
  final List<ErrorDetails> errors;

  ErrorDetails? get relevantError => errors.isEmpty ? null : errors.first;

  APIErrorRaised({required this.errors});
}

class ErrorDismissed extends BlocEvent {}

class GeneralErrorRaised extends BlocEvent {
  final String description;

  GeneralErrorRaised({required this.description});
}

class ErrorProcessing extends BlocState {
  final ErrorDetails error;
  final Function? callback;

  ErrorProcessing({required this.error, this.callback});
}

class NoErrors extends BlocState {}

///
/// A basic [Bloc] that can receive these events
///
/// * [GeneralErrorRaised]
/// * [APIErrorRaised] (a more detailed error that uses [ErrorDetails] class)
///

class ErrorManagerBloc extends Bloc<BlocEvent, BlocState> {
  ErrorManagerBloc() : super(NoErrors()) {
    on<APIErrorRaised>((event, emit) => _handleErrorRaised(event, emit));
    on<GeneralErrorRaised>((event, emit) => _handleErrorRaised(event, emit));
    on<ErrorDismissed>((event, emit) => emit.call(NoErrors()));
  }

  Future _handleErrorRaised(BlocEvent errorEvent, Emitter<BlocState> emitter) {
    if (state is ErrorProcessing) return Future.value();
    if (errorEvent is APIErrorRaised) {
      var newState = ErrorProcessing(error: errorEvent.relevantError ?? ErrorDetails(id: 0, message: ''));
      emitter.call(newState);
    } else if (errorEvent is GeneralErrorRaised) {
      var error = ErrorDetails(id: 0, message: errorEvent.description);
      var newState = ErrorProcessing(error: error);
      emitter.call(newState);
    }
    return Future.value();
  }
}
