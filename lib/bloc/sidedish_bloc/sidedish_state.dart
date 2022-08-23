part of 'sidedish_bloc.dart';

@immutable
abstract class SidedishState {}

class SidedishInitial extends SidedishState {}

class SidedishLoad extends SidedishState {}

class SidedishDone extends SidedishState {
  final List<SidedishDetail> sidedishList;

  SidedishDone(this.sidedishList);
}

class SidedishError extends SidedishState {}

class CreateSidedishLoad extends SidedishState {}

class CreateSidedishDone extends SidedishState {}

class CreateSidedishError extends SidedishState {}

class UpdateSidedishLoad extends SidedishState {}

class UpdateSidedishDone extends SidedishState {}

class UpdateSidedishError extends SidedishState {}

class DeleteSidedishLoad extends SidedishState {}

class DeleteSidedishDone extends SidedishState {}

class DeleteSidedishError extends SidedishState {}
