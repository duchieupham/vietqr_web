import 'dart:html' as html;

import 'package:VietQR/commons/utils/custom_scroll.dart';
import 'package:VietQR/commons/utils/string_utils.dart';
import 'package:VietQR/commons/widgets/dialog_widget.dart';
import 'package:VietQR/features/merchant/blocs/merchant_bloc.dart';
import 'package:VietQR/features/merchant/events/merchant_event.dart';
import 'package:VietQR/features/merchant/provider/merchant_provider.dart';
import 'package:VietQR/features/merchant/states/merchant_state.dart';
import 'package:VietQR/models/bank_account_dto.dart';
import 'package:VietQR/models/transaction_merchant_dto.dart';
import 'package:VietQR/services/shared_references/session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../commons/constants/configurations/theme.dart';
import '../../../commons/utils/time_utils.dart';

class ListTransaction extends StatefulWidget {
  final MerchantBloc merchantBloc;
  const ListTransaction({super.key, required this.merchantBloc});

  @override
  State<ListTransaction> createState() => _ListTransactionState();
}

class _ListTransactionState extends State<ListTransaction> {
  List<TransactionMerchantDTO> listTransaction = [];
  int offset = 0;
  bool isCalling = true;
  ScrollController scrollControllerList = ScrollController();

  @override
  void initState() {
    var provider = Provider.of<MerchantProvider>(context, listen: false);
    scrollControllerList.addListener(() {
      if (isCalling) {
        if (scrollControllerList.offset ==
            scrollControllerList.position.maxScrollExtent) {
          offset = offset + 20;
          Map<String, dynamic> param = {};

          param['type'] = provider.valueFilter.id;
          if (provider.valueTimeFilter.id == 0 ||
              (provider.valueFilter.id != 0 && provider.valueFilter.id != 9)) {
            param['from'] = '0';
            param['to'] = '0';
          } else {
            param['from'] =
                TimeUtils.instance.getCurrentDate(provider.fromDate);
            param['to'] = TimeUtils.instance.getCurrentDate(provider.toDate);
          }
          param['value'] = provider.keywordSearch;

          param['offset'] = offset;
          param['merchantId'] =
              Session.instance.accountIsMerchantDTO.customerSyncId;

          widget.merchantBloc.add(GetListTransactionByMerchantEvent(
            param: param,
            isLoadMore: true,
          ));
          isCalling = false;
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTitle(),
        Expanded(child: LayoutBuilder(builder: (context, constraints) {
          return BlocConsumer<MerchantBloc, MerchantState>(
              listener: (context, state) {
            if (state is MerchantLoadingListState) {
              DialogWidget.instance.openLoadingDialog();
            }
            if (state is MerchantGetListByMerchantSuccessfulState) {
              if (state.isLoadMore) {
                listTransaction.addAll(state.list);
                isCalling = true;
              } else {
                if (!state.isLoadingPage) {
                  Navigator.pop(context);
                }
                listTransaction = state.list;
              }
            }
          }, builder: (context, state) {
            if (state is MerchantLoadingInitState) {
              return const Padding(
                padding: EdgeInsets.only(top: 40),
                child: Center(child: CircularProgressIndicator()),
              );
            } else {
              if (listTransaction.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: Center(child: Text('Không có dữ liệu')),
                );
              } else {
                return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        controller: scrollControllerList,
                        child: ScrollConfiguration(
                          behavior: MyCustomScrollBehavior(),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SizedBox(
                              width: constraints.maxWidth > 1360
                                  ? constraints.maxWidth
                                  : 1360,
                              child: SelectionArea(
                                child: Column(
                                  children: [
                                    _buildTitleItem(),
                                    ...listTransaction.map((e) {
                                      int index =
                                          listTransaction.indexOf(e) + 1;

                                      return _buildItem(e, index);
                                    }).toList(),
                                    const SizedBox(width: 12),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (state is MerchantLoadMoreListState)
                      const Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: CircularProgressIndicator(),
                      )
                  ],
                );
              }
            }
          });
        }))
      ],
    );
  }

  Widget _buildItem(TransactionMerchantDTO dto, int index) {
    return Container(
      color: index % 2 == 0 ? DefaultTheme.GREY_BG : DefaultTheme.WHITE,
      alignment: Alignment.center,
      child: Row(
        children: [
          Container(
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: DefaultTheme.GREY_BUTTON),
                    right: BorderSide(color: DefaultTheme.GREY_BUTTON))),
            width: 50,
            height: 50,
            alignment: Alignment.center,
            child: Text(
              '$index',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: DefaultTheme.GREY_BUTTON),
                    right: BorderSide(color: DefaultTheme.GREY_BUTTON))),
            padding: const EdgeInsets.only(left: 12),
            alignment: Alignment.centerLeft,
            height: 50,
            width: 130,
            child: Text(
              dto.bankAccount,
              textAlign: TextAlign.left,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Container(
            width: 110,
            height: 50,
            padding: const EdgeInsets.only(left: 12),
            alignment: Alignment.centerLeft,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: DefaultTheme.GREY_BUTTON),
                    right: BorderSide(color: DefaultTheme.GREY_BUTTON))),
            child: Text(
              dto.orderId.isNotEmpty ? dto.orderId : '-',
              textAlign: TextAlign.left,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Container(
            width: 140,
            height: 50,
            padding: const EdgeInsets.only(left: 12),
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: DefaultTheme.GREY_BUTTON),
                    right: BorderSide(color: DefaultTheme.GREY_BUTTON))),
            child: Text(
              dto.referenceNumber.isNotEmpty ? dto.referenceNumber : '-',
              textAlign: TextAlign.left,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Container(
            width: 150,
            height: 50,
            padding: const EdgeInsets.only(left: 12),
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: DefaultTheme.GREY_BUTTON),
                    right: BorderSide(color: DefaultTheme.GREY_BUTTON))),
            child: Text(
              dto.transType == 'D'
                  ? '- ${StringUtils.formatNumber(dto.amount)} VND'
                  : '+ ${StringUtils.formatNumber(dto.amount)} VND',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: dto.getAmountColor()),
            ),
          ),
          Container(
            width: 110,
            height: 50,
            padding: const EdgeInsets.only(left: 12),
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: DefaultTheme.GREY_BUTTON),
                    right: BorderSide(color: DefaultTheme.GREY_BUTTON))),
            child: Text(
              dto.getStatus(),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: dto.getStatusColor()),
            ),
          ),
          Container(
            width: 120,
            height: 50,
            padding: const EdgeInsets.only(left: 12),
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: DefaultTheme.GREY_BUTTON),
                    right: BorderSide(color: DefaultTheme.GREY_BUTTON))),
            child: Text(
              dto.timeCreated == 0
                  ? '-'
                  : TimeUtils.instance.formatTimeDateFromInt(dto.timeCreated),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Container(
            width: 140,
            height: 50,
            padding: const EdgeInsets.only(left: 12),
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: DefaultTheme.GREY_BUTTON),
                    right: BorderSide(color: DefaultTheme.GREY_BUTTON))),
            child: Text(
              dto.timePaid == 0
                  ? '-'
                  : TimeUtils.instance.formatTimeDateFromInt(dto.timePaid),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Expanded(
            child: Container(
              height: 50,
              padding: const EdgeInsets.only(left: 12),
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: DefaultTheme.GREY_BUTTON),
                      right: BorderSide(color: DefaultTheme.GREY_BUTTON))),
              child: Text(
                dto.content,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
          Container(
            width: 100,
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: DefaultTheme.GREY_BUTTON),
                    right: BorderSide(color: DefaultTheme.GREY_BUTTON))),
            child: Text(
              dto.type == 0 ? 'Mã VietQR' : 'Khác',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleItem() {
    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(color: DefaultTheme.BLUE_DARK),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildItemTitle('No.',
              height: 50, width: 50, alignment: Alignment.center),
          _buildItemTitle('Số TK',
              height: 50,
              width: 130,
              padding: const EdgeInsets.only(left: 12),
              alignment: Alignment.centerLeft),
          _buildItemTitle('Mã đơn hàng',
              height: 50,
              width: 110,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.centerLeft),
          _buildItemTitle('Mã GD',
              height: 50,
              width: 140,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.center),
          _buildItemTitle('Số tiền',
              height: 50,
              width: 150,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.center),
          _buildItemTitle('Trạng thái',
              height: 50,
              width: 110,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.center),
          _buildItemTitle('TG tạo GD',
              height: 50,
              width: 120,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.centerLeft),
          _buildItemTitle('TG tạo GD',
              height: 50,
              width: 140,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.centerLeft),
          Expanded(
            child: _buildItemTitle('Nội dung',
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                alignment: Alignment.center),
          ),
          _buildItemTitle('Loại GD',
              height: 50,
              width: 100,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.center),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: DefaultTheme.BLUE_TEXT.withOpacity(0.2)),
      child: Consumer<MerchantProvider>(builder: (context, provider, child) {
        return Row(
          children: [
            if (provider.currentPage == 1)
              InkWell(
                onTap: () {
                  provider.updateCurrentPage(0);
                  // pageViewController.previousPage(
                  //     duration: const Duration(milliseconds: 200),
                  //     curve: Curves.easeIn);
                },
                child: Container(
                  margin: const EdgeInsets.only(
                      top: 8, bottom: 8, left: 16, right: 24),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: DefaultTheme.BLUE_TEXT.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    children: const [
                      Icon(
                        Icons.arrow_back_ios,
                        color: DefaultTheme.BLUE_TEXT,
                        size: 12,
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        'Trở về',
                        style: TextStyle(
                            fontSize: 11, color: DefaultTheme.BLUE_TEXT),
                      ),
                    ],
                  ),
                ),
              ),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Danh sách giao dịch',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline),
              ),
            ),
            const SizedBox(
              width: 24,
            ),
            if (provider.currentPage == 1) ...[
              const Icon(
                Icons.arrow_forward_ios,
                color: DefaultTheme.BLUE_TEXT,
                size: 20,
              ),
              const SizedBox(
                width: 24,
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Chi tiết giao dịch',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline),
                ),
              ),
            ] else
              Expanded(
                child: ScrollConfiguration(
                  behavior: MyCustomScrollBehavior(),
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      const SizedBox(
                        width: 24,
                      ),
                      Container(
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
                              'Lọc theo',
                              style: TextStyle(
                                  fontSize: 11, color: DefaultTheme.GREY_TEXT),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            DropdownButton<FilterTransaction>(
                              value: provider.valueFilter,
                              icon: const RotatedBox(
                                quarterTurns: 5,
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 12,
                                ),
                              ),
                              underline: const SizedBox.shrink(),
                              onChanged: (FilterTransaction? value) {
                                provider.changeFilter(value!);
                              },
                              items: provider.listFilter
                                  .map<DropdownMenuItem<FilterTransaction>>(
                                      (FilterTransaction value) {
                                return DropdownMenuItem<FilterTransaction>(
                                  value: value,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 4),
                                    child: Text(
                                      value.title,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                      if (provider.valueFilter.id == 9 ||
                          provider.valueFilter.id == 0) ...[
                        Container(
                          margin: const EdgeInsets.only(
                              top: 8, bottom: 8, left: 16),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: DefaultTheme.GREY_BG,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            children: [
                              const Text(
                                'Thời gian',
                                style: TextStyle(
                                    fontSize: 11,
                                    color: DefaultTheme.GREY_TEXT),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              DropdownButton<FilterTimeTransaction>(
                                value: provider.valueTimeFilter,
                                icon: const RotatedBox(
                                  quarterTurns: 5,
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 12,
                                  ),
                                ),
                                underline: const SizedBox.shrink(),
                                onChanged: (FilterTimeTransaction? value) {
                                  provider.changeTimeFilter(value!);
                                },
                                items: provider.listTimeFilter.map<
                                        DropdownMenuItem<
                                            FilterTimeTransaction>>(
                                    (FilterTimeTransaction value) {
                                  return DropdownMenuItem<
                                      FilterTimeTransaction>(
                                    value: value,
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 4),
                                      child: Text(
                                        value.title,
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                        if (provider.valueTimeFilter.id == 1) ...[
                          InkWell(
                            onTap: () async {
                              DateTime? date = await showDatePicker(
                                context: context,
                                initialDate: provider.fromDate,
                                firstDate: DateTime(2022),
                                lastDate: DateTime.now(),
                              );
                              provider.updateFromDate(date ?? DateTime.now());
                            },
                            child: Container(
                              margin: const EdgeInsets.only(
                                  top: 8, bottom: 8, left: 16),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: DefaultTheme.GREY_BG,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Row(
                                children: [
                                  const Text(
                                    'Từ ngày',
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: DefaultTheme.GREY_TEXT),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    TimeUtils.instance
                                        .formatDateToString(provider.fromDate),
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
                          InkWell(
                            onTap: () async {
                              DateTime? date = await showDatePicker(
                                context: context,
                                initialDate: provider.toDate,
                                firstDate: DateTime(2022),
                                lastDate: DateTime.now(),
                              );
                              provider.updateToDate(date ?? DateTime.now());
                            },
                            child: Container(
                              margin: const EdgeInsets.only(
                                  top: 8, bottom: 8, left: 16),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: DefaultTheme.GREY_BG,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Row(
                                children: [
                                  const Text(
                                    'Đến ngày',
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: DefaultTheme.GREY_TEXT),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Text(
                                    TimeUtils.instance
                                        .formatDateToString(provider.toDate),
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
                        if (provider.valueFilter.id == 0) ...[
                          const SizedBox(
                            width: 16,
                          ),
                          Container(
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
                                  'Số tài khoản',
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: DefaultTheme.GREY_TEXT),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                DropdownButton<BankAccountDTO>(
                                  value: provider.bankAccountDTO,
                                  icon: const RotatedBox(
                                    quarterTurns: 5,
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      size: 12,
                                    ),
                                  ),
                                  underline: const SizedBox.shrink(),
                                  onChanged: (BankAccountDTO? value) {
                                    provider.changeBankAccount(value!);
                                  },
                                  items: Session
                                      .instance.listBankAccountOfMerchant
                                      .map<DropdownMenuItem<BankAccountDTO>>(
                                          (BankAccountDTO value) {
                                    return DropdownMenuItem<BankAccountDTO>(
                                      value: value,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 4),
                                        child: Text(
                                          value.bankAccount,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                        ]
                      ],
                      if (provider.valueFilter.id != 9 &&
                          provider.valueFilter.id != 0)
                        Container(
                          margin: const EdgeInsets.only(
                              top: 8, bottom: 8, left: 16),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          width: 180,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: DefaultTheme.GREY_BG,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: TextField(
                            style: const TextStyle(fontSize: 12),
                            onChanged: (value) {
                              provider.updateKeyword(value);
                            },
                            decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.only(bottom: 18),
                                border: InputBorder.none,
                                hintText:
                                    'Tìm kiếm bằng ${provider.valueFilter.title.toLowerCase()}',
                                hintStyle: const TextStyle(
                                    fontSize: 12,
                                    color: DefaultTheme.GREY_TEXT)),
                          ),
                        ),
                      InkWell(
                        onTap: () {
                          if (provider.fromDate.millisecondsSinceEpoch <=
                              provider.toDate.millisecondsSinceEpoch) {
                            Map<String, dynamic> param = {};
                            offset = 0;
                            param['type'] = provider.valueFilter.id;
                            if (provider.valueTimeFilter.id == 0 ||
                                (provider.valueFilter.id != 0 &&
                                    provider.valueFilter.id != 9)) {
                              param['from'] = '0';
                              param['to'] = '0';
                            } else {
                              param['from'] = TimeUtils.instance
                                  .getCurrentDate(provider.fromDate);
                              param['to'] = TimeUtils.instance
                                  .getCurrentDate(provider.toDate);
                            }
                            param['value'] = provider.keywordSearch;

                            param['offset'] = offset;
                            param['merchantId'] = Session
                                .instance.accountIsMerchantDTO.customerSyncId;

                            widget.merchantBloc.add(
                                GetListTransactionByMerchantEvent(
                                    param: param));
                          } else {
                            DialogWidget.instance.openMsgDialog(
                                title: 'Không hợp lệ',
                                msg:
                                    'Ngày bắt đầu không được lớn hơn ngày kết thúc');
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.only(
                              top: 8, bottom: 8, left: 16),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          width: 120,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: DefaultTheme.BLUE_TEXT,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const Text(
                            'Tìm kiếm',
                            style: TextStyle(
                                fontSize: 12, color: DefaultTheme.WHITE),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (provider.valueTimeFilter.id == 1)
              InkWell(
                onTap: () {
                  String link =
                      'https://api.vietqr.org/vqr/api/merchant/transactions-export?merchantId=${Session.instance.accountIsMerchantDTO.customerSyncId}&type=${provider.valueFilter.id}&value=${provider.keywordSearch}&from=${TimeUtils.instance.formatDateToString(provider.fromDate, isExport: true)} 00:00:00&to=${TimeUtils.instance.formatDateToString(provider.toDate, isExport: true)} 23:59:59';
                  html.window.open(link, 'new tab');
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 8, bottom: 8, left: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  width: 120,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: DefaultTheme.BLUE_TEXT,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Text(
                    'Xuất Excel',
                    style: TextStyle(fontSize: 12, color: DefaultTheme.WHITE),
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }

  Widget _buildItemTitle(String title,
      {TextAlign? textAlign,
      EdgeInsets? padding,
      double? width,
      double? height,
      Alignment? alignment}) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      alignment: alignment,
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
