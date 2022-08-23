import 'package:billing/repository/newItem_repo.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../models/newItem_request.dart';

part 'new_item_event.dart';
part 'new_item_state.dart';

class NewItemBloc extends Bloc<NewItemEvent, NewItemState> {
  NewItemBloc() : super(NewItemInitial()) {
    on<createNewitem>((event, emit) async {
      emit(NewItemLoad());
      try {
        var response = await NewitemRepository().createNewitem(event.request);
        emit(NewItemDone());
      } catch (e) {
        emit(NewItemError());
      }
    });
  }
}
