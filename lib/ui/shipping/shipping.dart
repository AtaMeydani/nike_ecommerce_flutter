import 'package:flutter/material.dart';
import 'package:nike_ecommerce_flutter/data/cart_response.dart';
import 'package:nike_ecommerce_flutter/ui/cart/price_info.dart';
import 'package:nike_ecommerce_flutter/ui/receipt/payment_receipt.dart';

class ShippingScreen extends StatelessWidget {
  final CartResponse cartResponse;
  const ShippingScreen({
    super.key,
    required this.cartResponse,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تحویل گریرنده'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                label: Text('نام و نام خانوادگی'),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            TextField(
              decoration: InputDecoration(
                label: Text('کد پستی'),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            TextField(
              decoration: InputDecoration(
                label: Text('شماره تماس'),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            TextField(
              decoration: InputDecoration(
                label: Text('آدرس'),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            PriceInfo(cartResponse: cartResponse),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return const PaymentReceiptScreen();
                        },
                      ),
                    );
                  },
                  child: Text('پرداخت در محل'),
                ),
                const SizedBox(
                  width: 16,
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('پرداخت اینترنتی'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
