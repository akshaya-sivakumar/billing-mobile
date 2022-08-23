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

class CreateBranchLoad extends BranchState {}

class CreateBranchError extends BranchState {}

class CreateBranchDone extends BranchState {}

class UpdateBranchLoad extends BranchState {}

class UpdateBranchError extends BranchState {}

class UpdateBranchDone extends BranchState {}

class DeleteBranchLoad extends BranchState {}

class DeleteBranchError extends BranchState {}

class DeleteBranchDone extends BranchState {}
