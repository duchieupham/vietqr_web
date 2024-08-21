import 'dart:html' as html;
import 'dart:math' as math;

import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/commons/widgets/button_widget.dart';
import 'package:VietQR/commons/widgets/dialog_widget.dart';
import 'package:VietQR/commons/widgets/textfield_widget.dart';
import 'package:VietQR/features/bank/widgets/select_my_bank_account.dart';
import 'package:VietQR/features/merchant_request/blocs/merchant_request_bloc.dart';
import 'package:VietQR/features/merchant_request/events/merchant_request_event.dart';
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
import 'package:provider/provider.dart';

class InforCustomer extends StatelessWidget {
  final MerchantRequestBloc bloc;
  InforCustomer({super.key, required this.bloc});
  final TextEditingController merchantName = TextEditingController();
  final TextEditingController urlCtrl = TextEditingController();
  final TextEditingController ipCtrl = TextEditingController();
  final TextEditingController portCtrl = TextEditingController();
  final TextEditingController urlPathCtrl = TextEditingController();
  final TextEditingController addressCtrl = TextEditingController();
  final TextEditingController userNameCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Consumer<MerchantRequestProvider>(
        builder: (context, provider, child) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 120),
        child: SingleChildScrollView(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildInfoConnect(provider),
              ),
              const SizedBox(
                width: 80,
              ),
              Expanded(child: _buildAuthCustomer(provider))
            ],
          ),
        ),
      );
    });
  }

  Widget _buildInfoConnect(MerchantRequestProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Thông tin đại lý',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 16,
        ),
        BorderLayout(
          height: 45,
          bgColor: AppColor.WHITE,
          isError: provider.errorMerchant,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Expanded(
                child: TextFieldWidget(
                  isObscureText: false,
                  maxLines: 1,
                  height: 45,
                  contentPadding: const EdgeInsets.only(bottom: 4, left: 8),
                  hintText:
                      'Merchant Name\u002A (VIẾT HOA, tối đa 10 ký tự, không koảng trắng.Ví dụ:MCTEST) ',
                  controller: merchantName,
                  inputType: TextInputType.text,
                  keyboardAction: TextInputAction.next,
                  onTapOutside: (value) {},
                  inputFormatter: [
                    UpperCaseTextFormatter(),
                    FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
                    LengthLimitingTextInputFormatter(10),
                  ],
                  onChange: (value) {
                    Map<String, dynamic> param = {};
                    param['merchantName'] = value.toString();
                    if (value.toString().isNotEmpty) {
                      bloc.add(CheckValidMerchantName(param));
                    } else {
                      bloc.add(ClearState());
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
                        style:
                            TextStyle(fontSize: 12, color: AppColor.RED_TEXT),
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
        const Text(
          'Ví dụ\nURL của khách hàng được cấu hình theo format tài liệu kết nối là:\n- API Get Token: https://api.vietqr.org/vqr/api/token_generate\n- Api callback: https://api.vietqr.org/vqr/bank/api/test/transaction-callback\n\nThì các tham số tương ứng như sau:\n- URL: https://api.vietqr.org\n- URL Path:vqr',
          style: TextStyle(color: AppColor.GREY_TEXT),
        ),
        const SizedBox(
          height: 16,
        ),
        Row(
          children: [
            const Text(
              'Địa chỉ kết nối',
              style: TextStyle(color: AppColor.GREY_TEXT),
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
            height: 45,
            isError: false,
            bgColor: AppColor.WHITE,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextFieldWidget(
              controller: urlCtrl,
              isObscureText: false,
              height: 45,
              contentPadding: const EdgeInsets.only(bottom: 4, left: 8),
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
                  height: 45,
                  isError: false,
                  bgColor: AppColor.WHITE,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextFieldWidget(
                    isObscureText: false,
                    height: 45,
                    contentPadding: const EdgeInsets.only(bottom: 4, left: 8),
                    controller: ipCtrl,
                    maxLines: 1,
                    disableBorder: true,
                    hintText: 'IP (Ví dụ: 127.0.0.1)',
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
                  height: 45,
                  isError: false,
                  bgColor: AppColor.WHITE,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextFieldWidget(
                    controller: portCtrl,
                    height: 45,
                    contentPadding: const EdgeInsets.only(bottom: 4, left: 8),
                    isObscureText: false,
                    maxLines: 1,
                    disableBorder: true,
                    hintText: 'PORT (Ví dụ: 8080)',
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
        const SizedBox(height: 4),
        Visibility(
            visible: provider.valueTypeConnect == 0
                ? provider.urlError
                : provider.ipError,
            child: Text(
              provider.valueTypeConnect == 0
                  ? 'URL không đúng định dạng'
                  : 'IP không phù hợp',
              style: const TextStyle(fontSize: 12, color: AppColor.RED_TEXT),
            )),
        const SizedBox(
          height: 16,
        ),
        BorderLayout(
          height: 45,
          isError: false,
          bgColor: AppColor.WHITE,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: TextFieldWidget(
            isObscureText: false,
            height: 45,
            contentPadding: const EdgeInsets.only(bottom: 4, left: 8),
            controller: urlPathCtrl,
            maxLines: 1,
            disableBorder: true,
            hintText: 'URL Path (hậu tố của URL, mặc định: vqr)',
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
          height: 45,
          isError: provider.errorAddress,
          bgColor: AppColor.WHITE,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: TextFieldWidget(
            isObscureText: false,
            height: 45,
            contentPadding: const EdgeInsets.only(bottom: 4, left: 8),
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
          height: 45,
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
      ],
    );
  }

  Widget _buildAuthCustomer(MerchantRequestProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
          height: 45,
          bgColor: AppColor.WHITE,
          isError: provider.errorUsername,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: TextFieldWidget(
            isObscureText: false,
            height: 45,
            contentPadding: const EdgeInsets.only(bottom: 4, left: 8),
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
          height: 45,
          bgColor: AppColor.WHITE,
          isError: provider.errorPassword,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: TextFieldWidget(
            isObscureText: false,
            height: 45,
            contentPadding: const EdgeInsets.only(bottom: 4, left: 8),
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
                    bloc.add(GetTokenEvent(param: param));
                  }
                }
              },
            ),
          ),
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    margin: const EdgeInsets.only(top: 16),
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    margin: const EdgeInsets.only(top: 16),
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
          height: 16,
        ),
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: AppColor.BLUE_TEXT.withOpacity(0.2)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Lưu ý',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColor.BLUE_TEXT),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  '- Sau khi tạo yêu cầu kết nối, khách hàng liên hệ với bộ phận hỗ trợ của VietQR VN để xác nhận và duyệ yêu cầu.',
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '- Sau được duyệt yêu cầu, khách hàng có thể thực hiện việc test kết nối, nhận biến động số dư trên môi trường Test của mình.',
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '- Quá trình test hoàn tất, bên VietQR VN sẽ nghiệm thu kết quả và tiến hành Golive cho khách hàng.',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            )),
        const SizedBox(
          height: 20,
        ),
        _buildDocument(),
        const SizedBox(
          height: 40,
        ),
      ],
    );
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
      child: (provider.bankAccountDTO.bankId.isEmpty)
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

  String errorText(String message) {
    if (message.contains('E82')) {
      return 'Không tìm thấy field "access_token" trong Response Body thuộc API get Token của khách hàng.';
    } else {
      return 'Lỗi không xác định $message';
    }
  }

  Widget _buildDocument() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Tài liệu kết nối',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 4,
        ),
        Container(
          height: 50,
          color: AppColor.BLUE_TEXT.withOpacity(0.3),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: AppColor.BLACK_BUTTON.withOpacity(0.2))),
                  child: const Text(
                    'Tên tài liệu',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Container(
                width: 110,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    border: Border.all(
                        color: AppColor.BLACK_BUTTON.withOpacity(0.2))),
                child: const Text(
                  'Ngày cập nhật',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                width: 80,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    border: Border.all(
                        color: AppColor.BLACK_BUTTON.withOpacity(0.2))),
                child: const Text(
                  'Truy cập',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 50,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: AppColor.WHITE,
                      border: Border.all(
                          color: AppColor.BLACK_BUTTON.withOpacity(0.2))),
                  child: InkWell(
                    onTap: () {
                      html.window.open(
                          'https://docs.google.com/document/d/17wA-LMJuAwxgr-K5APRAW1X51hvDIrnM/edit?fbclid=IwAR05F0k7xpOJi4mAyuJ4ALSrtSOmPfJkh43An3-hJi5hgwyqfts1TkmhP9s#heading=h.uspmij5vwsf8',
                          'new tab');
                    },
                    child: const Text(
                      'Tài liệu kết nối API VietQR VN - Nhận biến động số dư',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: AppColor.BLUE_TEXT,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                ),
              ),
              Container(
                width: 110,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: AppColor.WHITE,
                    border: Border.all(
                        color: AppColor.BLACK_BUTTON.withOpacity(0.2))),
                child: const Text(
                  '24/10/2023',
                ),
              ),
              Container(
                width: 80,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: AppColor.WHITE,
                    border: Border.all(
                        color: AppColor.BLACK_BUTTON.withOpacity(0.2))),
                child: InkWell(
                  onTap: () {
                    html.window.open(
                        'https://docs.google.com/document/d/17wA-LMJuAwxgr-K5APRAW1X51hvDIrnM/edit?fbclid=IwAR05F0k7xpOJi4mAyuJ4ALSrtSOmPfJkh43An3-hJi5hgwyqfts1TkmhP9s#heading=h.uspmij5vwsf8',
                        'new tab');
                  },
                  child: const Text(
                    'Truy cập',
                    style: TextStyle(
                        color: AppColor.BLUE_TEXT,
                        decoration: TextDecoration.underline),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
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
