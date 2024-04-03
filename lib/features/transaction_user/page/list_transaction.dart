import 'dart:html' as html;

import 'package:VietQR/commons/enums/check_type.dart';
import 'package:VietQR/commons/utils/custom_scroll.dart';
import 'package:VietQR/commons/utils/month_calculator.dart';
import 'package:VietQR/commons/utils/string_utils.dart';
import 'package:VietQR/commons/widgets/button_widget.dart';
import 'package:VietQR/commons/widgets/dialog_widget.dart';
import 'package:VietQR/features/transaction_user/blocs/tran_user_bloc.dart';
import 'package:VietQR/features/transaction_user/events/tran_user_event.dart';
import 'package:VietQR/features/transaction_user/provider/trans_user_provider.dart';
import 'package:VietQR/features/transaction_user/states/trans_user_state.dart';
import 'package:VietQR/layouts/text_field_custom.dart';
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
  const ListTransactionUser({super.key});

  @override
  State<ListTransactionUser> createState() => _ListTransactionUserState();
}

class _ListTransactionUserState extends State<ListTransactionUser> {
  late TransactionUserBloc transactionUserBloc;

  List<TransactionMerchantDTO> listTransaction = [];
  MonthCalculator monthCalculator = MonthCalculator();
  final noteController = TextEditingController();

  List<String> hasTagOutCome = [
    '#ăn_uống',
    '#hóa_dơn',
    '#gia_đình',
    '#di_chuyển',
    '#sức_khỏe',
    '#giải_trí',
    '#bảo_hiểm',
    '#đầu_tư',
    '#trả_lãi',
    '#khác'
  ];

  List<String> hasTagInCome = [
    '#tiết_kiệm',
    '#lương',
    '#thu_lãi',
    '#thu_nhập_khác',
  ];

  init() {
    DateTime now = DateTime.now();
    DateTime fromDate = DateTime(now.year, now.month, now.day);
    DateTime endDate = fromDate.subtract(const Duration(days: 7));

    fromDate = fromDate
        .add(const Duration(days: 1))
        .subtract(const Duration(seconds: 1));
    Map<String, dynamic> paramInit = {};
    paramInit['userId'] = UserInformationHelper.instance.getUserId();
    paramInit['type'] = 9;
    paramInit['value'] = '';
    paramInit['from'] = TimeUtils.instance.getCurrentDate(endDate);
    paramInit['to'] = TimeUtils.instance.getCurrentDate(fromDate);
    paramInit['offset'] = 0;
    transactionUserBloc
        .add(GetListTransactionByEvent(param: paramInit, isLoadingPage: true));
  }

