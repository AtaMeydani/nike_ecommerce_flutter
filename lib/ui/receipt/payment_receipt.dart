import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_ecommerce_flutter/common/utils.dart';
import 'package:nike_ecommerce_flutter/data/repo/order_repository.dart';
import 'package:nike_ecommerce_flutter/ui/receipt/bloc/payment_receipt_bloc.dart';

class PaymentReceiptScreen extends StatelessWidget {
  final int orderId;
  const PaymentReceiptScreen({
    super.key,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('رسید پرداخت'),
      ),
      body: BlocProvider(
        create: (context) {
          return PaymentReceiptBloc(orderRepository: orderRepository)
            ..add(
              PaymentReceiptStartedEvent(orderId: orderId),
            );
        },
        child: BlocBuilder<PaymentReceiptBloc, PaymentReceiptState>(
          builder: (context, state) {
            if (state is PaymentReceiptLoadingState) {
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            } else if (state is PaymentReceiptErrorState) {
              return Center(
                child: Text(state.appException.message),
              );
            } else if (state is PaymentReceiptSuccessState) {
              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: themeData.dividerColor, width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Text(
                          state.paymentReceipt.purchaseSuccess == true ? 'پرداخت با موفقیت انجام شد' : 'پرداخت ناموفق',
                          style: themeData.textTheme.titleLarge!.copyWith(
                            color: themeData.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'وضعیت سفارش',
                              style: TextStyle(
                                color: themeData.colorScheme.secondary,
                              ),
                            ),
                            Text(
                              state.paymentReceipt.paymentStatus,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const Divider(
                          height: 32,
                          thickness: 1,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'مبلغ',
                              style: TextStyle(
                                color: themeData.colorScheme.secondary,
                              ),
                            ),
                            Text(
                              state.paymentReceipt.payablePrice.withPriceLabel,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    child: Text('بازگشت به صفحه اصلی'),
                  ),
                ],
              );
            } else {
              throw Exception('state is not supported');
            }
          },
        ),
      ),
    );
  }
}
