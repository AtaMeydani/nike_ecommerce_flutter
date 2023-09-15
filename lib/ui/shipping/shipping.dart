import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nike_ecommerce_flutter/common/utils.dart';
import 'package:nike_ecommerce_flutter/data/cart_response.dart';
import 'package:nike_ecommerce_flutter/data/order.dart';
import 'package:nike_ecommerce_flutter/data/repo/order_repository.dart';
import 'package:nike_ecommerce_flutter/ui/cart/price_info.dart';
import 'package:nike_ecommerce_flutter/ui/receipt/payment_receipt.dart';
import 'package:nike_ecommerce_flutter/ui/shipping/bloc/shipping_bloc.dart';

class ShippingScreen extends StatefulWidget {
  final CartResponse cartResponse;
  const ShippingScreen({
    super.key,
    required this.cartResponse,
  });

  @override
  State<ShippingScreen> createState() => _ShippingScreenState();
}

class _ShippingScreenState extends State<ShippingScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  StreamSubscription<ShippingState>? _streamSubscription;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تحویل گریرنده'),
      ),
      body: BlocProvider<ShippingBloc>(
        create: (context) {
          final bloc = ShippingBloc(orderRepository: orderRepository);
          _streamSubscription = bloc.stream.listen(
            (state) {
              if (state is ShippingErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.appException.message)));
              } else if (state is ShippingSuccessState) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return const PaymentReceiptScreen();
                    },
                  ),
                );
              }
            },
          );
          return bloc;
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                controller: _firstNameController,
                decoration: const InputDecoration(
                  label: Text('نام'),
                ),
              ),
              16.0.height,
              TextField(
                controller: _lastNameController,
                decoration: const InputDecoration(
                  label: Text('نام خانوادگی'),
                ),
              ),
              16.0.height,
              TextField(
                controller: _postalCodeController,
                decoration: const InputDecoration(
                  label: Text('کد پستی'),
                ),
              ),
              16.0.height,
              TextField(
                controller: _mobileController,
                decoration: const InputDecoration(
                  label: Text('شماره تماس'),
                ),
              ),
              16.0.height,
              TextField(
                controller: _addressController,
                decoration: const InputDecoration(
                  label: Text('آدرس'),
                ),
              ),
              16.0.height,
              PriceInfo(cartResponse: widget.cartResponse),
              BlocBuilder<ShippingBloc, ShippingState>(
                builder: (context, state) {
                  if (state is ShippingLoadingState) {
                    return const Center(child: CupertinoActivityIndicator());
                  }
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          BlocProvider.of<ShippingBloc>(context).add(
                            ShippingCreateOrderEvent(
                              orderParams: OrderParams(
                                  firstName: _firstNameController.text,
                                  lastName: _lastNameController.text,
                                  mobile: _mobileController.text,
                                  postalCode: _postalCodeController.text,
                                  address: _addressController.text,
                                  paymentMethod: PaymentMethod.cash_on_delivery),
                            ),
                          );
                        },
                        child: const Text('پرداخت در محل'),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text('پرداخت اینترنتی'),
                      ),
                    ],
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _mobileController.dispose();
    _addressController.dispose();
    _postalCodeController.dispose();

    super.dispose();
  }
}
