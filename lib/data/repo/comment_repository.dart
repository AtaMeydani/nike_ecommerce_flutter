import 'package:nike_ecommerce_flutter/data/comment.dart';
import 'package:nike_ecommerce_flutter/data/src/comment_data_source.dart';

abstract class ICommentRepository {
  Future<List<CommentEntity>> getAll({required int productId});
  Future<CommentEntity> add({required String title, required String content, required int productId});
}

class CommentRepository implements ICommentRepository {
  final ICommentDataSource remoteDataSource;

  CommentRepository({
    required this.remoteDataSource,
  });

  @override
  Future<List<CommentEntity>> getAll({required int productId}) => remoteDataSource.getAll(productId: productId);

  @override
  Future<CommentEntity> add({required String title, required String content, required int productId}) {
    return remoteDataSource.add(title: title, content: content, productId: productId);
  }
}
