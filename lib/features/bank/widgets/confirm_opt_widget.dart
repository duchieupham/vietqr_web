import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/widgets/button_widget.dart';
import 'package:VietQR/commons/widgets/textfield_widget.dart';
import 'package:VietQR/features/bank/blocs/bank_bloc.dart';
import 'package:VietQR/features/bank/events/bank_event.dart';
import 'package:VietQR/layouts/border_layout.dart';
import 'package:VietQR/models/bank_account_remove_dto.dart';
import 'package:VietQR/models/bank_card_request_otp.dart';
import 'package:VietQR/models/confirm_otp_bank_dto.dart';
import 'package:VietQR/services/providers/countdown_provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ConfirmOTPWidget extends StatefulWidget {
  final String requestId;
  final String phone;
  final String bankAccount;
  final BankBloc bankBloc;
  final BankCardRequestOTP? dto;
  final BankAccountUnlinkDTO? unlinkDTO;
  final bool isUnlink;
  const ConfirmOTPWidget({
    super.key,
    required this.requestId,
    required this.phone,
    required this.bankBloc,
    this.dto,
    this.bankAccount = '',
    this.unlinkDTO,
    this.isUnlink = false,
  });

  @override
  State<StatefulWidget> createState() => _ConfirmOTPWidget();
}

class _ConfirmOTPWidget extends State<ConfirmOTPWidget> {
  static final _formKey = GlobalKey<FormState>();
  static final TextEditingController otpController = TextEditingController();
  static late CountdownProvider countdownProvider;

  @override
  void initState() {
    super.initState();
    countdownProvider = CountdownProvider(120);
    countdownProvider.countDown();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Padding(padding: EdgeInsets.only(top: 20)),
        SizedBox(
          width: width,
          child: Row(
            children: [
              const Padding(padding: EdgeInsets.only(left: 20)),
              const Text(
                'Xác thực OTP',
                style: TextStyle(
                  fontSize: 15,
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
        Expanded(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              const Padding(padding: EdgeInsets.only(top: 10)),
              RichText(
                textAlign: TextAlign.left,
                text: TextSpan(
                  style: TextStyle(
                    color: Theme.of(context).hintColor,
                    fontSize: 13,
                  ),
                  children: [
                    const TextSpan(text: 'Mã OTP được gửi tới SĐT '),
                    TextSpan(
                      text: widget.phone,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const TextSpan(
                        text:
                            '. Vui lòng nhập mã để xác thực liên kết tài khoản ngân hàng.'),
                  ],
                ),
              ),
              //
              const Padding(padding: EdgeInsets.only(top: 30)),
              Form(
                key: _formKey,
                child: BorderLayout(
                  width: width,
                  height: 50,
                  isError: false,
                  child: TextFieldWidget(
                    titleWidth: 130,
                    width: width,
                    isObscureText: false,
                    hintText: 'Nhập mã OTP',
                    autoFocus: false,
                    fontSize: 15,
                    controller: otpController,
                    inputType: TextInputType.text,
                    keyboardAction: TextInputAction.done,
                    onChange: (text) {},
                  ),
                ),
              ),
            ],
          ),
        ),
        ValueListenableBuilder(
          valueListenable: countdownProvider,
          builder: (_, value, child) {
            return (value != 0)
                ? RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                        color: Theme.of(context).hintColor,
                        fontSize: 13,
                      ),
                      children: [
                        const TextSpan(text: 'Mã OTP có hiệu lực trong vòng '),
                        TextSpan(
                          text: value.toString(),
                          style: const TextStyle(color: AppColor.GREEN),
                        ),
                        const TextSpan(text: 's.'),
                      ],
                    ),
                  )
                : RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                        color: Theme.of(context).hintColor,
                        fontSize: 13,
                      ),
                      children: [
                        const TextSpan(text: 'Không nhận được mã OTP? '),
                        TextSpan(
                          text: 'Gửi lại',
                          style: const TextStyle(
                            decoration: TextDecoration.underline,
                            color: AppColor.GREEN,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              countdownProvider = CountdownProvider(120);
                              if (widget.dto != null) {
                                widget.bankBloc.add(
                                  BankEventRequestOTP(dto: widget.dto!),
                                );
                              }
                              if (widget.unlinkDTO != null) {
                                widget.bankBloc.add(
                                  BankEventUnlink(dto: widget.unlinkDTO!),
                                );
                              }

                              Navigator.pop(context);
                            },
                        ),
                      ],
                    ),
                  );
          },
        ),
        const Padding(padding: EdgeInsets.only(top: 10)),
        UnconstrainedBox(
          child: ButtonWidget(
            width: 300 - 40,
            height: 40,
            borderRadius: 5,
            text: 'Xác thực',
            textColor: AppColor.WHITE,
            bgColor: AppColor.GREEN,
            function: () {
              if (otpController.text.isNotEmpty) {
                Navigator.pop(context);
                ConfirmOTPBankDTO confirmDTO = ConfirmOTPBankDTO(
                  bankAccount: widget.bankAccount,
                  requestId: widget.requestId,
                  otpValue: otpController.text,
                  applicationType: 'WEB_APP',
                );
                if (widget.isUnlink) {
                  widget.bankBloc
                      .add(BankEventConfirmUnlinkOTP(dto: confirmDTO));
                } else {
                  widget.bankBloc.add(BankEventConfirmOTP(dto: confirmDTO));
                }
                otpController.clear();
              }
            },
          ),
        ),
        const Padding(padding: EdgeInsets.only(bottom: 20)),
      ],
    );
  }
}
