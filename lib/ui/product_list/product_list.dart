import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_ecommerce_flutter/common/utils.dart';
import 'package:nike_ecommerce_flutter/data/product.dart';
import 'package:nike_ecommerce_flutter/ui/home/home.dart';
import 'package:nike_ecommerce_flutter/ui/product/product.dart';
import 'package:nike_ecommerce_flutter/ui/product_list/bloc/product_list_bloc.dart';

class ProductListScreen extends StatefulWidget {
  final int sort;
  final String searchTerm;

  const ProductListScreen({
    super.key,
    required this.sort,
    this.searchTerm = '',
  });

  const ProductListScreen.search({
    super.key,
    required this.searchTerm,
    this.sort = ProductSort.popular,
  });

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late final ProductListBloc productListBloc;
  ViewType _viewType = ViewType.grid;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(widget.searchTerm.isEmpty ? 'کفش های ورزشی' : 'نتایج جستجو ${widget.searchTerm}')),
      body: BlocProvider<ProductListBloc>(
        create: (context) {
          productListBloc = ProductListBloc(productRepository: productRepository)
            ..add(
              ProductListStartedEvent(sort: widget.sort, searchTerm: widget.searchTerm),
            );

          return productListBloc;
        },
        child: BlocBuilder<ProductListBloc, ProductListState>(builder: (context, state) {
          if (state is ProductListSuccessState) {
            return Column(
              children: [
                if (widget.searchTerm.isEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: themeData.colorScheme.onSurface),
                      ),
                      color: themeData.colorScheme.surface,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 20,
                          color: themeData.colorScheme.shadow.withOpacity(0.2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(32),
                                      ),
                                    ),
                                    context: context,
                                    builder: (context) {
                                      return Column(
                                        children: [
                                          Text(
                                            'انتخاب مرتب سازی',
                                            style: themeData.textTheme.titleLarge,
                                          ),
                                          Expanded(
                                            child: ListView.builder(
                                              itemCount: ProductSort.names.length,
                                              itemBuilder: (context, index) {
                                                return InkWell(
                                                  onTap: () {
                                                    productListBloc.add(
                                                      ProductListStartedEvent(
                                                        sort: index,
                                                        searchTerm: widget.searchTerm,
                                                      ),
                                                    );
                                                    Navigator.pop(context);
                                                  },
                                                  child: Container(
                                                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                                    height: 32,
                                                    child: Row(
                                                      children: [
                                                        Text(ProductSort.names[index]),
                                                        8.0.width,
                                                        if (state.sort == index)
                                                          const Icon(CupertinoIcons.check_mark_circled_solid),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          )
                                        ],
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(
                                  CupertinoIcons.sort_down,
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('مرتب سازی'),
                                  Text(
                                    ProductSort.names[state.sort],
                                    style: themeData.textTheme.bodySmall,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _viewType = _viewType == ViewType.grid ? ViewType.list : ViewType.grid;
                            });
                          },
                          icon: const Icon(
                            CupertinoIcons.square_grid_2x2,
                          ),
                        )
                      ],
                    ),
                  ),
                Expanded(
                  child: GridView.builder(
                    itemCount: state.products.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: _viewType == ViewType.grid ? 2 : 1,
                    ),
                    itemBuilder: (context, index) {
                      return ProductItem(
                        productEntity: state.products[index],
                      );
                    },
                  ),
                ),
              ],
            );
          } else if (state is ProductListLoadingState) {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          } else if (state is ProductListErrorState) {
            return Center(
              child: Text(state.appException.message),
            );
          } else if (state is ProductListEmptyState) {
            return Center(
              child: Text(state.message),
            );
          } else {
            throw Exception('invalid state');
          }
        }),
      ),
    );
  }

  @override
  void dispose() {
    productListBloc.close();
    super.dispose();
  }
}

enum ViewType {
  grid,
  list,
}
