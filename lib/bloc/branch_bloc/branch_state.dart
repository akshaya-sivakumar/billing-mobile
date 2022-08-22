part of 'branch_bloc.dart';

@immutable
abstract class BranchState {}

class BranchInitial extends BranchState {}

class BranchLoad extends BranchState {}

class BranchError extends BranchState {}

class BranchDone extends BranchState {
  final List<BranchDetail> branchList;

  BranchDone(this.branchList);
}
