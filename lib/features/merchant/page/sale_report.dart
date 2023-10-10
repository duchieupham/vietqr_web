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
                        width: 1109,
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
      child: Padding(
        padding: EdgeInsets.only(top: index == 0 ? 12 : 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (dto.bankAccounts?.isNotEmpty ?? false)
              Row(
                children: [
                  SizedBox(
                    width: 50,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: SelectableText(
                        '${index + 1}',
                        textAlign: TextAlign.center,
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
                        padding: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    width: 0.5,
                                    color: index + 1 == dto.bankAccounts!.length
                                        ? DefaultTheme.TRANSPARENT
                                        : DefaultTheme.GREY_TEXT
                                            .withOpacity(0.5)))),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 120,
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
                                  return _buildItemFee(e);
                                }).toList(),
                              ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemFee(FeeDTO dto) {
    return Row(
      children: [
        SizedBox(
          width: 120,
          child: Padding(
            padding: const EdgeInsets.only(top: 12, left: 20),
            child: SelectableText(
              dto.shortName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ),
        ),
        SizedBox(
          width: 139,
          child: Padding(
            padding: const EdgeInsets.only(top: 12, left: 20),
            child: SelectableText(
              dto.countingTransType == 0 ? 'Tất cả' : 'Chỉ GD có đối soát',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 12,
                  color: dto.countingTransType == 1
                      ? DefaultTheme.GREEN
                      : DefaultTheme.BLACK),
            ),
          ),
        ),
        SizedBox(
          width: 100,
          child: Padding(
            padding: const EdgeInsets.only(top: 12, left: 20),
            child: SelectableText(
              dto.totalTrans.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ),
        ),
        SizedBox(
          width: 140,
          child: Padding(
            padding: const EdgeInsets.only(top: 12, left: 20),
            child: SelectableText(
              '${StringUtils.formatNumber(dto.totalAmount)} VND',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 12,
                  color: dto.countingTransType == 1
                      ? DefaultTheme.GREEN
                      : DefaultTheme.BLACK),
            ),
          ),
        ),
        SizedBox(
          width: 80,
          child: Padding(
            padding: const EdgeInsets.only(top: 12, left: 20),
            child: SelectableText(
              '${dto.vat}%',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ),
        ),
        SizedBox(
          width: 120,
          child: Padding(
            padding: const EdgeInsets.only(top: 12, left: 20),
            child: SelectableText(
              '${StringUtils.formatNumber(dto.discountAmount)} VND',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ),
        ),
        SizedBox(
          width: 120,
          child: Padding(
            padding: const EdgeInsets.only(top: 12, left: 20),
            child: SelectableText(
              '${StringUtils.formatNumber(dto.totalPayment)} VND',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ),
        ),
        SizedBox(
          width: 120,
          child: Padding(
            padding: const EdgeInsets.only(top: 12, left: 20),
            child: SelectableText(
              dto.status == 1 ? 'Đã TT' : 'Chưa TT',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 12,
                  color: dto.status == 1
                      ? DefaultTheme.BLACK
                      : DefaultTheme.RED_TEXT),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTitleItem() {
    return Row(
      children: const [
        SizedBox(
          width: 50,
          child: Padding(
            padding: EdgeInsets.only(top: 12, left: 20),
            child: Text(
              'No.',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ),
        SizedBox(
          width: 120,
          child: Padding(
            padding: EdgeInsets.only(top: 12, left: 12),
            child: Text(
              'Tài khoản',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ),
        SizedBox(
          width: 120,
          child: Padding(
            padding: EdgeInsets.only(top: 12, left: 20),
            child: Text(
              'Gói dịch vụ',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ),
        SizedBox(
          width: 139,
          child: Padding(
            padding: const EdgeInsets.only(top: 12, left: 20),
            child: Text(
              'GD ghi nhận',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ),
        SizedBox(
          width: 100,
          child: Padding(
            padding: EdgeInsets.only(top: 12, left: 20),
            child: Text(
              'Tổng GD',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ),
        SizedBox(
          width: 140,
          child: Padding(
            padding: EdgeInsets.only(top: 12, left: 20),
            child: Text(
              'Tổng tiền GD',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ),
        SizedBox(
          width: 80,
          child: Padding(
            padding: EdgeInsets.only(top: 12, left: 20),
            child: Text(
              'VAT',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ),
        SizedBox(
          width: 120,
          child: Padding(
            padding: EdgeInsets.only(top: 12, left: 20),
            child: Text(
              'Khuyến mại',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ),
        SizedBox(
          width: 120,
          child: Padding(
            padding: EdgeInsets.only(top: 12, left: 20),
            child: Text(
              'Số tiền cần TT',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ),
        SizedBox(
          width: 120,
          child: Padding(
            padding: EdgeInsets.only(top: 12, left: 20),
            child: Text(
              'Trạng thái',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ),
      ],
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
}
