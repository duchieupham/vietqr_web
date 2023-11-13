import 'dart:html' as html;
import 'dart:js' as js;

import 'package:VietQR/commons/constants/configurations/app_image.dart';
import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/error_utils.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/commons/widgets/button_widget.dart';
import 'package:VietQR/commons/widgets/dialog_widget.dart';
import 'package:VietQR/commons/widgets/divider_widget.dart';
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

import 'events/vhitek_event.dart';

class VhitekScreen extends StatelessWidget {
  final String mid;

  const VhitekScreen({super.key, this.mid = ''});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ActiveVhitekProvider>(
        create: (contextProvider) => ActiveVhitekProvider(),
        child: _VhitekScreen(
          mid: mid,
        ));
  }
}

class _VhitekScreen extends StatefulWidget {
  final String mid;

  const _VhitekScreen({super.key, this.mid = ''});

  @override
  State<_VhitekScreen> createState() => _VhitekState();
}

class _VhitekState extends State<_VhitekScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  late VhitekBloc _vhitekBloc;

  @override
  void initState() {
    super.initState();
    _vhitekBloc = VhitekBloc();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (js.context['state'] != null) {
        var state = js.JsObject.fromBrowserObject(js.context['state']);
        String userId = state['userId'];
        _vhitekBloc.add(LoginByUserIdEvent(userId: userId));
      }
    });
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
    return BlocProvider<VhitekBloc>(
      create: (context) => _vhitekBloc,
      child: Scaffold(
        backgroundColor: AppColor.GREY_BG,
        body: BlocConsumer<VhitekBloc, VhitekState>(listener: (context, state) {
          if (state is VhitekStateLoadingState) {
            DialogWidget.instance.openLoadingDialog();
          }
          if (state is VhitekCheckUserValidSuccessState) {
            Navigator.pop(context);
            if (state.dto.status == 'SUCCESS') {
              context.read<ActiveVhitekProvider>().changePage(2);
              context
                  .read<ActiveVhitekProvider>()
                  .changeUserIdVhitek(state.dto.message);
              _animatedToPage(2);
            } else if (state.dto.status == 'CHECK') {
              if (state.dto.message == 'C09') {
                DialogWidget.instance.openMsgDialog(
                    title: 'Đã kích hoạt',
                    msg: 'Máy bán hàng đã được kích hoạt trước đó.');
              } else {
                context.read<ActiveVhitekProvider>().changePage(1);
                _animatedToPage(1);
              }
            } else {
              DialogWidget.instance.openMsgDialog(
                  title: 'Lỗi',
                  msg: ErrorUtils.instance.getErrorMessage(state.dto.message));
            }
          }
          if (state is VhitekCreateUserSuccessState) {
            Navigator.pop(context);
            if (state.dto.status == 'SUCCESS') {
              context.read<ActiveVhitekProvider>().changePage(2);
              context
                  .read<ActiveVhitekProvider>()
                  .changeUserIdVhitek(state.dto.message);
              _animatedToPage(2);
            } else {
              DialogWidget.instance.openMsgDialog(
                  title: 'Lỗi',
                  msg: ErrorUtils.instance.getErrorMessage(state.dto.message));
            }
          }
          if (state is VhitekActiveSuccessState) {
            Navigator.pop(context);
            if (state.dto.status == 'SUCCESS') {
              context.read<ActiveVhitekProvider>().changePage(3);
              _animatedToPage(3);
            } else {
              DialogWidget.instance.openMsgDialog(
                  title: 'Lỗi',
                  msg: ErrorUtils.instance.getErrorMessage(state.dto.message));
            }
          }
        }, builder: (context, state) {
          return Column(
            children: [
              _buildHeader(),
              if (state is VhitekLoginLoadingState)
                const Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: Center(child: CircularProgressIndicator()),
                )
              else ...[
                Expanded(child: LayoutBuilder(builder: (context, constraints) {
                  return SizedBox(
                    width:
                        constraints.maxWidth > 700 ? 600 : constraints.maxWidth,
                    child: PageView(
                      physics: const NeverScrollableScrollPhysics(),
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
                            _animatedToPage(1);
                          },
                        ),
                        const ActiveSuccess()
                      ],
                    ),
                  );
                })),
                LayoutBuilder(builder: (context, constraints) {
                  return SizedBox(
                    width:
                        constraints.maxWidth > 700 ? 600 : constraints.maxWidth,
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
              if (provider.mid.isEmpty ||
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
              _vhitekBloc.add(ActiveEvent(param: param));
            });
      } else if (provider.page == 3) {
        return ButtonWidget(
            text: 'Hoàn tất',
            textColor: AppColor.WHITE,
            borderRadius: 5,
            bgColor: AppColor.BLUE_TEXT,
            function: () {
              html.window.postMessage('closeWebView', '*');
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
}
