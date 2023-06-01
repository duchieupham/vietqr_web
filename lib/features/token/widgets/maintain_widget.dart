import 'package:VietQR/commons/widgets/button_icon_widget.dart';
import 'package:VietQR/features/token/blocs/token_bloc.dart';
import 'package:VietQR/features/token/events/token_event.dart';
import 'package:flutter/material.dart';

class MaintainWidget extends StatelessWidget {
  final double width;
  final double height;
  final TokenBloc tokenBloc;

  const MaintainWidget({
    super.key,
    required this.width,
    required this.height,
    required this.tokenBloc,
  });

  @override
  Widget build(BuildContext context) {
    // final double width = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Spacer(),
        SizedBox(
          width: width * 0.4,
          child: Image.asset(
            'assets/images/ic-maintain.png',
          ),
        ),
        const Text(
          'Hệ thống đang bảo trì',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Padding(padding: EdgeInsets.only(bottom: 10)),
        SizedBox(
          width: width * 0.6,
          child: const Text(
            'Chúng tôi đang thực hiện việc bảo trì hệ thống. Vui lòng thử lại trong một vài phút.',
            textAlign: TextAlign.center,
          ),
        ),
        const Spacer(),
        ButtonIconWidget(
          width: width * 0.8,
          height: 40,
          icon: Icons.refresh_rounded,
          title: 'Thử lại',
          function: () {
            tokenBloc.add(const TokenEventCheckValid());
            Navigator.pop(context);
          },
          bgColor: Theme.of(context).canvasColor,
          textColor: Theme.of(context).hintColor,
        ),
        const Padding(
          padding: EdgeInsets.only(bottom: 30),
        ),
      ],
    );
  }
}
