import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_ecommerce_flutter/common/http_client.dart';
import 'package:nike_ecommerce_flutter/data/repo/comment_repository.dart';
import 'package:nike_ecommerce_flutter/data/src/comment_data_source.dart';
import 'package:nike_ecommerce_flutter/ui/product/comment/bloc/comment_list_bloc.dart';
import 'package:nike_ecommerce_flutter/ui/product/comment/comment_item.dart';
import 'package:nike_ecommerce_flutter/ui/widgets/error.dart';

final commentRepository = CommentRepository(remoteDataSource: CommentRemoteDataSource(httpClient: httpClient));

class CommentList extends StatelessWidget {
  final int productId;
  const CommentList({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return CommentListBloc(commentRepository: commentRepository, productId: productId)
          ..add(CommentListStartedEvent());
      },
      child: BlocBuilder<CommentListBloc, CommentListState>(
        builder: (context, state) {
          if (state is CommentListSuccess) {
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return CommentItem(comment: state.comments[index]);
                },
                childCount: state.comments.length,
              ),
            );
          } else if (state is CommentListLoading) {
            return const SliverToBoxAdapter(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (state is CommentListError) {
            return SliverToBoxAdapter(
              child: AppErrorWidget(
                appException: state.appException,
                onPressed: () {
                  BlocProvider.of<CommentListBloc>(context).add(
                    CommentListRefreshEvent(),
                  );
                },
              ),
            );
          } else {
            throw Exception('state is not supported');
          }
        },
      ),
    );
  }
}
