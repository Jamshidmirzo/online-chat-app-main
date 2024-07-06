import 'package:flutter/material.dart';

extension SizedBoxExtension on int {
  Widget height() => SizedBox(height: toDouble());
  Widget width() => SizedBox(width: toDouble());
}
