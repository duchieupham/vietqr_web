import 'dart:async';

import 'package:VietQR/commons/utils/time_utils.dart';
import 'package:flutter/material.dart';

class ClockProvider extends ValueNotifier {
  ClockProvider(super.value);

  void getRealTime() {
    Timer.periodic(const Duration(seconds: 1),
        (Timer t) => value = TimeUtils.instance.getRealTime());
  }
}
