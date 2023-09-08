import 'package:dio/dio.dart';
import 'package:nike_ecommerce_flutter/common/exceptions.dart';

mixin HttpResponseValidator {
  void validateResponse(Response response) {
    if (response.statusCode != 200) {
      throw AppException();
    }
  }
}
