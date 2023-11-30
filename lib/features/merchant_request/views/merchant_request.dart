import 'dart:html' as html;
import 'dart:math' as math;

import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/enums/type_menu_home.dart';
import 'package:VietQR/commons/utils/error_utils.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/commons/widgets/button_widget.dart';
import 'package:VietQR/commons/widgets/dialog_widget.dart';
import 'package:VietQR/commons/widgets/textfield_widget.dart';
import 'package:VietQR/features/bank/widgets/select_my_bank_account.dart';
import 'package:VietQR/features/dashboard/views/menu_left.dart';
import 'package:VietQR/features/merchant_request/blocs/merchant_request_bloc.dart';
import 'package:VietQR/features/merchant_request/events/merchant_request_event.dart';
import 'package:VietQR/features/merchant_request/frame/merchant_request_frame.dart';
import 'package:VietQR/features/merchant_request/provider/merchant_request_provider.dart';
import 'package:VietQR/features/merchant_request/states/merchant_request_state.dart';
import 'package:VietQR/layouts/border_layout.dart';
import 'package:VietQR/layouts/box_layout.dart';
import 'package:VietQR/models/bank_account_dto.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class MerchantRequest extends StatefulWidget {
  const MerchantRequest({super.key});

  @override
  State<MerchantRequest> createState() => _MerchantViewState();
}

class _MerchantViewState extends State<MerchantRequest> {
  final ScrollController scrollController = ScrollController();
  final TextEditingController merchantName = TextEditingController();
  final TextEditingController urlCtrl = TextEditingController();
  final TextEditingController ipCtrl = TextEditingController();
  final TextEditingController portCtrl = TextEditingController();
  final TextEditingController urlPathCtrl = TextEditingController();
  final TextEditingController addressCtrl = TextEditingController();
  final TextEditingController userNameCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();

  int offset = 0;
  SubMenuType currentType = SubMenuType.LIST_TRANSACTION;
  bool isEnded = false;
  String nowMonth = '';

