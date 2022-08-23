import 'package:billing/models/createSidedish_request.dart';
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

    on<CreateSidedish>((event, emit) async {
      emit(CreateSidedishLoad());
      try {
        var response = await SidedishRepository().createSidedish(event.request);
        emit(CreateSidedishDone());
      } catch (e) {
        emit(CreateSidedishError());
      }
    });

    on<UpdateSidedishEvent>((event, emit) async {
      emit(UpdateSidedishLoad());

      try {
        var response =
            await SidedishRepository().updateSidedish(event.id, event.request);

        emit(UpdateSidedishDone());
      } catch (e) {
        emit(UpdateSidedishError());
      }
    });

    on<DeleteSidedishEvent>((event, emit) async {
      emit(DeleteSidedishLoad());

      try {
        var response = await SidedishRepository().deleteSidedish(event.id);

        emit(DeleteSidedishDone());
      } catch (e) {
        emit(DeleteSidedishError());
      }
    });
  }
}
