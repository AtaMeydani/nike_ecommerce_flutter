import 'package:dio/dio.dart';
import 'package:nike_ecommerce_flutter/common/constants.dart';
import 'package:nike_ecommerce_flutter/data/auth.dart';
import 'package:nike_ecommerce_flutter/data/common/http_response_validator.dart';

abstract class IAuthDataSource {
  Future<AuthInfo> login({
    required String username,
    required String password,
  });

  Future<AuthInfo> register({
    required String username,
    required String password,
  });

  Future<AuthInfo> refreshToken({
    required String refreshToken,
  });
}

class AuthRemoteDataSource with HttpResponseValidator implements IAuthDataSource {
  final Dio httpClient;

  AuthRemoteDataSource({
    required this.httpClient,
  });

  @override
  Future<AuthInfo> login({required String username, required String password}) async {
    final Map<String, dynamic> headers = {
      'grant_type': 'password',
      'client_id': 2,
      'client_secret': Constants.clientSecret,
      'username': username,
      'password': password,
    };
    final response = await httpClient.post('auth/token', data: headers);
    validateResponse(response);

    return AuthInfo(
      accessToken: response.data['access_token'],
      refreshToken: response.data['refresh_token'],
    );
  }

  @override
  Future<AuthInfo> refreshToken({required String refreshToken}) {
    // TODO: implement refreshToken
    throw UnimplementedError();
  }

  @override
  Future<AuthInfo> register({required String username, required String password}) async {
    final Map<String, dynamic> headers = {
      'email': username,
      'password': password,
    };
    final response = await httpClient.post('user/register', data: headers);
    validateResponse(response);

    return login(username: username, password: password);
  }
}
