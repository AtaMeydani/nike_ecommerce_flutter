part of 'login_bloc.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginStartedEvent extends LoginEvent {}

class LoginButtonIsClickedEvent extends LoginEvent {
  final String username;
  final String password;

  const LoginButtonIsClickedEvent({
    required this.username,
    required this.password,
  });
}
