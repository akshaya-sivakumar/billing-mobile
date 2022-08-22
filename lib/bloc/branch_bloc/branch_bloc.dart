import 'package:billing/models/branchDetail.dart';
import 'package:billing/repository/branch_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'branch_event.dart';
part 'branch_state.dart';

class BranchBloc extends Bloc<BranchEvent, BranchState> {
  BranchBloc() : super(BranchInitial()) {
    on<FetchBranch>((event, emit) async {
      emit(BranchLoad());
      try {
        var response = await BranchRepository().getBranch();
        emit(BranchDone(response));
      } catch (e) {
        emit(BranchError());
      }
      // TODO: implement event handler
    });
  }
}
