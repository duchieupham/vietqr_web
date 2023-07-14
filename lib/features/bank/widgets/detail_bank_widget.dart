import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/enums/event_type.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/commons/widgets/button_icon_widget.dart';
import 'package:VietQR/commons/widgets/button_widget.dart';
import 'package:VietQR/commons/widgets/dialog_widget.dart';
import 'package:VietQR/commons/widgets/divider_widget.dart';
import 'package:VietQR/commons/widgets/viet_qr_widget.dart';
import 'package:VietQR/features/bank/blocs/bank_bloc.dart';
import 'package:VietQR/features/bank/events/bank_event.dart';
import 'package:VietQR/features/bank/states/bank_state.dart';
import 'package:VietQR/features/bank/views/link_card_view.dart';
import 'package:VietQR/features/bank/widgets/confirm_opt_widget.dart';
import 'package:VietQR/models/account_bank_detail_dto.dart';
import 'package:VietQR/models/bank_account_remove_dto.dart';
import 'package:VietQR/models/bank_card_request_otp.dart';
import 'package:VietQR/models/bank_type_dto.dart';
import 'package:VietQR/models/qr_generated_dto.dart';
import 'package:VietQR/services/providers/add_bank_provider.dart';
import 'package:VietQR/services/shared_references/session.dart';
import 'package:VietQR/services/shared_references/user_information_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class BankDetailWidget extends StatelessWidget {
  final AccountBankDetailDTO accountBankDetailDTO;
  final QRGeneratedDTO qrGeneratedDTO;
  final BankBloc bankBloc;

  const BankDetailWidget({
    super.key,
    required this.accountBankDetailDTO,
    required this.qrGeneratedDTO,
    required this.bankBloc,
  });

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return BlocConsumer<BankBloc, BankState>(listener: (context, state) {
      if (state is BankUnlinkLoadingState ||
          state is BankConfirmOTPLoadingState) {
        DialogWidget.instance.openLoadingDialog();
      }

      if (state is BankUnlinkSuccessState) {
        Navigator.pop(context);
        DialogWidget.instance.openPopup(
            width: 300,
            height: 400,
            child: ConfirmOTPWidget(
              requestId: state.requestId,
              bankAccount: accountBankDetailDTO.bankAccount,
              phone: accountBankDetailDTO.phoneAuthenticated,
              bankBloc: context.read<BankBloc>(),
              isUnlink: true,
              unlinkDTO: state.dto,
            ));
      }
      if (state is BankUnlinkFailedState) {
        Navigator.pop(context);
        DialogWidget.instance.openMsgDialog(
          title: 'Lỗi',
          msg: state.msg,
        );
      }
      if (state is BankConfirmOTPSuccessState) {
        Navigator.pop(context);
        Session.instance.sendEvent(EventTypes.refreshListAccountBank);
        Navigator.pop(context);
      }
      if (state is BankConfirmOTPFailedState) {
        Navigator.pop(context);
        DialogWidget.instance.openMsgDialog(
          title: 'Lỗi',
          msg: state.message,
        );
      }
    }, builder: (context, state) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Padding(padding: EdgeInsets.only(top: 20)),
          SizedBox(
            width: width,
            child: Row(
              children: [
                const Padding(padding: EdgeInsets.only(left: 20)),
                const Text(
                  'Chi tiết TK ngân hàng',
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
          const Padding(padding: EdgeInsets.only(top: 10)),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(padding: EdgeInsets.only(left: 20)),
                Expanded(
                  child: Column(
                    children: [
                      const Padding(padding: EdgeInsets.only(top: 30)),
                      _buildElement(
                        context: context,
                        width: width,
                        title: 'Ngân hàng',
                        imgId: accountBankDetailDTO.imgId,
                        description:
                            '${accountBankDetailDTO.bankCode} - ${accountBankDetailDTO.bankName}',
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: DividerWidget(width: width),
                      ),
                      _buildElement(
                        context: context,
                        width: width,
                        title: 'Tài khoản',
                        description: accountBankDetailDTO.bankAccount,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: DividerWidget(width: width),
                      ),
                      _buildElement(
                        context: context,
                        width: width,
                        title: 'Chủ thẻ',
                        description: accountBankDetailDTO.userBankName,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: DividerWidget(width: width),
                      ),
                      _buildElement(
                        context: context,
                        width: width,
                        title: 'Trạng thái',
                        isAuthenticated: accountBankDetailDTO.authenticated,
                        description: (accountBankDetailDTO.authenticated)
                            ? 'Đã liên kết'
                            : 'Chưa liên kết',
                      ),
                      if (!accountBankDetailDTO.authenticated &&
                          accountBankDetailDTO.bankCode.trim().toUpperCase() ==
                              'MB') ...[
                        const Padding(padding: EdgeInsets.only(top: 10)),
                        const Text(
                          'Liên kết TK ngân hàng để nhận thông báo biến động số dư',
                          style: TextStyle(
                            // fontSize: 12,
                            color: DefaultTheme.GREY_TEXT,
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(top: 10)),
                        DividerWidget(width: width),
                      ],
                      if (accountBankDetailDTO.nationalId.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: DividerWidget(width: width),
                        ),
                        _buildElement(
                          context: context,
                          width: width,
                          title: 'CCCD/CMT',
                          description: accountBankDetailDTO.nationalId,
                        ),
                      ],
                      if (accountBankDetailDTO
                          .phoneAuthenticated.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: DividerWidget(width: width),
                        ),
                        _buildElement(
                          context: context,
                          width: width,
                          title: 'SĐT xác thực',
                          description: accountBankDetailDTO.phoneAuthenticated,
                        ),
                      ],
                      const Spacer(),
                      if (accountBankDetailDTO.userId ==
                          UserInformationHelper.instance.getUserId())
                        SizedBox(
                          width: width,
                          child: Row(
                            children: [
                              Tooltip(
                                message: 'Xoá tài khoản',
                                child: ButtonIconWidget(
                                  width: 150,
                                  height: 40,
                                  textColor: DefaultTheme.RED_TEXT,
                                  icon: Icons.delete_rounded,
                                  title: 'Xoá tài khoản',
                                  bgColor: Theme.of(context).canvasColor,
                                  function: () {
                                    if (accountBankDetailDTO.authenticated) {
                                      DialogWidget.instance.openMsgDialog(
                                        title: 'Bạn đang xoá tài khoản',
                                        msg:
                                            'Vui lòng Huỷ liên kết TK ngân hàng trước khi xoá',
                                      );
                                    } else {
                                      BankAccountRemoveDTO
                                          bankAccountRemoveDTO =
                                          BankAccountRemoveDTO(
                                        bankId: accountBankDetailDTO.id,
                                        type: accountBankDetailDTO.type,
                                        isAuthenticated:
                                            accountBankDetailDTO.authenticated,
                                      );
                                      DialogWidget.instance.openMsgDialogQuestion(
                                          title: 'Bạn đang xoá tài khoản',
                                          msg: 'Bạn có chắc chắn muốn xoá tài khoản này?',
                                          onConfirm: () {
                                            Navigator.pop(context);
                                            bankBloc.add(BankEventRemove(
                                                dto: bankAccountRemoveDTO));
                                          });
                                    }
                                  },
                                ),
                              ),
                              if (accountBankDetailDTO.authenticated) ...[
                                const Padding(
                                    padding: EdgeInsets.only(left: 10)),
                                Tooltip(
                                  message: 'Huỷ liên kết',
                                  child: ButtonIconWidget(
                                    width: 150,
                                    height: 40,
                                    textColor: DefaultTheme.RED_TEXT,
                                    icon: Icons.remove_circle_rounded,
                                    title: 'Huỷ liên kết',
                                    bgColor: Theme.of(context).canvasColor,
                                    function: () {
                                      DialogWidget.instance.openMsgDialogQuestion(
                                          title: 'Huỷ liên kết',
                                          msg: 'Bạn có chắc chắn muốn huỷ liên kết?',
                                          onConfirm: () {
                                            BankAccountUnlinkDTO
                                                bankAccountUnlinkDTO;
                                            bankAccountUnlinkDTO =
                                                BankAccountUnlinkDTO(
                                              accountNumber:
                                                  accountBankDetailDTO
                                                      .bankAccount,
                                              applicationType: 'WEB_APP',
                                            );

                                            bankBloc.add(BankEventUnlink(
                                                dto: bankAccountUnlinkDTO));
                                            Navigator.pop(context);
                                          });
                                    },
                                  ),
                                ),
                              ],
                              if (!accountBankDetailDTO.authenticated) ...[
                                const Padding(
                                    padding: EdgeInsets.only(left: 10)),
                                Tooltip(
                                  message: 'Liên kết ngay',
                                  child: ButtonWidget(
                                    width: 150,
                                    height: 40,
                                    textColor: DefaultTheme.WHITE,
                                    bgColor: DefaultTheme.GREEN,
                                    borderRadius: 5,
                                    function: () {
                                      BankTypeDTO bankTypeDTO = BankTypeDTO(
                                          id: accountBankDetailDTO.bankTypeId,
                                          bankCode:
                                              accountBankDetailDTO.bankCode,
                                          bankName:
                                              accountBankDetailDTO.bankName,
                                          imageId: accountBankDetailDTO.imgId,
                                          status: accountBankDetailDTO
                                              .bankTypeStatus,
                                          caiValue:
                                              accountBankDetailDTO.caiValue,
                                          bankShortName:
                                              accountBankDetailDTO.bankName);
                                      Provider.of<AddBankProvider>(context,
                                              listen: false)
                                          .updateBankId(
                                              accountBankDetailDTO.id);
                                      Provider.of<AddBankProvider>(context,
                                              listen: false)
                                          .updateSelect(2);
                                      Provider.of<AddBankProvider>(context,
                                              listen: false)
                                          .updateRegisterAuthentication(true);
                                      Provider.of<AddBankProvider>(context,
                                              listen: false)
                                          .updateSelectBankType(bankTypeDTO);
                                      DialogWidget.instance.openPopup(
                                        barrierColor: Colors.transparent,
                                        child: AddBankCardView(
                                          bankAccount:
                                              accountBankDetailDTO.bankAccount,
                                          userBankName:
                                              accountBankDetailDTO.userBankName,
                                        ),
                                        height: height * 0.7,
                                        width: 760,
                                      );
                                    },
                                    text: 'Liên kết ngay',
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      const Padding(padding: EdgeInsets.only(bottom: 20)),
                    ],
                  ),
                ),
                const Padding(padding: EdgeInsets.only(left: 30)),
                VietQRWidget(
                  width: 350,
                  qrGeneratedDTO: qrGeneratedDTO,
                  showQROnly: true,
                ),
                const Padding(padding: EdgeInsets.only(right: 20)),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _buildElement({
    required BuildContext context,
    required double width,
    required String title,
    required String description,
    bool? isAuthenticated,
    String? imgId,
  }) {
    return SizedBox(
      width: width,
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 13,
              ),
            ),
          ),
          const Spacer(),
          if (isAuthenticated != null) ...[
            Icon(
              (isAuthenticated)
                  ? Icons.check_rounded
                  : Icons.pending_actions_rounded,
              size: 15,
              color: (isAuthenticated)
                  ? DefaultTheme.BLUE_TEXT
                  : DefaultTheme.ORANGE,
            ),
            const Padding(padding: EdgeInsets.only(left: 10)),
          ],
          if (imgId != null && imgId.trim().isNotEmpty) ...[
            Container(
              width: 60,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: DefaultTheme.WHITE,
                image: DecorationImage(
                  fit: BoxFit.contain,
                  image: ImageUtils.instance.getImageNetWork(imgId),
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.only(left: 10)),
          ],
          Text(
            description,
            textAlign: TextAlign.right,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13,
              color: (isAuthenticated != null && isAuthenticated)
                  ? DefaultTheme.BLUE_TEXT
                  : (isAuthenticated != null && !isAuthenticated)
                      ? DefaultTheme.ORANGE
                      : Theme.of(context).hintColor,
            ),
          ),
        ],
      ),
    );
  }
}
