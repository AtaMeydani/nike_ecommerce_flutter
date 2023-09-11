import 'package:flutter/material.dart';
import 'package:nike_ecommerce_flutter/common/http_client.dart';
import 'package:nike_ecommerce_flutter/data/auth.dart';
import 'package:nike_ecommerce_flutter/data/src/auth_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

final authRepository = AuthRepository(remoteDataSource: AuthRemoteDataSource(httpClient: httpClient));

abstract class IAuthRepository {
  Future<void> login({
    required String username,
    required String password,
  });

  Future<void> register({
    required String username,
    required String password,
  });

  Future<void> refreshToken();
}

class AuthRepository implements IAuthRepository {
  final ValueNotifier<AuthInfo?> authChangeNotifier = ValueNotifier(null);
  final IAuthDataSource remoteDataSource;

  AuthRepository({
    required this.remoteDataSource,
  });

  @override
  Future<void> login({required String username, required String password}) async {
    final AuthInfo authInfo = await remoteDataSource.login(username: username, password: password);
    _persistAuthToken(authInfo);
  }

  @override
  Future<void> register({required String username, required String password}) async {
    final AuthInfo authInfo = await remoteDataSource.register(username: username, password: password);
    _persistAuthToken(authInfo);
  }

  @override
  Future<void> refreshToken() async {
    final AuthInfo authInfo = await remoteDataSource.refreshToken(refreshToken: 'refreshToken');
    _persistAuthToken(authInfo);
  }

  Future<void> loadAuthInfo() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final String? accessToken = sharedPreferences.getString('accessToken');
    final String? refreshToken = sharedPreferences.getString('refreshToken');

    if (accessToken != null && refreshToken != null) {
      authChangeNotifier.value = AuthInfo(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
    }
  }

  Future<void> _persistAuthToken(AuthInfo authInfo) async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('accessToken', authInfo.accessToken);
    sharedPreferences.setString('refreshToken', authInfo.refreshToken);
  }
}