  @override
  void initState() {
    super.initState();
    transactionUserBloc = BlocProvider.of(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      init();
      Provider.of<TransUserProvider>(context, listen: false)
          .init(transactionUserBloc, () {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitle(),
        _buildFilter(),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return BlocConsumer<TransactionUserBloc, TransUserState>(
                listener: (context, state) {
                  if (state is GetListTransactionLoadingListState) {
                    DialogWidget.instance.openLoadingDialog();
                  }
                  if (state is GetListTransactionByUserSuccessfulState) {
                    if (state.isLoadMore) {
                      listTransaction.addAll(state.list);
                      if (state.list.isNotEmpty) {
                        Provider.of<TransUserProvider>(context, listen: false)
                            .updateCallLoadMore(true);
                      }
                    } else {
                      if (!state.isLoadingPage) {
                        Navigator.pop(context);
                      }
                      listTransaction = state.list;
                    }
                  }

                  if (state is UpdateNoteFailedState) {
                    DialogWidget.instance
                        .openMsgDialog(title: 'Thông báo', msg: state.message);
                  }

                  if (state is UpdateNoteState) {
                    onSearch(
                        Provider.of<TransUserProvider>(context, listen: false));
                  }
                },
                builder: (context, state) {
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
                              controller: Provider.of<TransUserProvider>(
                                      context,
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
                },
              );
            },
          ),
        ),
      ],
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
              dto.getTitleType(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
          ),
          Consumer<TransUserProvider>(
            builder: (context, provider, child) {
              String note = dto.note;

              return Row(
                children: [
                  Container(
                    width: 120,
                    height: 50,
                    padding: const EdgeInsets.only(left: 8, right: 4),
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: AppColor.GREY_BUTTON),
                            right: BorderSide(color: AppColor.GREY_BUTTON))),
                    child: MTextFieldCustom(
                      hintText: '',
                      keyboardAction: TextInputAction.next,
                      value: dto.note,
                      enable: dto.isEdit,
                      onChange: (value) {
                        dto.note = value;
                      },
                      inputType: TextInputType.text,
                      isObscureText: false,
                      textAlign: TextAlign.center,
                      fontSize: 12,
                      fillColor: AppColor.TRANSPARENT,
                      suffixIcon: dto.isEdit
                          ? GestureDetector(
                              onTap: () {
                                dto.note = note;
                                setState(() {});
                              },
                              child: const Icon(Icons.clear, size: 12),
                            )
                          : null,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      DialogWidget.instance.openContentDialog(() {}, 'Ghi chú',
                          width: 400,
                          child: _buildContentDialogContent(dto, index));
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      child: Icon(
                        Icons.edit,
                        size: 20,
                      ),
                    ),
                  )
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContentDialogContent(TransactionMerchantDTO dto, int index) {
    int indexOfList = index;
    int indexPre = index - 1;
    String note = '';
    FocusNode focusNodeNote = FocusNode();
    TextEditingController noteController = TextEditingController();
    onSaveNote(TransUserProvider provider) {
      if (note.isNotEmpty) {
        String valueNote = '';
        if (provider.hasTag.isNotEmpty) {
          valueNote = '$note ${provider.hasTag}';
        } else {
          valueNote = note;
        }
        Map<String, dynamic> body = {
          'note': valueNote,
          'id': provider.transactionMerchantDTO.id,
        };
        transactionUserBloc.add(UpdateNoteEvent(body));
      } else {
        if (provider.transactionMerchantDTO.note.isNotEmpty) {
          if (provider.hasTag.isNotEmpty) {
            String valueNote = '';
            valueNote =
                '${provider.transactionMerchantDTO.note} ${provider.hasTag}';

            Map<String, dynamic> body = {
              'note': valueNote,
              'id': provider.transactionMerchantDTO.id,
            };

            transactionUserBloc.add(UpdateNoteEvent(body));
          }
        }
      }
    }

    return ChangeNotifierProvider<TransUserProvider>(
      create: (context) => TransUserProvider()..updateTransactionDto(dto),
      child: Consumer<TransUserProvider>(builder: (context, provider2, child) {
        focusNodeNote.requestFocus();
        if (provider2.transactionMerchantDTO.note.isNotEmpty) {
          noteController.text = provider2.transactionMerchantDTO.note;
          if (provider2.hasTag.isNotEmpty) {
            noteController.text = '${noteController.text} ${provider2.hasTag}';
          }
        } else {
          if (provider2.hasTag.isNotEmpty) {
            noteController.text = '${noteController.text} ${provider2.hasTag}';
          } else {
            noteController.text = note;
          }
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                onSaveNote(provider2);
                if (indexPre == 0) {
                  indexPre = listTransaction.length - 1;
                } else {
                  indexPre--;
                }
                indexOfList = indexPre + 1;
                provider2.updateTransactionDto(listTransaction[indexPre],
                    init: false);

                note = '';
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: AppColor.BANK_CARD_COLOR_3,
                    borderRadius: BorderRadius.circular(30)),
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: AppColor.WHITE,
                  size: 18,
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Container(
              width: 400,
              height: 600,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Stack(
                children: [
                  Column(
                    children: [
                      const SizedBox(
                        height: 12,
                      ),
                      const Center(
                          child: Text(
                        'Ghi chú',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      )),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: SizedBox(
                          height: 520,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Thông tin giao dịch',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              _buildInfoItem('Tài khoản:',
                                  '${dto.bankShortName} -${provider2.transactionMerchantDTO.bankAccount}'),
                              const SizedBox(
                                height: 4,
                              ),
                              _buildInfoItem(
                                  'Số tiền:',
                                  provider2.transactionMerchantDTO.transType ==
                                          'D'
                                      ? '- ${StringUtils.formatNumber(provider2.transactionMerchantDTO.amount)} VND'
                                      : '+ ${StringUtils.formatNumber(provider2.transactionMerchantDTO.amount)} VND',
                                  contentColor: provider2.transactionMerchantDTO
                                      .getAmountColor(),
                                  contentFontWeight: FontWeight.bold),
                              const SizedBox(
                                height: 4,
                              ),
                              _buildInfoItem(
                                  'Mã Giao dịch:',
                                  provider2
                                      .transactionMerchantDTO.referenceNumber),
                              const SizedBox(
                                height: 4,
                              ),
                              _buildInfoItem(
                                  'Thời gian tạo:',
                                  TimeUtils.instance.formatTimeDateFromInt(
                                      provider2
                                          .transactionMerchantDTO.timeCreated,
                                      oneLine: true)),
                              const SizedBox(
                                height: 4,
                              ),
                              _buildInfoItem(
                                  'Thời gian TT:',
                                  TimeUtils.instance.formatTimeDateFromInt(
                                      provider2.transactionMerchantDTO.timePaid,
                                      oneLine: true)),
                              const SizedBox(
                                height: 4,
                              ),
                              _buildInfoItem('Nội dung:',
                                  provider2.transactionMerchantDTO.content),
                              const SizedBox(
                                height: 16,
                              ),
                              const Text(
                                'Ghi chú',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Container(
                                height: 108,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 12),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        color: AppColor.GREY_BUTTON)),
                                child: MTextFieldCustom(
                                  autoFocus: true,
                                  focusNode: focusNodeNote,
                                  hintText: 'Nhập nội dung ghi chú tại đây',
                                  keyboardAction: TextInputAction.done,
                                  controller: noteController,
                                  enable: true,
                                  onChange: (value) {
                                    note = value;
                                  },
                                  inputType: TextInputType.text,
                                  isObscureText: false,
                                  maxLines: 5,
                                  textAlign: TextAlign.left,
                                  fontSize: 14,
                                  onSubmitted: (value) {
                                    Navigator.pop(context);
                                    onSaveNote(provider2);
                                  },
                                  fillColor: AppColor.TRANSPARENT,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Expanded(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Ghi chú',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      width: 16,
                                    ),
                                    Expanded(
                                        child: _buildListHasTag(
                                            provider2.hasTag,
                                            provider2.transactionMerchantDTO
                                                        .transType ==
                                                    'D'
                                                ? hasTagOutCome
                                                : hasTagInCome, onTab: (value) {
                                      provider2.changeHasTag(value);
                                    }))
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ButtonWidget(
                                    text: 'Hủy',
                                    width: 120,
                                    textColor: AppColor.BLUE_TEXT,
                                    bgColor:
                                        AppColor.BLUE_TEXT.withOpacity(0.3),
                                    function: () {
                                      Navigator.pop(context);
                                    },
                                    borderRadius: 5,
                                    height: 40,
                                  ),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  ButtonWidget(
                                    text: 'Lưu',
                                    width: 120,
                                    textColor: AppColor.WHITE,
                                    bgColor: AppColor.BLUE_TEXT,
                                    function: () {
                                      Navigator.pop(context);
                                      onSaveNote(provider2);
                                    },
                                    borderRadius: 5,
                                    height: 40,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 25,
                        height: 25,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Theme.of(context).canvasColor,
                        ),
                        child: const Icon(
                          Icons.close_rounded,
                          color: AppColor.BLACK,
                          size: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            InkWell(
              onTap: () {
                onSaveNote(provider2);
                indexPre = indexOfList;
                provider2.updateTransactionDto(listTransaction[indexOfList],
                    init: false);

                note = '';
                if (indexOfList == listTransaction.length - 1) {
                  indexOfList = 0;
                } else {
                  indexOfList++;
                }
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: AppColor.BANK_CARD_COLOR_3,
                    borderRadius: BorderRadius.circular(30)),
                child: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: AppColor.WHITE,
                  size: 18,
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildListHasTag(String value, List<String> hasTag,
      {required Function(String) onTab}) {
    return Wrap(
      spacing: 12,
      runSpacing: 6,
      children: hasTag.map((e) {
        return InkWell(
          onTap: () {
            onTab(e);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
                border: Border.all(
                    color: e == value ? AppColor.BLUE_TEXT : AppColor.WHITE),
                borderRadius: BorderRadius.circular(30),
                color: AppColor.GREY_BUTTON),
            child: Text(
              e,
              style: const TextStyle(fontSize: 11),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildInfoItem(String title, String content,
      {Color? contentColor, FontWeight contentFontWeight = FontWeight.normal}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            child: Text(
          title,
          style: const TextStyle(fontSize: 12),
        )),
        Expanded(
            flex: 3,
            child: Text(
              content.isNotEmpty ? content : '-',
              style: TextStyle(
                  color: contentColor,
                  fontWeight: contentFontWeight,
                  fontSize: 12),
            )),
      ],
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
          _buildItemTitle('Ghi chú',
              height: 50,
              width: 120,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.center),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: const Icon(
              Icons.edit,
              color: Colors.transparent,
              size: 20,
            ),
          ),
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
                      if (value.id.type == TypeFilter.ALL) {
                        onSearch(provider);
                      }
                      if (value.id.type == TypeFilter.BANK_NUMBER) {
                        provider.changeBankAccount(provider.bankAccounts.first);
                        onSearch(provider);
                      }
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
                      if (value.id != TypeTimeFilter.PERIOD.id &&
                          provider.valueFilter.id.type !=
                              TypeFilter.CODE_SALE) {
                        onSearch(provider);
                      }
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
            if (provider.valueTimeFilter.id == TypeTimeFilter.PERIOD.id) ...[
              InkWell(
                onTap: () async {
                  DateTime? date = await showDateTimePicker(
                    context: context,
                    initialDate: provider.fromDate,
                    firstDate: DateTime(2021, 6),
                    lastDate: DateTime.now(),
                  );

                  int numberOfMonths = monthCalculator.calculateMonths(
                      date ?? DateTime.now(), provider.toDate);

                  if (numberOfMonths > 3) {
                    DialogWidget.instance.openMsgDialog(
                        title: 'Cảnh báo',
                        msg:
                            'Vui lòng nhập khoảng thời gian tối đa là 3 tháng.');
                  } else if ((date ?? DateTime.now())
                      .isAfter(provider.fromDate)) {
                    DialogWidget.instance.openMsgDialog(
                        title: 'Cảnh báo',
                        msg: 'Vui lòng kiểm tra lại khoảng thời gian.');
                  } else {
                    provider.updateFromDate(date ?? DateTime.now());
                  }
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
                        style:
                            TextStyle(fontSize: 11, color: AppColor.GREY_TEXT),
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
                    firstDate: DateTime(2021, 6),
                    lastDate: DateTime.now(),
                  );
                  int numberOfMonths = monthCalculator.calculateMonths(
                      provider.fromDate, date ?? DateTime.now());

                  if (numberOfMonths > 3) {
                    DialogWidget.instance.openMsgDialog(
                        title: 'Cảnh báo',
                        msg:
                            'Vui lòng nhập khoảng thời gian tối đa là 3 tháng.');
                  } else if ((date ?? DateTime.now())
                      .isBefore(provider.fromDate)) {
                    DialogWidget.instance.openMsgDialog(
                        title: 'Cảnh báo',
                        msg: 'Vui lòng kiểm tra lại khoảng thời gian.');
                  } else {
                    provider.updateToDate(date ?? DateTime.now());
                  }
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
                        style:
                            TextStyle(fontSize: 11, color: AppColor.GREY_TEXT),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        TimeUtils.instance.formatDateToString(provider.toDate),
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
            if (provider.valueFilter.id.type == TypeFilter.BANK_NUMBER) ...[
              Container(
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
                      'Số tài khoản',
                      style: TextStyle(fontSize: 11, color: AppColor.GREY_TEXT),
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
                        onSearch(provider);
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
            ],
            if (provider.valueFilter.id.type != TypeFilter.ALL &&
                provider.valueFilter.id.type != TypeFilter.BANK_NUMBER)
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
            if (provider.valueFilter.id.type != TypeFilter.ALL ||
                provider.valueTimeFilter.id == TypeTimeFilter.PERIOD.id)
              InkWell(
                onTap: () {
                  onSearch(provider);
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
            if (provider.valueTimeFilter.id == TypeTimeFilter.PERIOD.id)
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

  void onSearch(TransUserProvider provider) {
    if (provider.fromDate.millisecondsSinceEpoch <=
        provider.toDate.millisecondsSinceEpoch) {
      provider.updateCallLoadMore(true);
      Map<String, dynamic> param = {};
      provider.updateOffset(0);
      param['type'] = provider.valueFilter.id;
      param['userId'] = UserInformationHelper.instance.getUserId();
      // if (provider.valueTimeFilter.id == TypeTimeFilter.ALL.id ||
      //     (provider.valueFilter.id.type != TypeFilter.BANK_NUMBER &&
      //         provider.valueFilter.id.type != TypeFilter.ALL &&
      //         provider.valueFilter.id.type != TypeFilter.CODE_SALE)) {
      //   param['from'] = '0';
      //   param['to'] = '0';
      // } else {
      //   param['from'] = TimeUtils.instance.getCurrentDate(provider.fromDate);
      //   param['to'] = TimeUtils.instance.getCurrentDate(provider.toDate);
      // }
      param['from'] = TimeUtils.instance.getCurrentDate(provider.fromDate);
      param['to'] = TimeUtils.instance.getCurrentDate(provider.toDate);
      param['value'] = provider.keywordSearch;

      param['offset'] = provider.offset;
      param['merchantId'] =
          Session.instance.accountIsMerchantDTO.customerSyncId;

      transactionUserBloc.add(GetListTransactionByEvent(param: param));
    } else {
      DialogWidget.instance.openMsgDialog(
          title: 'Không hợp lệ',
          msg: 'Ngày bắt đầu không được lớn hơn ngày kết thúc');
    }
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

    if (!mounted) return selectedDate;

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
