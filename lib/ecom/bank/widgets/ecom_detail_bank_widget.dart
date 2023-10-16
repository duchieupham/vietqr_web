import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/commons/widgets/button_icon_widget.dart';
import 'package:VietQR/commons/widgets/dialog_widget.dart';
import 'package:VietQR/commons/widgets/divider_widget.dart';
import 'package:VietQR/commons/widgets/viet_qr_widget.dart';
import 'package:VietQR/models/account_bank_detail_dto.dart';
import 'package:VietQR/models/qr_generated_dto.dart';
import 'package:flutter/material.dart';

class BankDetailWidget extends StatelessWidget {
  final AccountBankDetailDTO accountBankDetailDTO;
  final QRGeneratedDTO qrGeneratedDTO;

  const BankDetailWidget({
    super.key,
    required this.accountBankDetailDTO,
    required this.qrGeneratedDTO,
  });

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
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
                          color: AppColor.GREY_TEXT,
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 10)),
                      DividerWidget(width: width),
                      ButtonIconWidget(
                        width: width,
                        height: 40,
                        icon: Icons.link_rounded,
                        title: 'Liên kết ngay',
                        function: () {
                          // BankTypeDTO bankTypeDTO = BankTypeDTO(
                          //   id: qrGeneratedDTO.bankTypeId,
                          //   bankCode: qrGeneratedDTO.bankCode,
                          //   bankName: qrGeneratedDTO.bankName,
                          //   imageId: qrGeneratedDTO.imgId,
                          //   status: qrGeneratedDTO.bankTypeStatus,
                          // );
                          // Provider.of<AddBankProvider>(context, listen: false)
                          //     .updateBankId(qrGeneratedDTO.id);
                          // Provider.of<AddBankProvider>(context, listen: false)
                          //     .updateSelect(2);
                          // Provider.of<AddBankProvider>(context, listen: false)
                          //     .updateRegisterAuthentication(true);
                          // Provider.of<AddBankProvider>(context, listen: false)
                          //     .updateSelectBankType(bankTypeDTO);
                          // Navigator.pushNamed(
                          //   context,
                          //   Routes.ADD_BANK_CARD,
                          //   arguments: {
                          //     'pageIndex': 3,
                          //     'bankAccount': qrGeneratedDTO.bankAccount,
                          //     'name': qrGeneratedDTO.userBankName,
                          //   },
                          // ).then((value) => bankCardBloc
                          //     .add(BankCardGetDetailEvent(bankId: bankId)));
                        },
                        bgColor: AppColor.TRANSPARENT,
                        textColor: AppColor.GREEN,
                      ),
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
                    if (accountBankDetailDTO.phoneAuthenticated.isNotEmpty) ...[
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
                    SizedBox(
                      width: width,
                      child: Row(
                        children: [
                          Tooltip(
                            message: 'Xoá tài khoản',
                            child: ButtonIconWidget(
                              width: 150,
                              height: 40,
                              textColor: AppColor.RED_TEXT,
                              icon: Icons.delete_rounded,
                              title: 'Xoá tài khoản',
                              bgColor: Theme.of(context).canvasColor,
                              function: () {
                                DialogWidget.instance.openMsgDialog(
                                  title: 'Tính năng đang bảo trì',
                                  msg: 'Vui lòng thử lại sau',
                                );
                              },
                            ),
                          ),
                          if (accountBankDetailDTO.authenticated) ...[
                            const Padding(padding: EdgeInsets.only(left: 10)),
                            Tooltip(
                              message: 'Huỷ liên kết',
                              child: ButtonIconWidget(
                                width: 150,
                                height: 40,
                                textColor: AppColor.RED_TEXT,
                                icon: Icons.remove_circle_rounded,
                                title: 'Huỷ liên kết',
                                bgColor: Theme.of(context).canvasColor,
                                function: () {
                                  DialogWidget.instance.openMsgDialog(
                                    title: 'Tính năng đang bảo trì',
                                    msg: 'Vui lòng thử lại sau',
                                  );
                                },
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
              SizedBox(
                width: 350,
                child: VietQRWidget(
                  qrGeneratedDTO: qrGeneratedDTO,
                  showQROnly: true,
                ),
              ),
              const Padding(padding: EdgeInsets.only(right: 20)),
            ],
          ),
        ),
      ],
    );
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
              color: (isAuthenticated) ? AppColor.GREEN : AppColor.ORANGE,
            ),
            const Padding(padding: EdgeInsets.only(left: 10)),
          ],
          if (imgId != null && imgId.trim().isNotEmpty) ...[
            Container(
              width: 60,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColor.WHITE,
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
                  ? AppColor.GREEN
                  : (isAuthenticated != null && !isAuthenticated)
                      ? AppColor.ORANGE
                      : Theme.of(context).hintColor,
            ),
          ),
        ],
      ),
    );
  }
}
