import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_ecommerce_flutter/data/product.dart';
import 'package:nike_ecommerce_flutter/ui/home/home.dart';
import 'package:nike_ecommerce_flutter/ui/product/product.dart';
import 'package:nike_ecommerce_flutter/ui/product_list/bloc/product_list_bloc.dart';

class ProductListScreen extends StatelessWidget {
  final int sort;
  const ProductListScreen({
    super.key,
    required this.sort,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('کفش های ورزشی'),
      ),
      body: BlocProvider<ProductListBloc>(
        create: (context) {
          return ProductListBloc(productRepository: productRepository)
            ..add(
              ProductListStartedEvent(sort: sort),
            );
        },
        child: BlocBuilder<ProductListBloc, ProductListState>(builder: (context, state) {
          if (state is ProductListSuccessState) {
            return GridView.builder(
              itemCount: state.products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemBuilder: (context, index) {
                return ProductItem(
                  productEntity: state.products[index],
                  borderRadius: BorderRadius.zero,
                );
              },
            );
          } else if (state is ProductListLoadingState) {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          } else if (state is ProductListErrorState) {
            return Center(
              child: Text(state.appException.message),
            );
          } else {
            throw Exception('invalid state');
          }
        }),
      ),
    );
  }
}
