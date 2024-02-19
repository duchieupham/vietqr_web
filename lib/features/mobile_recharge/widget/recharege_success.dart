import 'package:VietQR/commons/constants/configurations/stringify.dart';
import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart' as rive;

class RechargeSuccess extends StatefulWidget {
  final String money;
  final String phoneNo;
  const RechargeSuccess({Key? key, required this.money, required this.phoneNo})
      : super(key: key);

  @override
  State<RechargeSuccess> createState() => _RechargeSuccessState();
}

class _RechargeSuccessState extends State<RechargeSuccess> {
  late final rive.StateMachineController _riveController;
  late rive.SMITrigger _action;
  bool _isRiveInit = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    if (_isRiveInit) {
      _riveController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 40,
            ),
            SizedBox(
              width: width * 0.6,
              height: 150,
              child: rive.RiveAnimation.asset(
                'assets/rives/success_ani.riv',
                fit: BoxFit.fitWidth,
                antialiasing: false,
                animations: const [Stringify.SUCCESS_ANI_INITIAL_STATE],
                onInit: _onRiveInit,
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  const Padding(padding: EdgeInsets.only(top: 20)),
                  const Text(
                    'Nạp điện thoại thành công',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      '+ ${widget.money} VND',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: AppColor.BLUE_TEXT,
                      ),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 20)),
                  Text(
                    'Quý khách đã nạp thành công số tiền +${widget.money} VND cho số điện thoại ${widget.phoneNo}. Cảm ơn quý khách đã sử dụng dịch vụ của VietQR VN',
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
            ButtonWidget(
                text: 'Trang chủ',
                textColor: AppColor.WHITE,
                bgColor: AppColor.BLUE_TEXT,
                function: () {
                  _doEndAnimation();

                  Future.delayed(const Duration(milliseconds: 500), () {
                    Navigator.of(context).pop();
                  });
                })
          ],
        ),
      ),
    );
  }

  //initial of animation
  _onRiveInit(rive.Artboard artboard) {
    _riveController = rive.StateMachineController.fromArtboard(
        artboard, Stringify.SUCCESS_ANI_STATE_MACHINE)!;
    artboard.addController(_riveController);
    _isRiveInit = true;
    _doInitAnimation();
  }

  void _doInitAnimation() {
    _action =
        _riveController.findInput<bool>(Stringify.SUCCESS_ANI_ACTION_DO_INIT)
            as rive.SMITrigger;
    _action.fire();
  }

  void _doEndAnimation() {
    _action =
        _riveController.findInput<bool>(Stringify.SUCCESS_ANI_ACTION_DO_END)
            as rive.SMITrigger;
    _action.fire();
  }
}
