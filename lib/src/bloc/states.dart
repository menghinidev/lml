///
/// Base class to encapsulate states
///

abstract class BlocState {}

class LoadingBlocState extends BlocState {}

class InitialBlocState extends BlocState {}

class FailedBlocState extends BlocState {}
