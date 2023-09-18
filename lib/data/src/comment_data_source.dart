import 'package:dio/dio.dart';
import 'package:nike_ecommerce_flutter/data/comment.dart';
import 'package:nike_ecommerce_flutter/data/common/http_response_validator.dart';

abstract class ICommentDataSource {
  Future<List<CommentEntity>> getAll({required int productId});
  Future<CommentEntity> add({required String title, required String content, required int productId});
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

  @override
  Future<CommentEntity> add({required String title, required String content, required int productId}) async {
    final Map<String, dynamic> body = {
      'title': title,
      'content': content,
      'product_id': productId,
    };
    final response = await httpClient.post('comment/add', data: body);
    validateResponse(response);
    return CommentEntity.fromJson(response.data);
  }
}
