part of 'sidedish_bloc.dart';

@immutable
abstract class SidedishEvent {}

class FetchSidedish extends SidedishEvent {}

class CreateSidedish extends SidedishEvent {
  final CreateSidedishRequest request;

  CreateSidedish(this.request);
}

class DeleteSidedishEvent extends SidedishEvent {
  final int id;

  DeleteSidedishEvent(this.id);
}

class UpdateSidedishEvent extends SidedishEvent {
  final int id;
  final CreateSidedishRequest request;

  UpdateSidedishEvent(this.id, this.request);
}
