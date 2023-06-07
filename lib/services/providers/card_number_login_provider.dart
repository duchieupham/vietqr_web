import 'package:flutter/material.dart';

class CardNumberLoginProvider extends ValueNotifier {
  CardNumberLoginProvider(super.value);

  void updateCardNumber(String text) {
    value = text;
  }
}
