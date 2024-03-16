import 'dart:math' as math;

import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/commons/widgets/button_widget.dart';
import 'package:VietQR/commons/widgets/dialog_widget.dart';
import 'package:VietQR/commons/widgets/textfield_widget.dart';
import 'package:VietQR/features/bank/widgets/select_bank_account.dart';
import 'package:VietQR/features/vhitek/blocs/vhitek_bloc.dart';
import 'package:VietQR/features/vhitek/events/vhitek_event.dart';
import 'package:VietQR/features/vhitek/provider/active_vhitek_provider.dart';
import 'package:VietQR/layouts/border_layout.dart';
import 'package:VietQR/layouts/box_layout.dart';
import 'package:VietQR/models/bank_account_dto.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ActiveVhitek extends StatefulWidget {
  final String mid;
  final Function(BankAccountDTO) callBack;

  final Function(String, String, String, BankAccountDTO) onChanged;

  const ActiveVhitek(
      {super.key,
      this.mid = '',
      required this.callBack,
      required this.onChanged});

  @override
  State<ActiveVhitek> createState() => _ActiveVhitekState();
}

class _ActiveVhitekState extends State<ActiveVhitek> {
  final codeController = TextEditingController();
  final addressController = TextEditingController();
  final emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.mid.isNotEmpty && widget.mid.length > 2) {
      codeController.text = widget.mid;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ActiveVhitekProvider>(
      builder: (context, provider, child) {
        return Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 32),
                        const Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Kết nối máy bán hàng',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ),
                        const SizedBox(height: 40),
                        const Text(
                          'Chọn tài khoản ngân hàng*',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Tài khoản ngân hàng được gắn với máy để tạo mã VietQR',
                          style: TextStyle(fontSize: 12),
                        ),
                        const SizedBox(height: 6),
                        _buildListBank(provider),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: () {
                            context.push('/add-bank/step1');
                          },
                          child: const Text(
                            'Liên kết tài khoản ngân hàng mới',
                            style: TextStyle(
                                color: AppColor.BLUE_TEXT,
                                decoration: TextDecoration.underline),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const SizedBox(height: 16),
                        const Text(
                          'Mã máy*',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Mã máy bán hàng được quét từ mã QR',
                          style: TextStyle(fontSize: 12),
                        ),
                        const SizedBox(height: 8),
                        BorderLayout(
                          height: 50,
                          isError: false,
                          borderColor: AppColor.WHITE,
                          bgColor: AppColor.WHITE,
                          child: TextFieldWidget(
                            isObscureText: false,
                            autoFocus: true,
                            hintText: 'Mã máy',
                            fontSize: 12,
                            maxLength: 50,
                            controller: codeController,
                            inputType: TextInputType.text,
                            keyboardAction: TextInputAction.next,
                            onSubmitted: (value) {},
                            onChange: (Object value) {
                              provider.changeMid(value.toString());
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Địa chỉ máy*',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Khách hàng nhập địa chỉ để phân biệt giữa các máy',
                          style: TextStyle(fontSize: 12),
                        ),
                        const SizedBox(height: 8),
                        BorderLayout(
                          height: 50,
                          isError: false,
                          borderColor: AppColor.WHITE,
                          bgColor: AppColor.WHITE,
                          child: TextFieldWidget(
                            isObscureText: false,
                            autoFocus: true,
                            hintText: 'Địa chỉ máy bán hàng',
                            fontSize: 12,
                            maxLength: 50,
                            controller: addressController,
                            inputType: TextInputType.text,
                            keyboardAction: TextInputAction.next,
                            onSubmitted: (value) {},
                            onChange: (value) {
                              provider.changeMidAddress(value.toString());
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Email*',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Nhập Email của bạn để kết nối máy bán hàng',
                          style: TextStyle(fontSize: 12),
                        ),
                        const SizedBox(height: 8),
                        BorderLayout(
                          height: 50,
                          isError: false,
                          borderColor: AppColor.WHITE,
                          bgColor: AppColor.WHITE,
                          child: TextFieldWidget(
                            isObscureText: false,
                            autoFocus: true,
                            hintText: 'youremail@gmail.com',
                            fontSize: 12,
                            maxLength: 50,
                            controller: emailController,
                            inputType: TextInputType.text,
                            keyboardAction: TextInputAction.next,
                            onSubmitted: (value) {},
                            onChange: (Object value) {
                              provider.changeEmail(value.toString());
                            },
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
                ButtonWidget(
                  text: 'Tiếp theo',
                  textColor: AppColor.WHITE,
                  borderRadius: 5,
                  bgColor: AppColor.BLUE_TEXT,
                  function: () => _onNext(provider),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onNext(ActiveVhitekProvider provider) {
    if (provider.bankAccountDTO.bankAccount.isEmpty) {
      DialogWidget.instance.openMsgDialog(
          title: 'Cảnh báo', msg: 'Vui lòng chọn tài khoản ngân hàng');
    } else if (provider.mid.isEmpty ||
        provider.midAddress.isEmpty ||
        provider.email.isEmpty) {
      DialogWidget.instance.openMsgDialog(
          title: 'Cảnh báo', msg: 'Vui lòng nhập đầy đủ thông tin trên form');
    } else {
      widget.onChanged(provider.mid, provider.midAddress, provider.email,
          provider.bankAccountDTO);
      context
          .read<VhitekBloc>()
          .add(CheckUserValidEvent(email: provider.email));
    }
  }

  Widget _buildListBank(ActiveVhitekProvider provider) {
    return InkWell(
      onTap: () async {
        await DialogWidget.instance.openPopup(
          child: SelectBankAccountWidget(
            provider: provider,
          ),
          width: 500,
          height: 500,
        );

        widget.callBack.call(provider.bankAccountDTO);
      },
      child: (provider.bankAccountDTO.bankCode.isEmpty)
          ? BoxLayout(
              bgColor: AppColor.WHITE,
              height: 50,
              borderRadius: 5,
              child: Row(
                children: [
                  const Text(
                    'Chọn tài khoản',
                    style: TextStyle(
                      fontSize: 13,
                    ),
                  ),
                  const Spacer(),
                  Transform.rotate(
                      angle: -math.pi / 2,
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 14,
                        color: AppColor.BLACK,
                      ))
                ],
              ),
            )
          : _buildSelectedBankType(
              provider.bankAccountDTO,
            ),
    );
  }

  Widget _buildSelectedBankType(BankAccountDTO dto) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColor.WHITE,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              border: Border.all(color: AppColor.GREY_BUTTON),
              borderRadius: BorderRadius.circular(30),
              image: DecorationImage(
                image: ImageUtils.instance.getImageNetWork(dto.imgId),
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.only(left: 16)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${dto.bankCode} - ${dto.bankAccount}',
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                      fontSize: 12,
                      color: AppColor.BLACK,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 2,
                ),
                Text(
                  dto.userBankName,
                  style: const TextStyle(
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_drop_down_circle_outlined,
            size: 12,
          ),
        ],
      ),
    );
  }
}
