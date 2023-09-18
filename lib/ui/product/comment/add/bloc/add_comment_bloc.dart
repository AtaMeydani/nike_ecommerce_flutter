import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:nike_ecommerce_flutter/common/exceptions.dart';
import 'package:nike_ecommerce_flutter/data/comment.dart';
import 'package:nike_ecommerce_flutter/data/repo/auth_repository.dart';
import 'package:nike_ecommerce_flutter/data/repo/comment_repository.dart';

part 'add_comment_event.dart';
part 'add_comment_state.dart';

class AddCommentBloc extends Bloc<AddCommentEvent, AddCommentState> {
  final ICommentRepository commentRepository;

  AddCommentBloc({required this.commentRepository}) : super(AddCommentInitialState()) {
    on<AddCommentEvent>((event, emit) async {
      if (event is AddCommentFormSubmitEvent) {
        if (event.title.isNotEmpty && event.title.isNotEmpty) {
          if (!AuthRepository.isUserLoggedIn()) {
            emit(AddCommentErrorState(appException: AppException(message: 'لطفا وارد حساب کاربری خود شوید')));
          } else {
            emit(AddCommentLoadingState());
            try {
              CommentEntity commentEntity =
                  await commentRepository.add(title: event.title, content: event.content, productId: event.productId);
              emit(AddCommentSuccessState(commentEntity: commentEntity));
            } catch (e) {
              emit(AddCommentErrorState(appException: e is AppException ? e : AppException()));
            }
          }
        } else {
          emit(AddCommentErrorState(appException: AppException(message: 'عنوان و متن نظر خود را وارد کنید')));
        }
      }
    });
  }
}
