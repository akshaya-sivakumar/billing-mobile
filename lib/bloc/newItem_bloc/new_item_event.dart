part of 'new_item_bloc.dart';

@immutable
abstract class NewItemEvent {}

class createNewitem extends NewItemEvent {
  final NewitemRequest request;

  createNewitem(this.request);
}
