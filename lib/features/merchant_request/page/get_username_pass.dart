import 'dart:html' as html;

import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/widgets/button_widget.dart';
import 'package:VietQR/commons/widgets/dialog_widget.dart';
import 'package:VietQR/features/merchant_request/blocs/merchant_request_bloc.dart';
import 'package:VietQR/features/merchant_request/events/merchant_request_event.dart';
import 'package:VietQR/features/merchant_request/provider/merchant_request_provider.dart';
import 'package:VietQR/features/merchant_request/states/merchant_request_state.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class GetUsernamePassword extends StatelessWidget {
  final MerchantRequestBloc bloc;
  const GetUsernamePassword({super.key, required this.bloc});

  @override
  Widget build(BuildContext context) {
    return UnconstrainedBox(
      child: SizedBox(
        width: 600,
        height: MediaQuery.of(context).size.height - 286,
        child: Consumer<MerchantRequestProvider>(
            builder: (context, provider, child) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
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
                            bloc.add(GenerateUserNamePass(param));
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
                      if (state is GenerateNamePassLoadingState) {
                        return const SizedBox(
                          height: 40,
                          width: 40,
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (state is GenerateNamePassSuccessfulState) {
                        provider.updateSystemName(state.dto.username);
                        provider.updateSystemPass(state.dto.password);

                        return Column(
                          children: [
                            Container(
                                height: 50,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: AppColor.WHITE),
                                child: Row(
                                  children: [
                                    const SelectableText(
                                      'Username: ',
                                      style: TextStyle(
                                          fontSize: 12, color: AppColor.BLACK),
                                    ),
                                    Expanded(
                                      child: Text(
                                        state.dto.username,
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: AppColor.BLACK),
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
                                            fontSize: 12,
                                            color: AppColor.BLUE_TEXT),
                                      ),
                                    )
                                  ],
                                )),
                            const SizedBox(
                              height: 16,
                            ),
                            Container(
                                height: 50,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: AppColor.WHITE),
                                child: Row(
                                  children: [
                                    const SelectableText(
                                      'Mật khẩu: ',
                                      style: TextStyle(
                                          fontSize: 12, color: AppColor.BLACK),
                                    ),
                                    Expanded(
                                      child: Text(
                                        state.dto.password,
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: AppColor.BLACK),
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
                                            fontSize: 12,
                                            color: AppColor.BLUE_TEXT),
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              alignment: Alignment.centerLeft,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: AppColor.WHITE),
                              child: Row(
                                children: const [
                                  Text(
                                    'Username: ',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: AppColor.GREY_TEXT),
                                  ),
                                  Spacer()
                                ],
                              )),
                          const SizedBox(
                            height: 16,
                          ),
                          Container(
                              height: 50,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              alignment: Alignment.centerLeft,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: AppColor.WHITE),
                              child: Row(
                                children: const [
                                  Text(
                                    'Mật khẩu: ',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: AppColor.GREY_TEXT),
                                  ),
                                  Spacer()
                                ],
                              )),
                        ],
                      );
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  // ButtonWidget(
                  //   height: 40,
                  //   text: 'Tạo yêu cầu kết nối',
                  //   borderRadius: 5,
                  //   textSize: 12,
                  //   textColor: AppColor.WHITE,
                  //   bgColor: AppColor.BLUE_TEXT,
                  //   function: () {
                  //     if (provider.systemUsername.isEmpty) {
                  //       DialogWidget.instance.openMsgDialog(
                  //           title: 'Thông tin không hợp lệ',
                  //           msg: 'Vui lòng lấy thông tin kết nối');
                  //     } else {
                  //       provider.checkValidate();
                  //
                  //       if (provider.isValidate()) {
                  //         Map<String, dynamic> param = {};
                  //         param['merchantName'] = provider.merchant;
                  //         if (provider.valueTypeConnect == 0) {
                  //           param['url'] = urlCtrl.text;
                  //           param['id'] = '';
                  //           param['port'] = '';
                  //         } else {
                  //           param['url'] = '';
                  //           param['id'] = ipCtrl.text;
                  //           param['port'] = portCtrl.text;
                  //         }
                  //
                  //         param['suffixUrl'] = urlPathCtrl.text;
                  //         param['address'] = addressCtrl.text;
                  //         param['bankAccount'] = provider.bankAccountDTO.bankAccount;
                  //         param['userBankName'] =
                  //             provider.bankAccountDTO.userBankName;
                  //         param['customerUsername'] = provider.username;
                  //         param['customerPassword'] = provider.password;
                  //         param['systemUsername'] = provider.systemUsername;
                  //         param['customerSyncActive'] = 0;
                  //         _bloc.add(InsertMerchantEvent(param));
                  //       }
                  //     }
                  //   },
                  // ),

                  Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: AppColor.BLUE_TEXT.withOpacity(0.2)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Lưu ý:',
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
                  _buildDocument()
                ],
              ),
            ),
          );
        }),
      ),
    );
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
