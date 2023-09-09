import 'package:flutter/material.dart';

const defaultScrollPhysics = BouncingScrollPhysics();
const double defaultHorizontalPadding = 12.0;

extension PriceLabel on int {
  String get withPriceLabel => '$this تومان';
}
