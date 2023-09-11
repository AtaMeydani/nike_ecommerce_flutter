part of 'register_bloc.dart';

sealed class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object> get props => [];
}

final class RegisterInitialState extends RegisterState {}

final class RegisterErrorState extends RegisterState {
  final AppException appException;
  const RegisterErrorState({required this.appException});
}

final class RegisterLoadingState extends RegisterState {}

final class RegisterSuccessState extends RegisterState {}
