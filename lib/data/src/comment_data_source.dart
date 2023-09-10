import 'package:dio/dio.dart';
import 'package:nike_ecommerce_flutter/data/comment.dart';
import 'package:nike_ecommerce_flutter/data/common/http_response_validator.dart';

abstract class ICommentDataSource {
  Future<List<CommentEntity>> getAll({required int productId});
}

class CommentRemoteDataSource with HttpResponseValidator implements ICommentDataSource {
  final Dio httpClient;

  CommentRemoteDataSource({
    required this.httpClient,
  });

  @override
  Future<List<CommentEntity>> getAll({required int productId}) async {
    final response = await httpClient.get('comment/list?product_id=$productId');
    validateResponse(response);
    return (response.data as List).map((json) => CommentEntity.fromJson(json)).toList();
  }
}
