import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_ecommerce_flutter/common/utils.dart';
import 'package:nike_ecommerce_flutter/ui/product/comment/add/bloc/add_comment_bloc.dart';
import 'package:nike_ecommerce_flutter/ui/product/comment/comment_list.dart';

class AddCommentDialog extends StatefulWidget {
  final int productId;
  final ScaffoldMessengerState? scaffoldMessengerState;
  const AddCommentDialog({
    super.key,
    required this.productId,
    required this.scaffoldMessengerState,
  });

  @override
  State<AddCommentDialog> createState() => _AddCommentDialogState();
}

class _AddCommentDialogState extends State<AddCommentDialog> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  StreamSubscription<AddCommentState>? subscription;

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    return BlocProvider<AddCommentBloc>(
      create: (context) {
        final bloc = AddCommentBloc(commentRepository: commentRepository);
        subscription = bloc.stream.listen((state) {
          if (state is AddCommentSuccessState) {
            Navigator.of(context, rootNavigator: true).pop();
          } else if (state is AddCommentErrorState) {
            Navigator.of(context, rootNavigator: true).pop();
            widget.scaffoldMessengerState?.showSnackBar(SnackBar(content: Text(state.appException.message)));
          }
        });

        return bloc;
      },
      child: BlocBuilder<AddCommentBloc, AddCommentState>(
        builder: (context, state) {
          return Container(
            height: 300,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  'ثبت نظر',
                  style: themeData.textTheme.titleLarge,
                ),
                16.0.height,
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    label: Text('عنوان'),
                  ),
                ),
                8.0.height,
                TextField(
                  controller: _contentController,
                  decoration: const InputDecoration(
                    label: Text('متن نظر خود را اینجا وارد کنید'),
                  ),
                ),
                8.0.height,
                ElevatedButton(
                  onPressed: () {
                    context.read<AddCommentBloc>().add(
                          AddCommentFormSubmitEvent(
                            title: _titleController.text,
                            content: _contentController.text,
                            productId: widget.productId,
                          ),
                        );
                  },
                  style: const ButtonStyle(
                    minimumSize: MaterialStatePropertyAll(
                      Size.fromHeight(56),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (state is AddCommentLoadingState) const CupertinoActivityIndicator(),
                      const Text('ذخیره'),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    subscription?.cancel();
    super.dispose();
  }
}
