part of 'branch_bloc.dart';

@immutable
abstract class BranchEvent {}

class FetchBranch extends BranchEvent {}

class CreateBranch extends BranchEvent {
  final BranchRequest branchRequest;

  CreateBranch(this.branchRequest);
}

class DeleteBranchEvent extends BranchEvent {
  final int id;

  DeleteBranchEvent(this.id);
}

class UpdateBranchEvent extends BranchEvent {
  final int id;
  final BranchRequest request;

  UpdateBranchEvent(this.id, this.request);
}
