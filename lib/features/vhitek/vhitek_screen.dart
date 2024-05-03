import 'dart:js' as js;

import 'package:VietQR/commons/constants/configurations/app_image.dart';
import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/error_utils.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/commons/widgets/button_widget.dart';
import 'package:VietQR/commons/widgets/dialog_widget.dart';
import 'package:VietQR/commons/widgets/divider_widget.dart';
import 'package:VietQR/features/vhitek/blocs/vhitek_bloc.dart';
import 'package:VietQR/features/vhitek/page/active_store_success.dart';
import 'package:VietQR/features/vhitek/page/confirm_store.dart';
import 'package:VietQR/features/vhitek/page/active_success.dart';
import 'package:VietQR/features/vhitek/page/active_vhitek.dart';
import 'package:VietQR/features/vhitek/page/confirm_active.dart';
import 'package:VietQR/features/vhitek/page/connect_vhitek.dart';
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
  final String path;

  const VhitekScreen({super.key, this.mid = '', this.path = ''});

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

  const _VhitekScreen({this.mid = '', this.path = ''});

  @override
  State<_VhitekScreen> createState() => _VhitekState();
}

class _VhitekState extends State<_VhitekScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  late VhitekBloc _vhitekBloc;
  late ActiveVhitekProvider _provider;
  String userId = '';

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
      String? userId = UserInformationHelper.instance.getUserId();
      if (userId == null) {
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
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<VhitekBloc>(
      create: (context) => _vhitekBloc,
      child: Scaffold(
        backgroundColor: AppColor.GREY_BG,
        body: BlocConsumer<VhitekBloc, VhitekState>(
          listener: (context, state) {
            if (state is VhitekStateLoadingState) {
              DialogWidget.instance.openLoadingDialog();
            }
            if (state is VhitekCheckUserValidSuccessState) {
              Navigator.pop(context);
              if (state.dto.status == 'SUCCESS') {
                onEdit(2);
                _provider.changeUserIdVhitek(state.dto.message);
              } else if (state.dto.status == 'CHECK') {
                if (state.dto.message == 'C09') {
                  DialogWidget.instance.openMsgDialog(
                      title: 'Đã kích hoạt',
                      msg: 'Máy bán hàng đã được kích hoạt trước đó.');
                } else {
                  onEdit(1);
                }
              } else {
                DialogWidget.instance.openMsgDialog(
                    title: 'Lỗi',
                    msg:
                        ErrorUtils.instance.getErrorMessage(state.dto.message));
              }
            }
            if (state is LoginByUserIdSuccessState) {
              _provider.getListBankAccount();
            }
            if (state is VhitekCreateUserSuccessState) {
              Navigator.pop(context);
              if (state.dto.status == 'SUCCESS') {
                onEdit(2);
                _provider.changeUserIdVhitek(state.dto.message);
              } else {
                DialogWidget.instance.openMsgDialog(
                    title: 'Lỗi',
                    msg:
                        ErrorUtils.instance.getErrorMessage(state.dto.message));
              }
            }
            if (state is VhitekActiveSuccessState) {
              Navigator.pop(context);
              if (state.dto.status == 'SUCCESS') {
                onEdit(3);
              } else {
                DialogWidget.instance.openMsgDialog(
                    title: 'Lỗi',
                    msg:
                        ErrorUtils.instance.getErrorMessage(state.dto.message));
              }
            }
            if (state is ConfirmStoreSuccessState) {
              Navigator.pop(context);
              if (state.dto.status == 'SUCCESS') {
                onEdit(6);
              } else {
                DialogWidget.instance.openMsgDialog(
                    title: 'Lỗi',
                    msg:
                        ErrorUtils.instance.getErrorMessage(state.dto.message));
              }
            }
            if (state is VhitekGetTerminalsSuccessState) {
              _provider.updateTerminals(state.terminals);
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                if (widget.mid.isEmpty)
                  _buildHeader()
                else
                  const SizedBox(
                    width: double.infinity,
                  ),
                if (state is VhitekLoginLoadingState)
                  const Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else ...[
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return SizedBox(
                          width: constraints.maxWidth > 700
                              ? 600
                              : constraints.maxWidth,
                          child: PageView(
                            physics: const NeverScrollableScrollPhysics(),
                            controller: _pageController,
                            onPageChanged: (index) {},
                            children: [
                              ActiveVhitek(
                                mid: widget.mid,
                                callBack: (bankDTO) {
                                  _provider.updateBankAccountDTO(bankDTO);
                                  _vhitekBloc.add(GetTerminalsEvent(
                                      _provider.bankAccountDTO.bankId));
                                },
                                onChanged: _onChangeActive,
                              ),
                              RegisterVhitek(
                                edit: onEdit,
                                mid: _provider.mid,
                                onChanged: _onChangeRegister,
                              ),
                              ConfirmActive(
                                edit: onEdit,
                                mid: _provider.mid,
                                userIdVhitek: _provider.userIdVhitek,
                                email: _provider.email,
                                midAddress: _provider.midAddress,
                                dto: _provider.bankAccountDTO,
                              ),
                              ActiveSuccess(edit: onEdit),
                              ConnectVhitek(
                                terminals: _provider.terminals,
                                codeVhitek: _provider.mid,
                                onUpdateTerminal: (dto) {
                                  _provider.updateTerminalDTO(dto);
                                  onEdit(5);
                                },
                              ),
                              ConfirmStore(
                                midCode: _provider.mid,
                                terminal: _provider.terminalDTO,
                                dto: _provider.bankAccountDTO,
                                onEdit: onEdit,
                              ),
                              const ActiveStoreSuccess(),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
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

  _onChangeRegister(userId, email, phoneNumber, password, userName) {
    _provider.changeUserIdVhitek(userId);
    _provider.changeEmail(email);
    _provider.changePhoneNumber(phoneNumber);
    _provider.changePassword(password);
    _provider.changeUserName(userName);
  }

  _onChangeActive(mid, address, email, dto) {
    _provider.changeMid(mid);
    _provider.changeMidAddress(address);
    _provider.changeEmail(email);
    _provider.updateBankAccountDTO(dto);
  }

  onEdit(int value) {
    _provider.changePage(value);
    _animatedToPage(value);
  }
}
