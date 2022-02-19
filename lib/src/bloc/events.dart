///
/// Base class to encapsulate events
///

abstract class BlocEvent {}

///
/// Standard [BlocEvent] to emit and initialization event
///

class BlocStarted extends BlocEvent {}
