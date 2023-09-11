import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_ecommerce_flutter/data/repo/auth_repository.dart';
import 'package:nike_ecommerce_flutter/ui/auth/login/login.dart';
import 'package:nike_ecommerce_flutter/ui/auth/register/bloc/register_bloc.dart';
import 'package:nike_ecommerce_flutter/ui/auth/text_field.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController(text: 'test@gmail.com');
  final TextEditingController passwordController = TextEditingController(text: '123456');

  RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    return Scaffold(
      body: BlocProvider<RegisterBloc>(
        create: (context) {
          final bloc = RegisterBloc(authRepository: authRepository);
          bloc.add(RegisterStartedEvent());
          bloc.stream.forEach((state) {
            if (state is RegisterSuccessState) {
              Navigator.of(context);
            } else if (state is RegisterErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.appException.message),
                ),
              );
            }
          });

          return bloc;
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/nike_logo.png',
                height: 120,
              ),
              const SizedBox(
                height: 16,
              ),
              const Text(
                'خوش آمدید',
                style: TextStyle(
                  fontSize: 22,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              const Text(
                'لطفا وارد حساب کاربری خود شوید',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              EmailTextField(
                controller: usernameController,
              ),
              const SizedBox(
                height: 16,
              ),
              PasswordTextField(
                controller: passwordController,
              ),
              const SizedBox(
                height: 16,
              ),
              BlocBuilder<RegisterBloc, RegisterState>(
                buildWhen: (previous, current) {
                  return (current is! RegisterSuccessState) && previous != current;
                },
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<RegisterBloc>(context).add(
                        RegisterButtonIsClickedEvent(
                          username: usernameController.text,
                          password: passwordController.text,
                        ),
                      );
                    },
                    child: state is RegisterLoadingState
                        ? const CircularProgressIndicator()
                        : const Text(
                            'ثبت نام',
                          ),
                  );
                },
              ),
              const SizedBox(
                height: 24,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) {
                        return LoginScreen();
                      },
                    ),
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'حساب کاربری دارید؟',
                      style: TextStyle(),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      'ورود',
                      style: TextStyle(
                        color: themeData.colorScheme.primary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
