import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike_ecommerce_flutter/common/exceptions.dart';
import 'package:nike_ecommerce_flutter/data/repo/auth_repository.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final IAuthRepository authRepository;

  RegisterBloc({required this.authRepository}) : super(RegisterInitialState()) {
    on<RegisterEvent>((event, emit) async {
      try {
        if (event is RegisterButtonIsClickedEvent) {
          emit(RegisterLoadingState());
          await authRepository.login(username: event.username, password: event.password);
          emit(RegisterSuccessState());
        }
      } catch (e) {
        emit(RegisterErrorState(appException: e is AppException ? e : AppException()));
      }
    });
  }
}
