import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/custom_scroll.dart';
import 'package:VietQR/commons/utils/string_utils.dart';
import 'package:VietQR/commons/utils/time_utils.dart';
import 'package:VietQR/commons/widgets/dialog_widget.dart';
import 'package:VietQR/features/merchant/blocs/merchant_bloc.dart';
import 'package:VietQR/features/merchant/events/merchant_event.dart';
import 'package:VietQR/features/merchant/provider/active_fee_provider.dart';
import 'package:VietQR/features/merchant/states/merchant_state.dart';
import 'package:VietQR/models/active_fee_dto.dart';
import 'package:VietQR/services/shared_references/session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:provider/provider.dart';

class SaleReport extends StatefulWidget {
  final MerchantBloc merchantBloc;
  const SaleReport({super.key, required this.merchantBloc});

  @override
  State<SaleReport> createState() => _SaleReportState();
}

class _SaleReportState extends State<SaleReport> {
  List<ActiveFeeDTO> listActiveFee = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitle(),
        Expanded(child: LayoutBuilder(builder: (context, constraints) {
          return BlocConsumer<MerchantBloc, MerchantState>(
              listener: (context, state) {
            if (state is MerchantLoadingState) {
              DialogWidget.instance.openLoadingDialog();
            }
            if (state is MerchantGetMerchantFeeSuccessfulState) {
              // if (!state.isLoadingPage) {
              //   Navigator.pop(context);
              // }

              listActiveFee = state.list;
            }
          }, builder: (context, state) {
            if (state is MerchantLoadingActiveFeeState) {
              return const Padding(
                padding: EdgeInsets.only(top: 40),
                child: Center(child: CircularProgressIndicator()),
              );
            } else {
              if (listActiveFee.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: Center(child: Text('Không có dữ liệu')),
                );
              } else {
                return SingleChildScrollView(
                  child: ScrollConfiguration(
                    behavior: MyCustomScrollBehavior(),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: 1110,
                        child: Column(
                          children: [
                            _buildTitleItem(),
                            ...listActiveFee.map((e) {
                              int i = listActiveFee.indexOf(e);
                              return _buildItem(i, e);
                            }).toList()
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
            }
          });
        }))
      ],
    );
  }

  Widget _buildItem(int index, ActiveFeeDTO dto) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(width: 0.5, color: DefaultTheme.BLACK_LIGHT))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (dto.bankAccounts?.isNotEmpty ?? false)
            Container(
              color: index % 2 == 0 ? DefaultTheme.GREY_BG : DefaultTheme.WHITE,
              alignment: Alignment.center,
              child: Row(
                children: [
                  Center(
                    child: Container(
                      width: 50,
                      alignment: Alignment.center,
                      child: SelectableText(
                        '${index + 1}',
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: dto.bankAccounts!.map((bankAccount) {
                      int index = dto.bankAccounts!.indexOf(bankAccount);
                      return Container(
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: index + 1 == dto.bankAccounts!.length
                                        ? DefaultTheme.TRANSPARENT
                                        : DefaultTheme.GREY_TEXT
                                            .withOpacity(0.15)))),
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                      color: DefaultTheme.GREY_TEXT
                                          .withOpacity(0.1)),
                                  left: BorderSide(
                                      color: DefaultTheme.GREY_TEXT
                                          .withOpacity(0.1)),
                                ),
                              ),
                              width: 120,
                              alignment: Alignment.center,
                              height: (bankAccount.fees?.length ?? 0) * 50,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 12, left: 12),
                                child: SelectableText(
                                  '${bankAccount.bankShortName}\n${bankAccount.bankAccount}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ),
                            if (bankAccount.fees?.isNotEmpty ?? false)
                              Column(
                                children: bankAccount.fees!.map((e) {
                                  int feeIndex = bankAccount.fees!.indexOf(e);
                                  return _buildItemFee(
                                      e,
                                      (feeIndex + 1) ==
                                          bankAccount.fees!.length);
                                }).toList(),
                              ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildItemFee(FeeDTO dto, bool lastItem) {
    return Row(
      children: [
        _buildBoxItem(dto.shortName, width: 120, notBottomBorder: lastItem),
        _buildBoxItem(
            dto.countingTransType == 0 ? 'Tất cả' : 'Chỉ GD có đối soát',
            width: 140,
            notBottomBorder: lastItem,
            valueColor: dto.countingTransType == 1
                ? DefaultTheme.GREEN
                : DefaultTheme.BLACK),
        _buildBoxItem(dto.totalTrans.toString(),
            width: 100, notBottomBorder: lastItem),
        _buildBoxItem('${StringUtils.formatNumber(dto.totalAmount)} VND',
            width: 140,
            notBottomBorder: lastItem,
            valueColor: dto.countingTransType == 1
                ? DefaultTheme.GREEN
                : DefaultTheme.BLACK),
        _buildBoxItem('${dto.vat}%', width: 80, notBottomBorder: lastItem),
        _buildBoxItem('${StringUtils.formatNumber(dto.discountAmount)} VND',
            width: 120, notBottomBorder: lastItem),
        _buildBoxItem('${StringUtils.formatNumber(dto.totalPayment)} VND',
            width: 120, notBottomBorder: lastItem),
        _buildBoxItem(dto.status == 1 ? 'Đã TT' : 'Chưa TT',
            width: 120,
            notBottomBorder: lastItem,
            valueColor:
                dto.status == 1 ? DefaultTheme.BLACK : DefaultTheme.RED_TEXT),
      ],
    );
  }

  Widget _buildBoxItem(String value,
      {double width = 100, bool notBottomBorder = true, Color? valueColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
          border: Border(
              bottom: notBottomBorder
                  ? BorderSide.none
                  : BorderSide(color: DefaultTheme.GREY_TEXT.withOpacity(0.1)),
              right:
                  BorderSide(color: DefaultTheme.GREY_TEXT.withOpacity(0.1)))),
      height: 50,
      alignment: Alignment.center,
      width: width,
      child: SelectableText(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 12, color: valueColor),
      ),
    );
  }

  Widget _buildTitleItem() {
    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(color: DefaultTheme.BLUE_DARK),
      child: Row(
        children: [
          _buildItemTitle('No.', width: 50, padding: EdgeInsets.zero),
          _buildItemTitle('Tài khoản',
              width: 120, padding: const EdgeInsets.symmetric(horizontal: 12)),
          _buildItemTitle('Gói dịch vụ',
              width: 120, padding: const EdgeInsets.symmetric(horizontal: 12)),
          _buildItemTitle('GD ghi nhận',
              width: 140, padding: const EdgeInsets.symmetric(horizontal: 12)),
          _buildItemTitle('Tổng GD',
              width: 100, padding: const EdgeInsets.symmetric(horizontal: 12)),
          _buildItemTitle('Tổng tiền GD',
              width: 140, padding: const EdgeInsets.symmetric(horizontal: 12)),
          _buildItemTitle('VAT',
              width: 80, padding: const EdgeInsets.symmetric(horizontal: 12)),
          _buildItemTitle('Khuyến mại',
              width: 120, padding: const EdgeInsets.symmetric(horizontal: 12)),
          _buildItemTitle('Số tiền cần TT',
              width: 120, padding: const EdgeInsets.symmetric(horizontal: 12)),
          _buildItemTitle('Trạng thái',
              width: 120, padding: const EdgeInsets.symmetric(horizontal: 12)),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return ChangeNotifierProvider<ActiveFeeProvider>(
      create: (context) => ActiveFeeProvider(),
      child: Consumer<ActiveFeeProvider>(builder: (context, provider, child) {
        return Container(
          height: 45,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration:
              BoxDecoration(color: DefaultTheme.BLUE_TEXT.withOpacity(0.2)),
          child: Row(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Báo cáo doanh thu',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline),
                ),
              ),
              const SizedBox(
                width: 24,
              ),
              InkWell(
                onTap: () async {
                  final selected = await showMonthYearPicker(
                    context: context,
                    initialDate: provider.currentDate,
                    firstDate: DateTime(2022),
                    lastDate: DateTime.now(),
                  );
                  provider.changeDate(selected!);
                  String month = TimeUtils.instance.getFormatMonth(selected);
                  widget.merchantBloc.add(GetMerchantFeeEvent(
                      customerSyncId:
                          Session.instance.accountIsMerchantDTO.customerSyncId,
                      month: month,
                      isLoadingPage: false));
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: DefaultTheme.GREY_BG,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    children: [
                      const Text(
                        'Tháng',
                        style: TextStyle(
                            fontSize: 11, color: DefaultTheme.GREY_TEXT),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        TimeUtils.instance
                            .formatMonthToString(provider.currentDate),
                        style: const TextStyle(fontSize: 11),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      const Icon(
                        Icons.calendar_month_outlined,
                        size: 12,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildItemTitle(
    String title, {
    TextAlign? textAlign,
    EdgeInsets? padding,
    double? width,
  }) {
    return Container(
      width: width,
      height: 50,
      padding: padding,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
          border:
              Border(left: BorderSide(color: DefaultTheme.WHITE, width: 0.5))),
      child: Text(
        title,
        textAlign: textAlign,
        style: const TextStyle(fontSize: 12, color: DefaultTheme.WHITE),
      ),
    );
  }
}
