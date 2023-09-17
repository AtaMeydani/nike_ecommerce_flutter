import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_ecommerce_flutter/common/utils.dart';
import 'package:nike_ecommerce_flutter/data/order.dart';
import 'package:nike_ecommerce_flutter/data/product.dart';
import 'package:nike_ecommerce_flutter/data/repo/order_repository.dart';
import 'package:nike_ecommerce_flutter/ui/order/bloc/order_history_bloc.dart';
import 'package:nike_ecommerce_flutter/ui/product/product.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return BlocProvider<OrderHistoryBloc>(
      create: (context) {
        return OrderHistoryBloc(orderRepository: orderRepository)..add(OrderHistoryStartedEvent());
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('سوابق سفارش'),
        ),
        body: BlocBuilder<OrderHistoryBloc, OrderHistoryState>(
          builder: (context, state) {
            if (state is OrderHistorySuccessState) {
              final List<OrderEntity> orders = state.orders;

              return ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final OrderEntity orderEntity = orders[index];

                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: themeData.dividerColor,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('شناسه سفارش'),
                              Text(
                                orderEntity.id.toString(),
                              ),
                            ],
                          ),
                        ),
                        const Divider(
                          height: 1,
                        ),
                        Container(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('مبلغ'),
                              Text(
                                orderEntity.payablePrice.withPriceLabel,
                              ),
                            ],
                          ),
                        ),
                        const Divider(
                          height: 1,
                        ),
                        AspectRatio(
                          aspectRatio: 1.8,
                          child: ListView.builder(
                            physics: defaultScrollPhysics,
                            padding: const EdgeInsets.symmetric(horizontal: defaultHorizontalPadding),
                            scrollDirection: Axis.horizontal,
                            itemCount: orderEntity.products.length,
                            itemBuilder: (context, index) {
                              final ProductEntity productEntity = orderEntity.products[index];

                              return ProductItem(productEntity: productEntity);
                            },
                          ),
                        )
                      ],
                    ),
                  );
                },
              );
            } else if (state is OrderHistoryErrorState) {
              return Center(
                child: Text(state.appException.message),
              );
            } else if (state is OrderHistoryLoadingState) {
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            } else {
              throw Exception('invalid state');
            }
          },
        ),
      ),
    );
  }
}
