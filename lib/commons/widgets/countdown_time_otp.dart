import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:flutter/material.dart';

class CountDownTimeOtp extends StatefulWidget {
  const CountDownTimeOtp({
    Key? key,
    required this.secondsRemaining,
    required this.whenTimeExpires,
    required this.onResendOtp,
  }) : super(key: key);

  final int secondsRemaining;
  final VoidCallback whenTimeExpires;
  final VoidCallback onResendOtp;
  @override
  State createState() => _CountDownTimerState();
}

class _CountDownTimerState extends State<CountDownTimeOtp>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Duration duration;

  String get timerDisplayString {
    final duration = _controller.duration! * _controller.value;
    return '${duration.inSeconds}';
  }

  @override
  void initState() {
    super.initState();
    duration = Duration(seconds: widget.secondsRemaining);
    _controller = AnimationController(
      vsync: this,
      duration: duration,
    );
    _controller
      ..reverse(from: widget.secondsRemaining.toDouble())
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed ||
            status == AnimationStatus.dismissed) {
          widget.whenTimeExpires();
        }
      });
  }

  resetCountDown() {
    setState(() {
      duration = Duration(seconds: widget.secondsRemaining);
      _controller.dispose();
      _controller = AnimationController(
        vsync: this,
        duration: duration,
      );
      _controller
        ..reverse(from: widget.secondsRemaining.toDouble())
        ..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            widget.whenTimeExpires();
          }
        });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, Widget? child) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Mã OPT sẽ hết hạn sau ',
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style:
                        TextStyle(fontSize: 13, color: DefaultTheme.GREY_TEXT),
                  ),
                  Text(
                    timerDisplayString,
                    style: const TextStyle(
                      fontSize: 13,
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 5)),
                ],
              ),
              TextButton(
                  onPressed: () {
                    widget.onResendOtp();
                    resetCountDown();
                  },
                  child: const Text(
                    'Gửi lại OTP',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: DefaultTheme.GREEN,
                    ),
                  )),
            ],
          );
        },
      ),
    );
  }
}
