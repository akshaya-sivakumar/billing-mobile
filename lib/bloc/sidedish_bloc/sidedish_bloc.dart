import 'package:billing/models/sidedish_detail.dart';
import 'package:billing/repository/sidedish_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'sidedish_event.dart';
part 'sidedish_state.dart';

class SidedishBloc extends Bloc<SidedishEvent, SidedishState> {
  SidedishBloc() : super(SidedishInitial()) {
    on<FetchSidedish>((event, emit) async {
      emit(SidedishLoad());
      try {
        var response = await SidedishRepository().getSidedish();
        emit(SidedishDone(response));
      } catch (e) {
        emit(SidedishError());
      }
    });
  }
}
