import 'dart:js' as js;

import 'package:VietQR/commons/constants/configurations/app_image.dart';
import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/enums/type_menu_home.dart';
import 'package:VietQR/commons/utils/error_utils.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/commons/widgets/button_widget.dart';
import 'package:VietQR/commons/widgets/dialog_widget.dart';
import 'package:VietQR/commons/widgets/divider_widget.dart';
import 'package:VietQR/commons/widgets/header/header_widget.dart';
import 'package:VietQR/features/dashboard/views/menu_left.dart';
import 'package:VietQR/features/home/widget/item_menu_home.dart';
import 'package:VietQR/features/vhitek/blocs/vhitek_bloc.dart';
import 'package:VietQR/features/vhitek/page/active_success.dart';
import 'package:VietQR/features/vhitek/page/active_vhitek.dart';
import 'package:VietQR/features/vhitek/page/confirm_active.dart';
import 'package:VietQR/features/vhitek/page/register_vhitek.dart';
import 'package:VietQR/features/vhitek/provider/active_vhitek_provider.dart';
import 'package:VietQR/features/vhitek/states/vhitek_state.dart';
import 'package:VietQR/services/shared_references/user_information_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../home/widget/item_menu_top.dart';
import 'events/vhitek_event.dart';

class VhitekPage extends StatelessWidget {
  final String mid;
  final String path;

  const VhitekPage({super.key, this.mid = '', this.path = ''});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ActiveVhitekProvider>(
        create: (contextProvider) => ActiveVhitekProvider(),
        child: _VhitekScreen(
          mid: mid,
          path: path,
        ));
  }
}

class _VhitekScreen extends StatefulWidget {
  final String mid;
  final String path;

  const _VhitekScreen({super.key, this.mid = '', this.path = ''});

  @override
  State<_VhitekScreen> createState() => _VhitekState();
}

