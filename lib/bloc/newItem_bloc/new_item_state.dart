part of 'new_item_bloc.dart';

@immutable
abstract class NewItemState {}

class NewItemInitial extends NewItemState {}

class NewItemLoad extends NewItemState {}

class NewItemDone extends NewItemState {}

class NewItemError extends NewItemState {}
