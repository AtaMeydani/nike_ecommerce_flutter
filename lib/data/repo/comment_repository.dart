import 'package:nike_ecommerce_flutter/data/comment.dart';
import 'package:nike_ecommerce_flutter/data/src/comment_data_source.dart';

abstract class ICommentRepository {
  Future<List<CommentEntity>> getAll({required int productId});
}

class CommentRepository implements ICommentRepository {
  final ICommentDataSource remoteDataSource;

  CommentRepository({
    required this.remoteDataSource,
  });

  @override
  Future<List<CommentEntity>> getAll({required int productId}) => remoteDataSource.getAll(productId: productId);
}
