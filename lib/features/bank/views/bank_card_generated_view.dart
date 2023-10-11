// ignore_for_file: prefer_const_literals_to_create_immutables, constant_identifier_names

import 'package:VietQR/commons/constants/configurations/stringify.dart';
import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/widgets/button_icon_widget.dart';
import 'package:VietQR/commons/widgets/viet_qr_widget.dart';
import 'package:VietQR/models/bank_account_dto.dart';
import 'package:VietQR/models/qr_generated_dto.dart';
import 'package:VietQR/services/providers/add_bank_provider.dart';
import 'package:VietQR/services/providers/bank_card_position_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart' as rive;

class BankCardGeneratedView extends StatefulWidget {
  final BankAccountDTO dto;
  final String qr;
  final String bankId;
  const BankCardGeneratedView(
      {super.key, required this.dto, this.qr = '', this.bankId = ''});

  @override
  State<StatefulWidget> createState() => _BankCardGeneratedView();
}

class _BankCardGeneratedView extends State<BankCardGeneratedView> {
  //animation
  late final rive.StateMachineController _riveController;
  late rive.SMITrigger _action;
  bool _isRiveInit = false;
  final BankCardPositionProvider _bankCardPositionProvider =
      BankCardPositionProvider(false);

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
    final double height = MediaQuery.of(context).size.height;

    QRGeneratedDTO qrGeneratedDTO = QRGeneratedDTO(
      bankCode: widget.dto.bankCode,
      bankName: widget.dto.bankName,
      bankAccount: widget.dto.bankAccount,
      userBankName: widget.dto.userBankName,
      amount: '',
      content: '',
      qrCode: widget.qr,
      imgId: widget.dto.imgId,
    );
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Thêm tài khoản thành công',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(15),
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: 30,
                  height: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Theme.of(context).cardColor),
                  child: const Icon(
                    Icons.close_rounded,
                    size: 15,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 150,
            child: rive.RiveAnimation.asset(
              'assets/rives/success_ani.riv',
              fit: BoxFit.fitWidth,
              antialiasing: false,
              animations: [Stringify.SUCCESS_ANI_INITIAL_STATE],
              onInit: _onRiveInit,
            ),
          ),
          ValueListenableBuilder(
              valueListenable: _bankCardPositionProvider,
              builder: (_, provider, child) {
                return AnimatedPositioned(
                  top: (provider == true) ? 50 : 150,
                  curve: Curves.easeInOut,
                  duration: const Duration(
                    milliseconds: 800,
                  ),
                  child: VietQRWidget(
                    width: width,
                    qrGeneratedDTO: qrGeneratedDTO,
                  ),
                  //  BankCardWidget(dto: dto, width: width * 0.9),
                );
              }),

          SizedBox(
              width: width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ButtonIconWidget(
                      height: 40,
                      icon: Icons.home_rounded,
                      title: 'Trang chủ',
                      textColor: AppColor.GREEN,
                      bgColor: AppColor.WHITE,
                      function: () {
                        _doEndAnimation();
                        Provider.of<AddBankProvider>(context, listen: false)
                            .reset();
                        Future.delayed(const Duration(milliseconds: 800), () {
                          Navigator.popUntil(context, (route) => route.isFirst);
                        });
                      },
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(left: 10)),
                  Expanded(
                    child: ButtonIconWidget(
                      height: 40,
                      icon: Icons.info_outline_rounded,
                      title: 'Chi tiết',
                      textColor: AppColor.WHITE,
                      bgColor: AppColor.GREEN,
                      function: () {
                        _doEndAnimation();
                        Provider.of<AddBankProvider>(context, listen: false)
                            .reset();
                        Future.delayed(const Duration(milliseconds: 800), () {
                          // Navigator.pushReplacementNamed(
                          //   context,
                          //   Routes.BANK_CARD_DETAIL_VEW,
                          //   arguments: {
                          //     'bankId': bankId,
                          //   },
                          // );
                        });
                      },
                    ),
                  ),
                ],
              )),
          //   const Padding(padding: EdgeInsets.only(bottom: 20)),
        ],
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
    _bankCardPositionProvider.transform();
    _action =
        _riveController.findInput<bool>(Stringify.SUCCESS_ANI_ACTION_DO_END)
            as rive.SMITrigger;
    _action.fire();
  }
}
