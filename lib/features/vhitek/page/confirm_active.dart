import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/widgets/button_widget.dart';
import 'package:VietQR/commons/widgets/divider_widget.dart';
import 'package:VietQR/features/vhitek/blocs/vhitek_bloc.dart';
import 'package:VietQR/features/vhitek/events/vhitek_event.dart';
import 'package:VietQR/features/vhitek/provider/active_vhitek_provider.dart';
import 'package:VietQR/models/bank_account_dto.dart';
import 'package:VietQR/services/shared_references/user_information_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConfirmActive extends StatefulWidget {
  final Function(int) edit;
  final String mid;
  final String midAddress;
  final String email;
  final String userIdVhitek;
  final BankAccountDTO dto;

  const ConfirmActive(
      {super.key,
      required this.edit,
      required this.mid,
      required this.userIdVhitek,
      required this.midAddress,
      required this.email,
      required this.dto});

  @override
  State<ConfirmActive> createState() => _ConfirmActiveState();
}

class _ConfirmActiveState extends State<ConfirmActive> {
  String get userId => UserInformationHelper.instance.getUserId().trim();

  @override
  Widget build(BuildContext context) {
    return Consumer<ActiveVhitekProvider>(
      builder: (context, provider, child) {
        return Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 32,
                    ),
                    const Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Xác nhận kết nối máy bán hàng',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColor.WHITE,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Column(
                        children: [
                          _buildItemInfo('Mã vạch máy', widget.mid),
                          DividerWidget(
                            width: double.infinity,
                            color: AppColor.BLACK_BUTTON.withOpacity(0.2),
                          ),
                          _buildItemInfo('Tk ngân hàng',
                              '${widget.dto.bankAccount} - ${widget.dto.bankCode} '),
                          DividerWidget(
                            width: double.infinity,
                            color: AppColor.BLACK_BUTTON.withOpacity(0.2),
                          ),
                          _buildItemInfo('Định danh máy', widget.midAddress),
                          DividerWidget(
                            width: double.infinity,
                            color: AppColor.BLACK_BUTTON.withOpacity(0.2),
                          ),
                          _buildItemInfo('Email', widget.email),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () => widget.edit(0),
                      child: const Text(
                        'Chỉnh sửa thông tin',
                        style: TextStyle(
                            color: AppColor.BLUE_TEXT,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            ButtonWidget(
                text: 'Kích hoạt',
                textColor: AppColor.WHITE,
                borderRadius: 5,
                bgColor: AppColor.BLUE_TEXT,
                function: () {
                  Map<String, dynamic> param = {};
                  param['userId'] = userId;
                  param['mid'] = widget.mid;
                  param['address'] = widget.midAddress;
                  param['userIdVhitek'] = widget.userIdVhitek;
                  param['bankAccount'] = widget.dto.bankAccount;
                  param['userBankName'] = widget.dto.userBankName;
                  param['bankId'] = widget.dto.bankId;
                  print(
                      '-------------------------------------${provider.bankAccountDTO.toJson()}');
                  context.read<VhitekBloc>().add(ActiveEvent(param: param));
                })
          ],
        );
      },
    );
  }

  Widget _buildItemInfo(String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        height: 50,
        child: Row(
          children: [
            Text(title),
            const Spacer(),
            Text(
              content,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
