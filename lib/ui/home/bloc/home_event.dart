part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class HomeStartedEvent extends HomeEvent {}

class HomeRefreshEvent extends HomeEvent {}