class _VhitekState extends State<_VhitekScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  late VhitekBloc _vhitekBloc;
  String userId = '';
  late ActiveVhitekProvider _provider;

  @override
  void initState() {
    super.initState();
    _vhitekBloc = VhitekBloc();
    _provider = Provider.of<ActiveVhitekProvider>(context, listen: false);
  }

  @override
  void didChangeDependencies() {
    if (js.context['state'] != null) {
      var state = js.JsObject.fromBrowserObject(js.context['state']);
      userId = state['userId'];
      _vhitekBloc.add(LoginByUserIdEvent(userId: userId));
    } else {
      if (UserInformationHelper.instance.getUserId().trim().isEmpty) {
        Map<String, dynamic> param = {};
        if (widget.path.isNotEmpty) {
          param['pathHistory'] = widget.path;
        } else {
          param['pathHistory'] = '/service/vhitek/active';
        }
        context.push('/login', extra: param);
      } else {
        _provider.getListBankAccount();
      }
    }

    super.didChangeDependencies();
  }

  void _animatedToPage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOutQuart,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
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
                  MenuLeft(
                    currentType: MenuHomeType.MERCHANT_REQUEST,
                    subMenuMerchantRequest: [
                      ItemMenuHome(
                        title: 'API SERVICE',
                        isSelect: false,
                        onTap: () {
                          context.go('/merchant/request');
                        },
                      ),
                      ItemMenuHome(
                        title: 'ECOMMERCE',
                        isSelect: false,
                        onTap: () {
                          context.go('/merchant/request/ecommerce');
                        },
                      ),
                      ItemMenuHome(
                        title: 'KẾT NỐI MÁY BÁN HÀNG',
                        isSelect: true,
                        onTap: () {},
                      ),
                      if (UserInformationHelper.instance
                          .getCustomerSyncTestId()
                          .trim()
                          .isNotEmpty)
                        ItemMenuHome(
                          title: 'TEST CALLBACK',
                          isSelect: false,
                          onTap: () {
                            context.go('/merchant/callback');
                          },
                        ),
                    ],
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        _buildTitle(),
                        Expanded(
                          child: BlocProvider<VhitekBloc>(
                            create: (context) => _vhitekBloc,
                            child: BlocConsumer<VhitekBloc, VhitekState>(
                              listener: (context, state) {
                                if (state is VhitekStateLoadingState) {
                                  DialogWidget.instance.openLoadingDialog();
                                }
                                if (state is VhitekCheckUserValidSuccessState) {
                                  Navigator.pop(context);
                                  if (state.dto.status == 'SUCCESS') {
                                    _provider.changePage(2);
                                    _provider
                                        .changeUserIdVhitek(state.dto.message);
                                    _animatedToPage(2);
                                  } else if (state.dto.status == 'CHECK') {
                                    if (state.dto.message == 'C09') {
                                      DialogWidget.instance.openMsgDialog(
                                          title: 'Đã kích hoạt',
                                          msg:
                                              'Máy bán hàng đã được kích hoạt trước đó.');
                                    } else {
                                      _provider.changePage(1);
                                      _animatedToPage(1);
                                    }
                                  } else {
                                    DialogWidget.instance.openMsgDialog(
                                        title: 'Lỗi',
                                        msg: ErrorUtils.instance
                                            .getErrorMessage(
                                                state.dto.message));
                                  }
                                }
                                if (state is LoginByUserIdSuccessState) {
                                  _provider.getListBankAccount();
                                }
                                if (state is VhitekCreateUserSuccessState) {
                                  Navigator.pop(context);
                                  if (state.dto.status == 'SUCCESS') {
                                    _provider.changePage(2);
                                    _provider
                                        .changeUserIdVhitek(state.dto.message);
                                    _animatedToPage(2);
                                  } else {
                                    DialogWidget.instance.openMsgDialog(
                                        title: 'Lỗi',
                                        msg: ErrorUtils.instance
                                            .getErrorMessage(
                                                state.dto.message));
                                  }
                                }
                                if (state is VhitekActiveSuccessState) {
                                  Navigator.pop(context);
                                  if (state.dto.status == 'SUCCESS') {
                                    _provider.changePage(3);
                                    _animatedToPage(3);
                                  } else {
                                    DialogWidget.instance.openMsgDialog(
                                        title: 'Lỗi',
                                        msg: ErrorUtils.instance
                                            .getErrorMessage(
                                                state.dto.message));
                                  }
                                }
                              },
                              builder: (context, state) {
                                return Column(
                                  children: [
                                    if (state is VhitekLoginLoadingState)
                                      const Padding(
                                        padding: EdgeInsets.only(top: 40),
                                        child: Center(
                                            child: CircularProgressIndicator()),
                                      )
                                    else ...[
                                      Expanded(
                                        child: Center(
                                          child: LayoutBuilder(
                                            builder: (context, constraints) {
                                              return SizedBox(
                                                width:
                                                    constraints.maxWidth > 700
                                                        ? 600
                                                        : constraints.maxWidth,
                                                child: PageView(
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  controller: _pageController,
                                                  onPageChanged: (index) {},
                                                  children: [
                                                    ActiveVhitek(
                                                      mid: widget.mid,
                                                      callBack: (bankDTO) {
                                                        _provider
                                                            .updateBankAccountDTO(
                                                                bankDTO);
                                                        _vhitekBloc.add(
                                                            GetTerminalsEvent(
                                                                _provider
                                                                    .bankAccountDTO
                                                                    .bankId));
                                                      },
                                                      onChanged: (code, address,
                                                          email, dto) {},
                                                    ),
                                                    RegisterVhitek(
                                                      edit: onEdit,
                                                      onChanged:
                                                          _onChangeRegister,
                                                    ),
                                                    ConfirmActive(
                                                      edit: onEdit,
                                                      mid: _provider.mid,
                                                      email: _provider.email,
                                                      userIdVhitek: _provider
                                                          .userIdVhitek,
                                                      midAddress:
                                                          _provider.midAddress,
                                                      dto: _provider
                                                          .bankAccountDTO,
                                                    ),
                                                    ActiveSuccess(edit: onEdit),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ]
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
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
            isSelect: true,
            showBottomBorder: true,
            onTap: () {},
          ),
          if (UserInformationHelper.instance
              .getCustomerSyncTestId()
              .trim()
              .isNotEmpty)
            ItemMenuTop(
              title: 'TEST CALLBACK',
              isSelect: false,
              onTap: () {
                context.go('/merchant/callback');
              },
            ),
        ],
      ),
    );
  }

  _onChangeRegister(userId, email, phoneNumber, password, userName) {
    _provider.changeUserIdVhitek(userId);
    _provider.changeEmail(email);
    _provider.changePhoneNumber(phoneNumber);
    _provider.changePassword(password);
    _provider.changeUserName(userName);
  }

  onEdit(int value) {
    _provider.changePage(value);
    _animatedToPage(0);
  }
}
