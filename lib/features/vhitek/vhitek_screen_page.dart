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
  @override
  void initState() {
    super.initState();
    _vhitekBloc = VhitekBloc();
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
        context.read<ActiveVhitekProvider>().getListBankAccount();
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
                  const MenuLeft(
                    currentType: MenuHomeType.MERCHANT_REQUEST,
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
                                  context
                                      .read<ActiveVhitekProvider>()
                                      .changePage(2);
                                  context
                                      .read<ActiveVhitekProvider>()
                                      .changeUserIdVhitek(state.dto.message);
                                  _animatedToPage(2);
                                } else if (state.dto.status == 'CHECK') {
                                  if (state.dto.message == 'C09') {
                                    DialogWidget.instance.openMsgDialog(
                                        title: 'Đã kích hoạt',
                                        msg:
                                            'Máy bán hàng đã được kích hoạt trước đó.');
                                  } else {
                                    context
                                        .read<ActiveVhitekProvider>()
                                        .changePage(1);
                                    _animatedToPage(1);
                                  }
                                } else {
                                  DialogWidget.instance.openMsgDialog(
                                      title: 'Lỗi',
                                      msg: ErrorUtils.instance
                                          .getErrorMessage(state.dto.message));
                                }
                              }
                              if (state is LoginByUserIdSuccessState) {
                                context
                                    .read<ActiveVhitekProvider>()
                                    .getListBankAccount();
                              }
                              if (state is VhitekCreateUserSuccessState) {
                                Navigator.pop(context);
                                if (state.dto.status == 'SUCCESS') {
                                  context
                                      .read<ActiveVhitekProvider>()
                                      .changePage(2);
                                  context
                                      .read<ActiveVhitekProvider>()
                                      .changeUserIdVhitek(state.dto.message);
                                  _animatedToPage(2);
                                } else {
                                  DialogWidget.instance.openMsgDialog(
                                      title: 'Lỗi',
                                      msg: ErrorUtils.instance
                                          .getErrorMessage(state.dto.message));
                                }
                              }
                              if (state is VhitekActiveSuccessState) {
                                Navigator.pop(context);
                                if (state.dto.status == 'SUCCESS') {
                                  context
                                      .read<ActiveVhitekProvider>()
                                      .changePage(3);
                                  _animatedToPage(3);
                                } else {
                                  DialogWidget.instance.openMsgDialog(
                                      title: 'Lỗi',
                                      msg: ErrorUtils.instance
                                          .getErrorMessage(state.dto.message));
                                }
                              }
                            }, builder: (context, state) {
                              return Column(
                                children: [
                                  if (state is VhitekLoginLoadingState)
                                    const Padding(
                                      padding: EdgeInsets.only(top: 40),
                                      child: Center(
                                          child: CircularProgressIndicator()),
                                    )
                                  else ...[
                                    Expanded(child: Center(
                                      child: LayoutBuilder(
                                          builder: (context, constraints) {
                                        return SizedBox(
                                          width: constraints.maxWidth > 700
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
                                              ),
                                              RegisterVhitek(
                                                edit: () {
                                                  _animatedToPage(0);
                                                },
                                              ),
                                              ConfirmActive(
                                                edit: () {
                                                  _animatedToPage(0);
                                                },
                                              ),
                                              const ActiveSuccess()
                                            ],
                                          ),
                                        );
                                      }),
                                    )),
                                    LayoutBuilder(
                                        builder: (context, constraints) {
                                      return SizedBox(
                                        width: constraints.maxWidth > 700
                                            ? 600
                                            : constraints.maxWidth,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 28, vertical: 20),
                                          child: _buildButton(),
                                        ),
                                      );
                                    })
                                  ]
                                ],
                              );
                            }),
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

  Widget _buildButton() {
    return Consumer<ActiveVhitekProvider>(builder: (context, provider, child) {
      if (provider.page == 0) {
        return ButtonWidget(
            text: 'Tiếp theo',
            textColor: AppColor.WHITE,
            borderRadius: 5,
            bgColor: AppColor.BLUE_TEXT,
            function: () {
              if (provider.bankAccountDTO.bankAccount.isEmpty) {
                DialogWidget.instance.openMsgDialog(
                    title: 'Cảnh báo',
                    msg: 'Vui lòng chọn tài khoản ngân hàng');
              } else if (provider.mid.isEmpty ||
                  provider.midAddress.isEmpty ||
                  provider.email.isEmpty) {
                DialogWidget.instance.openMsgDialog(
                    title: 'Cảnh báo',
                    msg: 'Vui lòng nhập đầy đủ thông tin trên form');
              } else {
                _vhitekBloc.add(CheckUserValidEvent(email: provider.email));
              }
            });
      } else if (provider.page == 1) {
        return ButtonWidget(
            text: 'Đăng kí',
            textColor: AppColor.WHITE,
            borderRadius: 5,
            bgColor: AppColor.BLUE_TEXT,
            function: () {
              provider.checkErrPassword();
              if (provider.email.isEmpty ||
                  provider.userName.isEmpty ||
                  provider.phoneNumber.isEmpty ||
                  provider.password.isEmpty) {
                DialogWidget.instance.openMsgDialog(
                    title: 'Cảnh báo',
                    msg: 'Vui lòng nhập đầy đủ thông tin trên form');
              } else if (provider.isErrPasswordConfirm) {
                DialogWidget.instance.openMsgDialog(
                    title: 'Cảnh báo', msg: 'Mật khẩu không trùng nhau');
              } else {
                if (!provider.isErrPassword) {
                  Map<String, dynamic> param = {};
                  param['userId'] =
                      UserInformationHelper.instance.getUserId().trim();
                  param['email'] = provider.email;
                  param['phoneNo'] = provider.phoneNumber;
                  param['password'] = provider.password;
                  param['name'] = provider.userName;
                  _vhitekBloc.add(CreateUserEvent(param: param));
                }
              }
            });
      } else if (provider.page == 2) {
        return ButtonWidget(
            text: 'Kích hoạt',
            textColor: AppColor.WHITE,
            borderRadius: 5,
            bgColor: AppColor.BLUE_TEXT,
            function: () {
              Map<String, dynamic> param = {};
              param['userId'] =
                  UserInformationHelper.instance.getUserId().trim();
              param['mid'] = provider.mid;
              param['address'] = provider.midAddress;
              param['userIdVhitek'] = provider.userIdVhitek;
              param['bankAccount'] = provider.bankAccountDTO.bankAccount;
              param['userBankName'] = provider.bankAccountDTO.userBankName;
              param['bankId'] = provider.bankAccountDTO.id;
              print(
                  '-------------------------------------${provider.bankAccountDTO.toJson()}');
              _vhitekBloc.add(ActiveEvent(param: param));
            });
      } else if (provider.page == 3) {
        return ButtonWidget(
            text: 'Hoàn tất',
            textColor: AppColor.WHITE,
            borderRadius: 5,
            bgColor: AppColor.BLUE_TEXT,
            function: () {
              js.context.callMethod('sendDataToFlutter', ['CLOSE_WEB', '*']);
              context.push('/home');
            });
      }

      return const SizedBox.shrink();
    });
  }

  Widget _buildHeader() {
    return Column(
      children: [
        const SizedBox(
          height: 12,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              GestureDetector(
                  onTap: () {
                    // Navigator.pop(context);
                    context.push('/home');
                  },
                  child: const Icon(
                    Icons.close,
                    size: 20,
                    color: AppColor.BLACK_BUTTON,
                  )),
              const Spacer(),
              Image(
                image:
                    ImageUtils.instance.getImageNetWork(AppImages.logoVietqrVn),
                height: 40,
              )
            ],
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        DividerWidget(
          width: double.infinity,
          color: AppColor.BLACK_BUTTON.withOpacity(0.2),
        ),
      ],
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
            title: 'KÍCH HOẠT MÁY BÁN HÀNG',
            isSelect: true,
            showBottomBorder: true,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
