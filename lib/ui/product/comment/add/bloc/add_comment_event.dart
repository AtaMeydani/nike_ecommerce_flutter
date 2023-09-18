part of 'add_comment_bloc.dart';

sealed class AddCommentEvent extends Equatable {
  const AddCommentEvent();

  @override
  List<Object> get props => [];
}

class AddCommentFormSubmitEvent extends AddCommentEvent {
  final String title;
  final String content;
  final int productId;

  const AddCommentFormSubmitEvent({required this.title, required this.content, required this.productId});

  @override
  List<Object> get props => [title, content, productId];
}
