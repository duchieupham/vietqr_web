import 'dart:html' as html;

import 'package:VietQR/commons/utils/custom_scroll.dart';
import 'package:VietQR/commons/utils/string_utils.dart';
import 'package:VietQR/commons/widgets/dialog_widget.dart';
import 'package:VietQR/features/transaction_user/blocs/tran_user_bloc.dart';
import 'package:VietQR/features/transaction_user/events/tran_user_event.dart';
import 'package:VietQR/features/transaction_user/provider/trans_user_provider.dart';
import 'package:VietQR/features/transaction_user/states/trans_user_state.dart';
import 'package:VietQR/models/bank_account_dto.dart';
import 'package:VietQR/models/transaction_merchant_dto.dart';
import 'package:VietQR/services/shared_references/session.dart';
import 'package:VietQR/services/shared_references/user_information_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../commons/constants/configurations/theme.dart';
import '../../../commons/utils/time_utils.dart';

class ListTransactionUser extends StatefulWidget {
  final TransactionUserBloc transactionUserBloc;
  ListTransactionUser({super.key, required this.transactionUserBloc});

  @override
  State<ListTransactionUser> createState() => _ListTransactionUserState();
}

class _ListTransactionUserState extends State<ListTransactionUser> {
  List<TransactionMerchantDTO> listTransaction = [];

