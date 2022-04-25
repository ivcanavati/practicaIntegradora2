part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class ListeningEvent extends HomeEvent {}

class RecordEvent extends HomeEvent {}

class SendDataEvent extends HomeEvent {}

class QueryEvent extends HomeEvent {
  Map<String, dynamic> data = {};

  QueryEvent(this.data);
}

class DeleteEvent extends HomeEvent {
  Map<String, dynamic> data = {};

  DeleteEvent(this.data);
}

class DeleteFavEvent extends HomeEvent {
  Map<int, dynamic> data = {};

  DeleteFavEvent(this.data);
}
