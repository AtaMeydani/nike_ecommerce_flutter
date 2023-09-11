import 'package:nike_ecommerce_flutter/common/http_client.dart';
import 'package:nike_ecommerce_flutter/data/src/auth_data_source.dart';

final authRepository = AuthRepository(remoteDataSource: AuthRemoteDataSource(httpClient: httpClient));

abstract class IAuthRepository {
  Future<void> login({
    required String username,
    required String password,
  });
}

class AuthRepository implements IAuthRepository {
  final IAuthDataSource remoteDataSource;

  AuthRepository({
    required this.remoteDataSource,
  });

  @override
  Future<void> login({required String username, required String password}) =>
      remoteDataSource.login(username: username, password: password);
}
