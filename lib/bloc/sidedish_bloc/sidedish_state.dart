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
