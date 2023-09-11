part of 'login_bloc.dart';

sealed class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

final class LoginInitialState extends LoginState {}

final class LoginErrorState extends LoginState {
  final AppException appException;
  const LoginErrorState({required this.appException});
}

final class LoginLoadingState extends LoginState {}

final class LoginSuccessState extends LoginState {}
