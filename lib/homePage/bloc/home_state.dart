part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeSuccessState extends HomeState {
  final Map<String, dynamic> res;
  HomeSuccessState({required this.res});

  @override
  List<Object> get props => [res];
}

class ListeningState extends HomeState {}

class queryState extends HomeState {
  final String path;
  queryState({required this.path});

  @override
  List<Object> get props => [path];
}

class HomeErrorState extends HomeState {}

class querySuccessState extends HomeState {}

class queryDeleteState extends HomeState {}
