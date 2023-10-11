import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/services/providers/card_number_login_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginByCardWidget extends StatelessWidget {
  final CardNumberLoginProvider _cardNumberLoginProvider =
      CardNumberLoginProvider('');
  final Duration _duration = const Duration(milliseconds: 300);

  String _vietQRId = '';

  LoginByCardWidget({super.key});

  void initialServices(BuildContext context) {
    // _focusNode.requestFocus();
    RawKeyboard.instance.addListener((RawKeyEvent event) {
      _vietQRId += event.character ?? '';
      if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
        _cardNumberLoginProvider.updateCardNumber(_vietQRId);
        Future.delayed(_duration, () {
          Navigator.pop(context, _vietQRId);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    initialServices(context);
    return Column(
      children: [
        const Padding(padding: EdgeInsets.only(top: 20)),
        SizedBox(
          width: width,
          child: Row(
            children: [
              const Padding(padding: EdgeInsets.only(left: 25)),
              const Spacer(),
              const Text(
                'VietQR ID Card',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: 25,
                  height: 25,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Theme.of(context).canvasColor.withOpacity(0.3),
                  ),
                  child: const Icon(
                    Icons.close_rounded,
                    size: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Padding(padding: EdgeInsets.only(bottom: 50)),
        Image.asset(
          'assets/images/ic-card-nfc.png',
          width: 200,
          height: 200,
        ),
        const Spacer(),
        ValueListenableBuilder(
          valueListenable: _cardNumberLoginProvider,
          builder: (_, value, child) {
            return (value.toString().isNotEmpty)
                ? Container(
                    width: width,
                    height: 10,
                    alignment: Alignment.center,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: value.toString().length,
                      itemBuilder: (context, index) => Container(
                        width: 10,
                        height: 10,
                        margin: const EdgeInsets.symmetric(horizontal: 2.5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColor.GREY_TEXT,
                        ),
                      ),
                    ),
                  )
                : const SizedBox();
          },
        ),
        const Spacer(),
        const Text(
          'Quét thẻ VietQR ID để đăng nhập',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        const Padding(padding: EdgeInsets.only(bottom: 30)),
      ],
    );
  }
}
