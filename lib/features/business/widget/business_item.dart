import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/currency_utils.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/commons/utils/time_utils.dart';
import 'package:VietQR/commons/utils/transaction_utils.dart';
import 'package:VietQR/commons/widgets/dialog_widget.dart';
import 'package:VietQR/commons/widgets/divider_widget.dart';
import 'package:VietQR/features/transaction/widgets/transaction_detail_view.dart';
import 'package:VietQR/layouts/box_layout.dart';
import 'package:VietQR/models/business_item_dto.dart';
import 'package:VietQR/models/related_transaction_receive_dto.dart';
import 'package:VietQR/services/providers/business_inforamtion_provider.dart';
import 'package:VietQR/services/shared_references/user_information_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BusinessItem extends StatelessWidget {
  final BusinessItemDTO dto;
  final Function() businessInfo;
  final Function() businessTransaction;
  const BusinessItem(
      {super.key,
      required this.dto,
      required this.businessInfo,
      required this.businessTransaction});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    String heroId = dto.businessId;
    return Container(
      width: width,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          SizedBox(
            child: Stack(
              children: [
                Hero(
                  tag: heroId,
                  child: Container(
                    width: width,
                    // height: width * 9 / 16,
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                      color: DefaultTheme.GREY_TOP_TAB_BAR.withOpacity(0.3),
                      image: (dto.coverImgId.isNotEmpty)
                          ? DecorationImage(
                              fit: BoxFit.cover,
                              image: ImageUtils.instance
                                  .getImageNetWork(dto.coverImgId),
                            )
                          : null,
                    ),
                  ),
                ),
                Container(
                  width: width,
                  // height: width * 9 / 16,
                  height: 150,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        DefaultTheme.TRANSPARENT,
                        Theme.of(context)
                            .scaffoldBackgroundColor
                            .withOpacity(0.4),
                        Theme.of(context).scaffoldBackgroundColor,
                        Theme.of(context).scaffoldBackgroundColor,
                      ],
                    ),
                  ),
                ),
                Positioned(
                  right: 10,
                  top: 10,
                  child: InkWell(
                    onTap: businessInfo,
                    child: const BoxLayout(
                      width: 85,
                      borderRadius: 40,
                      alignment: Alignment.center,
                      child: Text(
                        'Chi tiết',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 30,
                  left: 0,
                  child: SizedBox(
                    width: width - 50,
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: (dto.imgId.isNotEmpty)
                                  ? ImageUtils.instance
                                      .getImageNetWork(dto.imgId)
                                  : Image.asset(
                                      'assets/images/ic-avatar-business.png',
                                      fit: BoxFit.cover,
                                      width: 50,
                                      height: 50,
                                    ).image,
                            ),
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(left: 20)),
                        Expanded(
                          child: Text(
                            dto.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: width,
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _buildChip(
                  context: context,
                  icon: Icons.assignment_ind_rounded,
                  color: DefaultTheme.RED_CALENDAR,
                  text: getRoleName(dto.role),
                ),
                _buildChip(
                  context: context,
                  icon: Icons.business_rounded,
                  color: DefaultTheme.GREEN,
                  text: '${dto.totalBranch} chi nhánh',
                ),
                _buildChip(
                  context: context,
                  icon: Icons.people_rounded,
                  text: '${dto.totalMember} thành viên',
                  color: DefaultTheme.BLUE_TEXT,
                ),
              ],
            ),
          ),
          if (dto.transactions.isEmpty) ...[
            const Padding(padding: EdgeInsets.only(top: 10)),
            Container(
              width: width,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text('Chưa có giao dịch nào'),
            ),
          ],
          if (dto.transactions.isNotEmpty) ...[
            const Padding(padding: EdgeInsets.only(top: 30)),
            SizedBox(
              width: width,
              child: const Text(
                'Giao dịch gần đây',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 10)),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: dto.transactions.length,
                itemBuilder: (context, index) {
                  return _buildTransactionItem(
                    context: context,
                    dto: dto.transactions[index],
                  );
                },
                separatorBuilder: (context, index) {
                  return DividerWidget(width: width);
                },
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 10)),
            InkWell(
              onTap: () {
                Future.delayed(const Duration(milliseconds: 0), () {
                  Provider.of<BusinessInformationProvider>(context,
                          listen: false)
                      .updateBusinessId(dto.businessId);
                });
                businessTransaction();
              },
              child: BoxLayout(
                width: width,
                height: 40,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(0),
                bgColor: DefaultTheme.TRANSPARENT,
                child: const Text(
                  'Xem thêm',
                  style: TextStyle(
                    color: DefaultTheme.GREEN,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildChip({
    required BuildContext context,
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return UnconstrainedBox(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 15,
              color: color,
            ),
            const Padding(padding: EdgeInsets.only(left: 5)),
            Text(text),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionItem({
    required BuildContext context,
    required RelatedTransactionReceiveDTO dto,
  }) {
    final double width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        String userId = UserInformationHelper.instance.getUserId();
        DialogWidget.instance.openPopup(
          child: TransactionDetailView(
            transactionId: dto.transactionId,
          ),
          width: 500,
          height: 500,
        );
      },
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 25,
              height: 25,
              child: Icon(
                TransactionUtils.instance
                    .getIconStatus(dto.status, dto.transType),
                color: TransactionUtils.instance
                    .getColorStatus(dto.status, dto.type, dto.transType),
              ),
            ),
            const Padding(padding: EdgeInsets.only(left: 5)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${TransactionUtils.instance.getTransType(dto.transType)} ${CurrencyUtils.instance.getCurrencyFormatted(dto.amount)}',
                    style: TextStyle(
                      fontSize: 18,
                      color: TransactionUtils.instance
                          .getColorStatus(dto.status, dto.type, dto.transType),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 3)),
                  Text(
                    'Đến TK: ${dto.bankAccount}',
                    style: const TextStyle(),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 3)),
                  Text(
                    dto.content.trim(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: DefaultTheme.GREY_TEXT,
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Text(
                TimeUtils.instance.formatDateFromInt(dto.time, true),
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getRoleName(int role) {
    String result = '';
    if (role == 5) {
      result = 'Admin';
    } else if (role == 1) {
      result = 'Quản lý';
    } else if (role == 3) {
      result = 'Quản lý chi nhánh';
    } else {
      result = 'Thành viên';
    }
    return result;
  }
}