  init() {
    Map<String, dynamic> paramInit = {};
    paramInit['userId'] = UserInformationHelper.instance.getUserId();
    paramInit['type'] = 9;
    paramInit['value'] = '';
    paramInit['from'] = '0';
    paramInit['to'] = '0';
    paramInit['offset'] = 0;
    widget.transactionUserBloc
        .add(GetListTransactionByEvent(param: paramInit, isLoadingPage: true));
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TransUserProvider>(
      create: (context) => TransUserProvider()
        ..init(widget.transactionUserBloc, () {
          // init();
        }),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(),
          _buildFilter(),
          Expanded(child: LayoutBuilder(builder: (context, constraints) {
            return BlocConsumer<TransactionUserBloc, TransUserState>(
                listener: (context, state) {
              if (state is GetListTransactionLoadingListState) {
                DialogWidget.instance.openLoadingDialog();
              }
              if (state is GetListTransactionByUserSuccessfulState) {
                if (state.isLoadMore) {
                  listTransaction.addAll(state.list);
                  Provider.of<TransUserProvider>(context, listen: false)
                      .updateCallLoadMore(true);
                } else {
                  if (!state.isLoadingPage) {
                    Navigator.pop(context);
                  }
                  listTransaction = state.list;
                }
              }
            }, builder: (context, state) {
              if (state is GetListTransactionLoadingInitState) {
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
                          controller: Provider.of<TransUserProvider>(context,
                                  listen: false)
                              .scrollControllerList,
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
                      if (state is GetListTransactionLoadMoreListState)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator()),
                        )
                    ],
                  );
                }
              }
            });
          }))
        ],
      ),
    );
  }

  Widget _buildItem(TransactionMerchantDTO dto, int index) {
    return Container(
      color: index % 2 == 0 ? AppColor.GREY_BG : AppColor.WHITE,
      alignment: Alignment.center,
      child: Row(
        children: [
          Container(
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
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
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
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
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
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
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
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
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
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
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
            child: Text(
              dto.getStatus(),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: dto.getAmountColor()),
            ),
          ),
          Container(
            width: 120,
            height: 50,
            padding: const EdgeInsets.only(left: 12),
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
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
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
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
                      bottom: BorderSide(color: AppColor.GREY_BUTTON),
                      right: BorderSide(color: AppColor.GREY_BUTTON))),
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
                    bottom: BorderSide(color: AppColor.GREY_BUTTON),
                    right: BorderSide(color: AppColor.GREY_BUTTON))),
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
      decoration: const BoxDecoration(color: AppColor.BLUE_DARK),
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
          _buildItemTitle('Thời gian tạo GD',
              height: 50,
              width: 120,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.centerLeft),
          _buildItemTitle('Thời gian TT',
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
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: AppColor.BLUE_TEXT.withOpacity(0.1)),
      alignment: Alignment.centerLeft,
      child: const Text(
        'Danh sách giao dịch',
        style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline),
      ),
    );
  }

  Widget _buildFilter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Consumer<TransUserProvider>(builder: (context, provider, child) {
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            Container(
              width: 180,
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: AppColor.GREY_BG,
                border: Border.all(color: AppColor.GREY_LIGHT),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                children: [
                  const Text(
                    'Lọc theo',
                    style: TextStyle(fontSize: 11, color: AppColor.GREY_TEXT),
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
                width: 200,
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColor.GREY_BG,
                  border: Border.all(color: AppColor.GREY_LIGHT),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  children: [
                    const Text(
                      'Thời gian',
                      style: TextStyle(fontSize: 11, color: AppColor.GREY_TEXT),
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
                      items: provider.listTimeFilter
                          .map<DropdownMenuItem<FilterTimeTransaction>>(
                              (FilterTimeTransaction value) {
                        return DropdownMenuItem<FilterTimeTransaction>(
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
                    DateTime? date = await showDateTimePicker(
                      context: context,
                      initialDate: provider.fromDate,
                      firstDate: DateTime(2022),
                      lastDate: DateTime.now(),
                    );
                    provider.updateFromDate(date ?? DateTime.now());
                  },
                  child: Container(
                    width: 210,
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColor.GREY_BG,
                      border: Border.all(color: AppColor.GREY_LIGHT),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      children: [
                        const Text(
                          'Từ ngày',
                          style: TextStyle(
                              fontSize: 11, color: AppColor.GREY_TEXT),
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
                    DateTime? date = await showDateTimePicker(
                      context: context,
                      initialDate: provider.toDate,
                      firstDate: DateTime(2022),
                      lastDate: DateTime.now(),
                    );
                    provider.updateToDate(date ?? DateTime.now());
                  },
                  child: Container(
                    width: 220,
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColor.GREY_BG,
                      border: Border.all(color: AppColor.GREY_LIGHT),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      children: [
                        const Text(
                          'Đến ngày',
                          style: TextStyle(
                              fontSize: 11, color: AppColor.GREY_TEXT),
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
                Container(
                  width: 215,
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColor.GREY_BG,
                    border: Border.all(color: AppColor.GREY_LIGHT),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    children: [
                      const Text(
                        'Số tài khoản',
                        style:
                            TextStyle(fontSize: 11, color: AppColor.GREY_TEXT),
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
                        items: provider.bankAccounts
                            .map<DropdownMenuItem<BankAccountDTO>>(
                                (BankAccountDTO value) {
                          return DropdownMenuItem<BankAccountDTO>(
                            value: value,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 4),
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
            if (provider.valueFilter.id != 9 && provider.valueFilter.id != 0)
              Container(
                height: 40,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                width: 180,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColor.GREY_BG,
                  border: Border.all(color: AppColor.GREY_LIGHT),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextField(
                  style: const TextStyle(fontSize: 12),
                  onChanged: (value) {
                    provider.updateKeyword(value);
                  },
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(bottom: 18),
                      border: InputBorder.none,
                      hintText:
                          'Tìm kiếm bằng ${provider.valueFilter.title.toLowerCase()}',
                      hintStyle: const TextStyle(
                          fontSize: 12, color: AppColor.GREY_TEXT)),
                ),
              ),
            InkWell(
              onTap: () {
                if (provider.fromDate.millisecondsSinceEpoch <=
                    provider.toDate.millisecondsSinceEpoch) {
                  Map<String, dynamic> param = {};
                  Provider.of<TransUserProvider>(context, listen: false)
                      .updateOffset(0);
                  param['type'] = provider.valueFilter.id;
                  if (provider.valueTimeFilter.id == 0 ||
                      (provider.valueFilter.id != 0 &&
                          provider.valueFilter.id != 9)) {
                    param['from'] = '0';
                    param['to'] = '0';
                  } else {
                    param['from'] =
                        TimeUtils.instance.getCurrentDate(provider.fromDate);
                    param['to'] =
                        TimeUtils.instance.getCurrentDate(provider.toDate);
                  }
                  param['value'] = provider.keywordSearch;

                  param['offset'] =
                      Provider.of<TransUserProvider>(context, listen: false)
                          .offset;
                  param['merchantId'] =
                      Session.instance.accountIsMerchantDTO.customerSyncId;

                  widget.transactionUserBloc
                      .add(GetListTransactionByEvent(param: param));
                } else {
                  DialogWidget.instance.openMsgDialog(
                      title: 'Không hợp lệ',
                      msg: 'Ngày bắt đầu không được lớn hơn ngày kết thúc');
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                width: 120,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColor.BLUE_TEXT,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Text(
                  'Tìm kiếm',
                  style: TextStyle(fontSize: 12, color: AppColor.WHITE),
                ),
              ),
            ),
            if (provider.valueTimeFilter.id == 1)
              InkWell(
                onTap: () {
                  String link =
                      'https://api.vietqr.org/vqr/api/merchant/transactions-export?merchantId=${Session.instance.accountIsMerchantDTO.customerSyncId}&type=${provider.valueFilter.id}&value=${provider.keywordSearch}&from=${TimeUtils.instance.formatDateToString(provider.fromDate, isExport: true)}&to=${TimeUtils.instance.formatDateToString(provider.toDate, isExport: true)}';
                  html.window.open(link, 'new tab');
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  width: 120,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColor.GREEN,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Text(
                    'Xuất Excel',
                    style: TextStyle(fontSize: 12, color: AppColor.WHITE),
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
          border: Border(left: BorderSide(color: AppColor.WHITE, width: 0.5))),
      child: Text(
        title,
        textAlign: textAlign,
        style: const TextStyle(fontSize: 12, color: AppColor.WHITE),
      ),
    );
  }

  Future<DateTime?> showDateTimePicker({
    required BuildContext context,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    initialDate ??= DateTime.now();
    firstDate ??= initialDate.subtract(const Duration(days: 365 * 100));
    lastDate ??= firstDate.add(const Duration(days: 365 * 200));

    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (selectedDate == null) return null;

    if (!context.mounted) return selectedDate;

    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedDate),
    );

    return selectedTime == null
        ? selectedDate
        : DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedTime.hour,
            selectedTime.minute,
          );
  }
}
