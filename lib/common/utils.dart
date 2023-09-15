import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const defaultScrollPhysics = BouncingScrollPhysics();
const double defaultHorizontalPadding = 12.0;

extension PriceLabel on int {
  String get withPriceLabel => this > 0 ? '$separateByComma تومان' : 'رایگان';

  String get separateByComma {
    final numberFormat = NumberFormat.decimalPattern();
    return numberFormat.format(this);
  }
}

extension SizedBoxWidget on double {
  Widget get height {
    return SizedBox(
      height: this,
    );
  }

  Widget get width {
    return SizedBox(
      width: this,
    );
  }
}
