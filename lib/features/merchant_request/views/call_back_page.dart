import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/enums/type_menu_home.dart';
import 'package:VietQR/commons/utils/custom_scroll.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/commons/utils/string_utils.dart';
import 'package:VietQR/commons/widgets/dialog_widget.dart';
import 'package:VietQR/commons/widgets/header/header_widget.dart';
import 'package:VietQR/features/dashboard/views/menu_left.dart';
import 'package:VietQR/features/home/widget/item_menu_top.dart';
import 'package:VietQR/features/merchant_request/blocs/run_callback_bloc.dart';
import 'package:VietQR/features/merchant_request/states/run_call_back_state.dart';
import 'package:VietQR/models/api_service_dto.dart';
import 'package:VietQR/models/bank_account_dto.dart';
import 'package:VietQR/models/callback_dto.dart';
import 'package:VietQR/services/shared_references/user_information_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../events/run_callback_event.dart';

class CallbackPage extends StatefulWidget {
  const CallbackPage({Key? key}) : super(key: key);

  @override
  State<CallbackPage> createState() => _CallbackPageState();
}

class _CallbackPageState extends State<CallbackPage> {
  final TextEditingController hostingController = TextEditingController();
  BankAccountDTO _bankAccountDTO = BankAccountDTO();
  List<CallBackDTO> listTrans = [];
  ApiServiceDTO _apiServiceDTO = ApiServiceDTO();
  CallBackDTO _callBackDTO = CallBackDTO();
  late RunCallbackBloc _bloc;
  @override
  void initState() {
    _bloc = RunCallbackBloc()
      ..add(GetListBankEvent(
          customerId: UserInformationHelper.instance.getCustomerSyncTestId()));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: BlocProvider<RunCallbackBloc>(
        create: (context) => _bloc,
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColor.WHITE,
                AppColor.BLUE_LIGHT,
              ],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            ),
          ),
          child: Column(
            children: [
              const HeaderWidget(),
              Expanded(
                child: Row(
                  children: [
                    const MenuLeft(
                      currentType: MenuHomeType.MERCHANT_REQUEST,
                    ),
                    Expanded(
                      child: BlocConsumer<RunCallbackBloc, RunCallBackState>(
                          listener: (context, state) {
                        if (state is GetListBankSuccessfulState) {
                          _bankAccountDTO = state.result.first;
                          _bloc.add(GetTransEvent(
                              customerId: UserInformationHelper.instance
                                  .getCustomerSyncTestId(),
                              bankId: _bankAccountDTO.bankId));
                        }

                        if (state is GetListTransSuccessfulState) {
                          listTrans = state.listTrans;
                        }
                        if (state is CallbackLoadingState) {
                          DialogWidget.instance.openLoadingDialog();
                        }
                        if (state is GetInfoSuccessfulState) {
                          _apiServiceDTO = state.result;
                          if (state.result.id.isNotEmpty) {
                            _bloc.add(
                              GetTokenEvent(
                                systemUsername: state.result.systemUsername,
                                systemPassword: state.result.systemPassword,
                              ),
                            );
                          }
                        }
                        if (state is RequestTokenFailedState) {
                          Navigator.pop(context);
                          DialogWidget.instance.openMsgDialog(
                              title: 'Lỗi',
                              msg: 'Đã có lỗi xảy ra vui lòng thử lại sau');
                        }
                        if (state is RequestTokenSuccessState) {
                          final Map<String, dynamic> body = {
                            'bankAccount': _callBackDTO.bankAccount,
                            'content': _callBackDTO.content,
                            'amount': _callBackDTO.amount,
                            'transType': _callBackDTO.transType,
                          };

                          _bloc.add(RunCallbackEvent(body));
                        }
                        if (state is RunCallBackFailedState) {
                          Navigator.pop(context);
                          _bloc.add(GetTransEvent(
                              customerId: UserInformationHelper.instance
                                  .getCustomerSyncTestId(),
                              bankId: _bankAccountDTO.bankId));
                          DialogWidget.instance.openMsgDialog(
                              title: 'Lỗi',
                              msg: state.result.message,
                              titleColor: AppColor.RED_TEXT,
                              msgColor: AppColor.RED_TEXT);
                        }
                        if (state is RunCallBackSuccessState) {
                          Navigator.pop(context);
                          _bloc.add(GetTransEvent(
                              customerId: UserInformationHelper.instance
                                  .getCustomerSyncTestId(),
                              bankId: _bankAccountDTO.bankId));
                          DialogWidget.instance.openMsgDialog(
                              title: 'Thành công', msg: state.result.message);
                        }
                      }, builder: (context, state) {
                        if (state is GetListBankLoadingState) {
                          return const Center(
                              child: UnconstrainedBox(
                            child: SizedBox(
                              width: 50,
                              height: 50,
                              child: CircularProgressIndicator(
                                color: AppColor.BLUE_TEXT,
                              ),
                            ),
                          ));
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTitle(context),
                            _buildBankAccount(),
                            const SizedBox(
                              height: 16,
                            ),
                            Expanded(
                              child: ScrollConfiguration(
                                behavior: MyCustomScrollBehavior(),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Column(
                                    children: [
                                      _buildTitleItem(),
                                      Expanded(
                                          child: SingleChildScrollView(
                                        child: Column(
                                          children: listTrans.map((e) {
                                            int index = listTrans.indexOf(e);
                                            return _buildItem(e, index);
                                          }).toList(),
                                        ),
                                      ))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItem(CallBackDTO dto, int index) {
    return Container(
      color: index % 2 == 0 ? AppColor.GREY_BG : AppColor.WHITE,
      alignment: Alignment.center,
      child: Row(
        children: [
          _buildItemContent('${index + 1}'),
          _buildItemContent(dto.createdTime, width: 160),
          _buildItemContent(dto.bankAccount ?? '', width: 140),
          _buildItemContent(
              dto.transType == 'D'
                  ? '- ${StringUtils.formatNumberAmount(dto.amount)}'
                  : '+ ${StringUtils.formatNumberAmount(dto.amount)}',
              width: 140),
          _buildItemContent(dto.getStatus, width: 100),
          _buildItemContent(dto.content ?? '', width: 280),
          _buildItemContent(dto.status == 0 ? 'Chạy callback' : '-',
              width: 120, textColor: AppColor.BLUE_TEXT, onTab: () {
            _callBackDTO = dto;
            _bloc.add(
              GetInfoConnectEvent(
                  platform: 'API service',
                  id: UserInformationHelper.instance.getCustomerSyncTestId()),
            );
          }),
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
          _buildItemTitle('Thời gian tạo',
              height: 50,
              width: 160,
              padding: const EdgeInsets.only(left: 12),
              alignment: Alignment.center),
          _buildItemTitle('Số tài khoản',
              height: 50,
              width: 140,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.center),
          _buildItemTitle('Giao dịch',
              height: 50,
              width: 140,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.center),
          _buildItemTitle('Trạng thái',
              height: 50,
              width: 100,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.center),
          _buildItemTitle('Nội dung',
              height: 50,
              width: 280,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.center),
          _buildItemTitle('Action',
              height: 50,
              width: 120,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.center),
        ],
      ),
    );
  }

  Widget _buildItemContent(String title,
      {double width = 50,
      height = 50,
      VoidCallback? onTab,
      Color textColor = AppColor.BLACK}) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(color: AppColor.GREY_BUTTON),
              right: BorderSide(color: AppColor.GREY_BUTTON))),
      width: width,
      height: height,
      alignment: Alignment.center,
      child: InkWell(
        onTap: onTab,
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, color: textColor),
        ),
      ),
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

  Widget _buildBankAccount() {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Tài khoản ngân hàng đã kết nối'),
          const SizedBox(
            height: 4,
          ),
          Container(
            padding:
                const EdgeInsets.only(top: 8, right: 12, left: 8, bottom: 8),
            decoration: BoxDecoration(
                color: AppColor.WHITE,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.grey.withOpacity(0.5))),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_bankAccountDTO.imgId.isNotEmpty)
                  Image(
                    height: 20,
                    fit: BoxFit.fitHeight,
                    image: ImageUtils.instance
                        .getImageNetWork(_bankAccountDTO.imgId),
                  ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${_bankAccountDTO.bankShortName} - ${_bankAccountDTO.bankAccount}',
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _bankAccountDTO.customerBankName,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: AppColor.BLUE_TEXT.withOpacity(0.1)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ItemMenuTop(
            title: 'API SERVICE',
            isSelect: false,
            onTap: () {
              context.go('/merchant/request');
            },
          ),
          const SizedBox(
            width: 16,
          ),
          ItemMenuTop(
            title: 'ECOMMERCE',
            isSelect: false,
            onTap: () {
              context.go('/merchant/request/ecommerce');
            },
          ),
          const SizedBox(
            width: 16,
          ),
          ItemMenuTop(
            title: 'KẾT NỐI MÁY BÁN HÀNG',
            onTap: () {
              context.go('/merchant/request/mbh');
            },
          ),
          if (UserInformationHelper.instance
              .getCustomerSyncTestId()
              .trim()
              .isNotEmpty)
            ItemMenuTop(
              title: 'TEST CALLBACK',
              isSelect: true,
              showBottomBorder: true,
              onTap: () {},
            ),
        ],
      ),
    );
  }
}
