part of 'add_comment_bloc.dart';

sealed class AddCommentState extends Equatable {
  const AddCommentState();

  @override
  List<Object> get props => [];
}

final class AddCommentInitialState extends AddCommentState {}

final class AddCommentErrorState extends AddCommentState {
  final AppException appException;

  const AddCommentErrorState({required this.appException});
}

final class AddCommentLoadingState extends AddCommentState {}

final class AddCommentSuccessState extends AddCommentState {
  final CommentEntity commentEntity;

  const AddCommentSuccessState({required this.commentEntity});
}
