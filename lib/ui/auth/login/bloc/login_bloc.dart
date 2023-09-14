import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike_ecommerce_flutter/common/exceptions.dart';
import 'package:nike_ecommerce_flutter/data/repo/auth_repository.dart';
import 'package:nike_ecommerce_flutter/data/repo/cart_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final IAuthRepository authRepository;
  final ICartRepository cartRepository;

  LoginBloc({required this.authRepository, required this.cartRepository}) : super(LoginInitialState()) {
    on<LoginEvent>((event, emit) async {
      try {
        if (event is LoginButtonIsClickedEvent) {
          emit(LoginLoadingState());
          await authRepository.login(username: event.username, password: event.password);
          await cartRepository.count();
          emit(LoginSuccessState());
        }
      } catch (e) {
        emit(LoginErrorState(appException: e is AppException ? e : AppException()));
      }
    });
  }
}