  late MerchantRequestBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = MerchantRequestBloc();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return BlocProvider<MerchantRequestBloc>(
      create: (BuildContext context) => _bloc,
      child: ChangeNotifierProvider<MerchantRequestProvider>(
        create: (context) => MerchantRequestProvider()..getListBankAccount(),
        child: MerchantRequestFrame(
          menu: const MenuLeft(
            currentType: MenuHomeType.CREATE_QR,
          ),
          title: _buildTitle(),
          widget1: _buildAddressConnect(),
          widget2: _buildBasicAuthen(),
        ),
      ),
    );
  }

  Widget _buildAddressConnect() {
    return Consumer<MerchantRequestProvider>(
        builder: (context, provider, child) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Thông tin khách hàng cung cấp',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              'Thông tin đại lý',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 16,
            ),
            BorderLayout(
              height: 50,
              bgColor: AppColor.WHITE,
              isError: provider.errorMerchant,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextFieldWidget(
                      isObscureText: false,
                      maxLines: 1,
                      hintText:
                          'Merchant Name\u002A (VIẾT HOA, không khoảng trắng)',
                      controller: merchantName,
                      inputType: TextInputType.text,
                      keyboardAction: TextInputAction.next,
                      onTapOutside: (value) {},
                      inputFormatter: [
                        UpperCaseTextFormatter(),
                        FilteringTextInputFormatter.allow(
                            RegExp("[0-9a-zA-Z]")),
                      ],
                      onChange: (value) {
                        Map<String, dynamic> param = {};
                        param['merchantName'] = value.toString();
                        if (value.toString().isNotEmpty) {
                          _bloc.add(CheckValidMerchantName(param));
                        } else {
                          _bloc.add(ClearState());
                        }

                        provider.updateMerchant(value as String);
                      },
                    ),
                  ),
                  BlocConsumer<MerchantRequestBloc, MerchantRequestState>(
                      listener: (context, state) {},
                      builder: (context, state) {
                        if (state is CheckValidMerchantNameLoadingState) {
                          return const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(),
                          );
                        }
                        return const SizedBox.shrink();
                      })
                ],
              ),
            ),
            BlocConsumer<MerchantRequestBloc, MerchantRequestState>(
                listener: (context, state) {},
                builder: (context, state) {
                  if (state is CheckValidNameSuccessfulState) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.check,
                            color: AppColor.BLUE_TEXT,
                            size: 16,
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            'Tên merchant hợp lệ',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColor.BLUE_TEXT,
                            ),
                          )
                        ],
                      ),
                    );
                  }
                  if (state is CheckValidNameFailedState) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        children: const [
                          Icon(
                            Icons.close,
                            color: AppColor.RED_TEXT,
                            size: 16,
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            'Tên merchant đã tồn tại',
                            style: TextStyle(
                                fontSize: 12, color: AppColor.RED_TEXT),
                          )
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }),
            if (provider.errorMerchant) ...[
              const Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text(
                  'Không được để trống',
                  style: TextStyle(fontSize: 12, color: AppColor.RED_TEXT),
                ),
              )
            ],
            const SizedBox(
              height: 16,
            ),
            Row(
              children: [
                const Text(
                  'Địa chỉ kết nối',
                  style: TextStyle(fontSize: 12, color: AppColor.GREY_TEXT),
                ),
                const SizedBox(
                  width: 20,
                ),
                Transform.scale(
                  scale: 0.9,
                  child: Radio<int>(
                      value: 0,
                      activeColor: AppColor.BLUE_TEXT,
                      groupValue: provider.valueTypeConnect,
                      onChanged: (value) {
                        provider.changeTypeConnect(value ?? 0);
                      }),
                ),
                const Text(
                  'URL',
                  style: TextStyle(fontSize: 12, color: AppColor.GREY_TEXT),
                ),
                const SizedBox(
                  width: 28,
                ),
                Transform.scale(
                  scale: 0.9,
                  child: Radio<int>(
                      value: 1,
                      activeColor: AppColor.BLUE_TEXT,
                      groupValue: provider.valueTypeConnect,
                      onChanged: (value) {
                        provider.changeTypeConnect(value ?? 0);
                      }),
                ),
                const Text(
                  'IP + PORT',
                  style: TextStyle(fontSize: 12, color: AppColor.GREY_TEXT),
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            if (provider.valueTypeConnect == 0)
              BorderLayout(
                height: 50,
                isError: false,
                bgColor: AppColor.WHITE,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextFieldWidget(
                  controller: urlCtrl,
                  isObscureText: false,
                  maxLines: 1,
                  hintText: 'URL kết nối',
                  inputType: TextInputType.text,
                  keyboardAction: TextInputAction.next,
                  onTapOutside: (value) {},
                  onChange: (value) {
                    provider.updateUrlConnect(value as String);
                  },
                ),
              )
            else
              Row(
                children: [
                  Expanded(
                    child: BorderLayout(
                      height: 50,
                      isError: false,
                      bgColor: AppColor.WHITE,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextFieldWidget(
                        isObscureText: false,
                        controller: ipCtrl,
                        maxLines: 1,
                        disableBorder: true,
                        hintText: 'IP',
                        inputType: TextInputType.text,
                        keyboardAction: TextInputAction.next,
                        onTapOutside: (value) {},
                        onChange: (value) {
                          provider.updateIpConnect(value as String);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: BorderLayout(
                      height: 50,
                      isError: false,
                      bgColor: AppColor.WHITE,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextFieldWidget(
                        controller: portCtrl,
                        isObscureText: false,
                        maxLines: 1,
                        disableBorder: true,
                        hintText: 'PORT',
                        inputType: TextInputType.text,
                        keyboardAction: TextInputAction.next,
                        onTapOutside: (value) {},
                        onChange: (value) {
                          provider.updatePortConnect(value as String);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            const SizedBox(
              height: 16,
            ),
            BorderLayout(
              height: 50,
              isError: false,
              bgColor: AppColor.WHITE,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextFieldWidget(
                isObscureText: false,
                controller: urlPathCtrl,
                maxLines: 1,
                disableBorder: true,
                hintText: 'URL Path',
                inputType: TextInputType.text,
                keyboardAction: TextInputAction.next,
                onTapOutside: (value) {},
                onChange: (value) {
                  provider.updateSuffixConnect(value as String);
                },
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            BorderLayout(
              height: 50,
              isError: provider.errorAddress,
              bgColor: AppColor.WHITE,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextFieldWidget(
                isObscureText: false,
                controller: addressCtrl,
                maxLines: 1,
                disableBorder: true,
                hintText:
                    'Địa chỉ KH\u002A (Không dấu, chi tiết để tránh trùng lặp)',
                inputType: TextInputType.text,
                keyboardAction: TextInputAction.next,
                onTapOutside: (value) {},
                onChange: (value) {
                  provider.updateAddress(value as String);
                },
              ),
            ),
            if (provider.errorAddress) ...[
              const Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text(
                  'Không được để trống',
                  style: TextStyle(fontSize: 12, color: AppColor.RED_TEXT),
                ),
              )
            ],
            const SizedBox(
              height: 16,
            ),
            BorderLayout(
              height: 50,
              bgColor: AppColor.WHITE,
              isError: provider.errorUserBankName,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: _buildListBank(provider),
            ),
            if (provider.errorUserBankName) ...[
              const Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text(
                  'Không được để trống',
                  style: TextStyle(fontSize: 12, color: AppColor.RED_TEXT),
                ),
              )
            ],
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Thông tin xác thực từ phía khách hàng',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 4,
            ),
            const Text(
              'Thông tin bao gồm Username - Password để lấy Token xác thực từ phía hệ thống. API Get Token được cấu hình theo dạng Basic Authentication',
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(
              height: 16,
            ),
            BorderLayout(
              height: 50,
              bgColor: AppColor.WHITE,
              isError: provider.errorUsername,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextFieldWidget(
                isObscureText: false,
                maxLines: 1,
                disableBorder: true,
                controller: userNameCtrl,
                hintText: 'Username khách hàng cung cấp\u002A',
                inputType: TextInputType.text,
                keyboardAction: TextInputAction.next,
                onTapOutside: (value) {},
                onChange: (value) {
                  provider.updateUsername(value as String);
                },
              ),
            ),
            if (provider.errorUsername) ...[
              const Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text(
                  'Không được để trống',
                  style: TextStyle(fontSize: 12, color: AppColor.RED_TEXT),
                ),
              )
            ],
            const SizedBox(
              height: 16,
            ),
            BorderLayout(
              height: 50,
              bgColor: AppColor.WHITE,
              isError: provider.errorPassword,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextFieldWidget(
                isObscureText: false,
                controller: passCtrl,
                maxLines: 1,
                disableBorder: true,
                hintText: 'Password khách hàng cung cấp\u002A',
                inputType: TextInputType.text,
                keyboardAction: TextInputAction.next,
                onTapOutside: (value) {},
                onChange: (value) {
                  provider.updatePassword(value as String);
                },
              ),
            ),
            if (provider.errorPassword) ...[
              const Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text(
                  'Không được để trống',
                  style: TextStyle(fontSize: 12, color: AppColor.RED_TEXT),
                ),
              )
            ],
            const SizedBox(
              height: 16,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: UnconstrainedBox(
                child: ButtonWidget(
                  height: 32,
                  width: 200,
                  text: 'Test Get Token của khách hàng',
                  borderRadius: 5,
                  textSize: 12,
                  textColor: AppColor.WHITE,
                  bgColor: AppColor.BLUE_TEXT,
                  function: () {
                    if (provider.ipConnect.isEmpty &&
                        provider.urlConnect.isEmpty &&
                        provider.portConnect.isEmpty) {
                      DialogWidget.instance.openMsgDialog(
                          title: 'Thông tin không hợp lệ',
                          msg: 'Vui lòng nhập thông tin url hoặc ip và port');
                    } else {
                      if (provider.username.isEmpty) {
                        DialogWidget.instance.openMsgDialog(
                            title: 'Thông tin không hợp lệ',
                            msg: 'Vui lòng nhập thông tin username');
                      } else if (provider.password.isEmpty) {
                        DialogWidget.instance.openMsgDialog(
                            title: 'Thông tin không hợp lệ',
                            msg: 'Vui lòng nhập thông tin password');
                      } else {
                        Map<String, dynamic> param = {};
                        param['url'] = provider.getUrl();
                        param['username'] = provider.username;
                        param['password'] = provider.password;
                        _bloc.add(GetTokenEvent(param: param));
                      }
                    }
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            BlocConsumer<MerchantRequestBloc, MerchantRequestState>(
              listener: (context, state) {},
              builder: (context, state) {
                if (state is NewConnectGetTokenLoadingState) {
                  return const SizedBox(
                    height: 40,
                    width: 40,
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is GetTokenSuccessfulState) {
                  return InkWell(
                    onTap: () async {
                      await FlutterClipboard.copy(state.dto.message).then(
                        (value) => Fluttertoast.showToast(
                          msg: 'Đã sao chép',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: AppColor.WHITE,
                          textColor: AppColor.BLACK,
                          fontSize: 15,
                          webBgColor: 'rgba(255, 255, 255)',
                          webPosition: 'center',
                        ),
                      );
                    },
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: AppColor.BLUE_TEXT.withOpacity(0.3)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Thành công!',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.BLUE_TEXT),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              state.dto.message,
                              style: const TextStyle(
                                  fontSize: 12, color: AppColor.BLUE_TEXT),
                            )
                          ],
                        )),
                  );
                }
                if (state is GetTokenFailedState) {
                  return InkWell(
                    onTap: () async {
                      await FlutterClipboard.copy(state.dto.message).then(
                        (value) => Fluttertoast.showToast(
                          msg: 'Đã sao chép',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: AppColor.WHITE,
                          textColor: AppColor.BLACK,
                          fontSize: 15,
                          webBgColor: 'rgba(255, 255, 255)',
                          webPosition: 'center',
                        ),
                      );
                    },
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: AppColor.RED_TEXT.withOpacity(0.3)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Thất bại!',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColor.RED_TEXT),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              errorText(state.dto.message),
                              style: const TextStyle(
                                  fontSize: 12, color: AppColor.RED_TEXT),
                            )
                          ],
                        )),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            const SizedBox(
              height: 80,
            ),
          ],
        ),
      );
    });
  }

  Widget _buildBasicAuthen() {
    return Consumer<MerchantRequestProvider>(
        builder: (context, provider, child) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Thông tin hệ thống khởi tạo',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              'Thông tin xác nhận từ phía hệ thống',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 4,
            ),
            const Text(
              'Thông tin bao gồm Username - Password để lấy Token xác thực từ phía hệ thống. API Get Token được cấu hình theo dạng Basic Authentication',
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: UnconstrainedBox(
                child: ButtonWidget(
                  height: 32,
                  width: 200,
                  text: 'Lấy thông tin kết nối',
                  borderRadius: 5,
                  textSize: 12,
                  textColor: AppColor.WHITE,
                  bgColor: AppColor.BLUE_TEXT,
                  function: () {
                    if (provider.merchant.isEmpty) {
                      DialogWidget.instance.openMsgDialog(
                          title: 'Thông tin không hợp lệ',
                          msg: 'Vui lòng nhập tên Merchant');
                    } else {
                      Map<String, dynamic> param = {};
                      param['merchantName'] = provider.merchant;
                      _bloc.add(GenerateUserNamePass(param));
                    }
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            BlocConsumer<MerchantRequestBloc, MerchantRequestState>(
              listener: (context, state) {
                if (state is MerchantLoadingState) {
                  DialogWidget.instance.openLoadingDialog();
                }
                if (state is InsertSuccessfulState) {
                  Navigator.pop(context);
                  DialogWidget.instance.openMsgSuccessDialog(
                      title:
                          'Tạo yêu cầu thành công, vui lòng chờ bộ phận quản lý xác nhận.');
                }
                if (state is InsertFailedState) {
                  Navigator.pop(context);

                  String msg =
                      ErrorUtils.instance.getErrorMessage(state.dto.message);
                  DialogWidget.instance.openMsgDialog(
                      title: 'Tạo yêu cầu không thành công', msg: msg);
                }
              },
              builder: (context, state) {
                if (state is GenerateNamePassLoadingState) {
                  return const SizedBox(
                    height: 40,
                    width: 40,
                    child: CircularProgressIndicator(),
                  );
                }
                if (state is GenerateNamePassSuccessfulState) {
                  provider.updateSystemName(state.dto.username);
                  return Column(
                    children: [
                      Container(
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: AppColor.GREY_VIEW),
                          child: Row(
                            children: [
                              const SelectableText(
                                'Username: ',
                                style: TextStyle(
                                    fontSize: 12, color: AppColor.GREY_TEXT),
                              ),
                              Expanded(
                                child: Text(
                                  state.dto.username,
                                  style: const TextStyle(
                                      fontSize: 12, color: AppColor.GREY_TEXT),
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  await FlutterClipboard.copy(
                                          state.dto.username)
                                      .then(
                                    (value) => Fluttertoast.showToast(
                                      msg: 'Đã sao chép',
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: AppColor.WHITE,
                                      textColor: AppColor.BLACK,
                                      fontSize: 15,
                                      webBgColor: 'rgba(255, 255, 255)',
                                      webPosition: 'center',
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Sao chép',
                                  style: TextStyle(
                                      fontSize: 12, color: AppColor.BLUE_TEXT),
                                ),
                              )
                            ],
                          )),
                      const SizedBox(
                        height: 16,
                      ),
                      Container(
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: AppColor.GREY_VIEW),
                          child: Row(
                            children: [
                              const SelectableText(
                                'Mật khẩu: ',
                                style: TextStyle(
                                    fontSize: 12, color: AppColor.GREY_TEXT),
                              ),
                              Expanded(
                                child: Text(
                                  state.dto.password,
                                  style: const TextStyle(
                                      fontSize: 12, color: AppColor.GREY_TEXT),
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  await FlutterClipboard.copy(
                                          state.dto.password)
                                      .then(
                                    (value) => Fluttertoast.showToast(
                                      msg: 'Đã sao chép',
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: AppColor.WHITE,
                                      textColor: AppColor.BLACK,
                                      fontSize: 15,
                                      webBgColor: 'rgba(255, 255, 255)',
                                      webPosition: 'center',
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Sao chép',
                                  style: TextStyle(
                                      fontSize: 12, color: AppColor.BLUE_TEXT),
                                ),
                              )
                            ],
                          )),
                    ],
                  );
                }
                return Column(
                  children: [
                    Container(
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: AppColor.GREY_VIEW),
                        child: Row(
                          children: const [
                            Text(
                              'Username: ',
                              style: TextStyle(
                                  fontSize: 12, color: AppColor.GREY_TEXT),
                            ),
                            Spacer()
                          ],
                        )),
                    const SizedBox(
                      height: 16,
                    ),
                    Container(
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: AppColor.GREY_VIEW),
                        child: Row(
                          children: const [
                            Text(
                              'Mật khẩu: ',
                              style: TextStyle(
                                  fontSize: 12, color: AppColor.GREY_TEXT),
                            ),
                            Spacer()
                          ],
                        )),
                  ],
                );
              },
            ),
            const SizedBox(
              height: 24,
            ),
            ButtonWidget(
              height: 40,
              text: 'Tạo yêu cầu kết nối',
              borderRadius: 5,
              textSize: 12,
              textColor: AppColor.WHITE,
              bgColor: AppColor.BLUE_TEXT,
              function: () {
                if (provider.systemUsername.isEmpty) {
                  DialogWidget.instance.openMsgDialog(
                      title: 'Thông tin không hợp lệ',
                      msg: 'Vui lòng lấy thông tin kết nối');
                } else {
                  provider.checkValidate();

                  if (provider.isValidate()) {
                    Map<String, dynamic> param = {};
                    param['merchantName'] = provider.merchant;
                    if (provider.valueTypeConnect == 0) {
                      param['url'] = urlCtrl.text;
                      param['id'] = '';
                      param['port'] = '';
                    } else {
                      param['url'] = '';
                      param['id'] = ipCtrl.text;
                      param['port'] = portCtrl.text;
                    }

                    param['suffixUrl'] = urlPathCtrl.text;
                    param['address'] = addressCtrl.text;
                    param['bankAccount'] = provider.bankAccountDTO.bankAccount;
                    param['userBankName'] =
                        provider.bankAccountDTO.userBankName;
                    param['customerUsername'] = provider.username;
                    param['customerPassword'] = provider.password;
                    param['systemUsername'] = provider.systemUsername;
                    param['customerSyncActive'] = 0;
                    _bloc.add(InsertMerchantEvent(param));
                  }
                }
              },
            ),
            const SizedBox(
              height: 40,
            ),
            Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: AppColor.BLUE_TEXT.withOpacity(0.2)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Lưu ý',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColor.BLUE_TEXT),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    const Text(
                      '- Sau khi tạo yêu cầu kết nối, khách hàng liên hệ với bộ phận hỗ trợ của VietQR VN để xác nhận và duyệ yêu cầu.',
                      style: TextStyle(fontSize: 12),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        const Text(
                          '- Xem tài liệu kết nối  ',
                          style: TextStyle(fontSize: 12),
                        ),
                        InkWell(
                          onTap: () {
                            html.window.open(
                                'https://docs.google.com/document/d/17wA-LMJuAwxgr-K5APRAW1X51hvDIrnM/edit?fbclid=IwAR05F0k7xpOJi4mAyuJ4ALSrtSOmPfJkh43An3-hJi5hgwyqfts1TkmhP9s#heading=h.uspmij5vwsf8',
                                'new tab');
                          },
                          child: const Text(
                            'Tại đây ',
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontSize: 12,
                                color: AppColor.BLUE_TEXT,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    )
                  ],
                ))
          ],
        ),
      );
    });
  }

  Widget _buildTitle() {
    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(color: AppColor.BLUE_TEXT.withOpacity(0.1)),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              context.go('/home');
            },
            child: Container(
              margin: const EdgeInsets.only(top: 8, bottom: 8, right: 24),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColor.BLUE_TEXT.withOpacity(0.1),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                children: const [
                  Icon(
                    Icons.arrow_back_ios,
                    color: AppColor.BLUE_TEXT,
                    size: 12,
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Text(
                    'Trở về',
                    style: TextStyle(fontSize: 11, color: AppColor.BLUE_TEXT),
                  ),
                ],
              ),
            ),
          ),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Trang chủ',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Icon(
              Icons.arrow_forward_ios,
              color: AppColor.BLUE_TEXT,
              size: 20,
            ),
          ),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Đăng ký đại lý môi trường TEST',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline),
            ),
          ),
        ],
      ),
    );
  }

  String errorText(String message) {
    if (message.contains('E82')) {
      return 'Không tìm thấy field "access_token" trong Response Body thuộc API get Token của khách hàng.';
    } else {
      return 'Lỗi không xác định $message';
    }
  }

  Widget _buildListBank(MerchantRequestProvider provider) {
    return InkWell(
      onTap: () {
        DialogWidget.instance.openPopup(
          child: SelectMyBankAccountWidget(
            bankAccounts: provider.bankAccounts,
            chooseBank: (dto) {
              provider.changeBankAccount(dto);
            },
          ),
          width: 500,
          height: 500,
        );
      },
      child: (provider.bankAccountDTO.id.isEmpty)
          ? BoxLayout(
              bgColor: AppColor.WHITE,
              height: 50,
              borderRadius: 5,
              child: Row(
                children: [
                  const Text(
                    'Chọn tài khoản đã liên kết',
                    style: TextStyle(
                      fontSize: 13,
                    ),
                  ),
                  const Spacer(),
                  Transform.rotate(
                      angle: -math.pi / 2,
                      child: const Icon(
                        Icons.arrow_back_ios_new,
                        size: 14,
                        color: AppColor.BLACK,
                      ))
                ],
              ),
            )
          : _buildSelectedBankType(
              provider.bankAccountDTO,
            ),
    );
  }

  Widget _buildSelectedBankType(BankAccountDTO dto) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColor.WHITE,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              border: Border.all(color: AppColor.GREY_BUTTON),
              borderRadius: BorderRadius.circular(30),
              image: DecorationImage(
                image: ImageUtils.instance.getImageNetWork(dto.imgId),
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.only(left: 16)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${dto.bankCode} - ${dto.bankAccount}',
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                      fontSize: 12,
                      color: AppColor.BLACK,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 2,
                ),
                Text(
                  dto.userBankName,
                  style: const TextStyle(
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_drop_down_circle_outlined,
            size: 12,
          ),
        ],
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
