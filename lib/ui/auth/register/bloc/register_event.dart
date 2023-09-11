part of 'register_bloc.dart';

sealed class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class RegisterStartedEvent extends RegisterEvent {}

class RegisterButtonIsClickedEvent extends RegisterEvent {
  final String username;
  final String password;

  const RegisterButtonIsClickedEvent({
    required this.username,
    required this.password,
  });
}
