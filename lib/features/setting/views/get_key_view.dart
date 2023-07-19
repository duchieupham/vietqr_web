import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/widgets/button_widget.dart';
import 'package:VietQR/commons/widgets/textfield_widget.dart';
import 'package:VietQR/features/setting/blocs/setting_bloc.dart';
import 'package:VietQR/features/setting/events/setting_event.dart';
import 'package:VietQR/features/setting/states/setting_state.dart';
import 'package:VietQR/layouts/border_layout.dart';
import 'package:VietQR/services/providers/setting_provider.dart';
import 'package:VietQR/services/shared_references/user_information_helper.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class GetKeyView extends StatelessWidget {
  GetKeyView({Key? key}) : super(key: key);
  final SettingBloc _settingBloc = SettingBloc();
  final TextEditingController hostingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider<SettingBloc>(
        create: (context) => _settingBloc,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 80,
                    ),
                    const Text(
                      'Số điện thoại',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    BorderLayout(
                      height: 40,
                      isError: false,
                      borderWidth: 1,
                      child: TextFieldWidget(
                        isObscureText: false,
                        autoFocus: true,
                        fontSize: 10,
                        readOnly: true,
                        textStyle: const TextStyle(fontSize: 13),
                        contentPadding:
                            const EdgeInsets.only(left: 20, bottom: 8),
                        controller: TextEditingController(
                            text: UserInformationHelper.instance
                                .getAccountInformation()
                                .phoneNo),
                        inputType: TextInputType.number,
                        keyboardAction: TextInputAction.next,
                        onChange: (vavlue) {},
                        hintText: '',
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Đường dẫn trang web nhận biến động số dư*',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    BorderLayout(
                      height: 42,
                      isError: false,
                      borderWidth: 1,
                      child: TextFieldWidget(
                        isObscureText: false,
                        autoFocus: true,
                        fontSize: 13,
                        textStyle: const TextStyle(fontSize: 13),
                        contentPadding:
                            const EdgeInsets.only(left: 20, bottom: 8),
                        controller: hostingController,
                        inputType: TextInputType.number,
                        keyboardAction: TextInputAction.next,
                        onChange: (vavlue) {},
                        hintText: 'http://example.com',
                      ),
                    ),
                    Consumer<SettingProvider>(
                        builder: (context, provider, child) {
                      if (provider.validateHosting) {
                        return const Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: Text(
                            'Hãy nhập hosting',
                            style: TextStyle(
                                color: DefaultTheme.RED_TEXT, fontSize: 13),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    }),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: 120,
                      child: Tooltip(
                        message: 'Get key',
                        child: ButtonWidget(
                          height: 40,
                          textColor: DefaultTheme.WHITE,
                          bgColor: DefaultTheme.BLUE_CARD,
                          borderRadius: 5,
                          function: () {
                            if (hostingController.text.isEmpty) {
                              Provider.of<SettingProvider>(context,
                                      listen: false)
                                  .updateValidHosting(true);
                            } else {
                              Provider.of<SettingProvider>(context,
                                      listen: false)
                                  .updateValidHosting(false);
                              _settingBloc.add(SettingGetTokenPlusEvent(
                                  hosting: hostingController.text));
                            }
                          },
                          text: 'Get key',
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 35,
                    ),
                    _buildValueKey()
                  ],
                ),
              ),
              const Expanded(child: SizedBox.shrink())
            ],
          ),
        ));
  }

  Widget _buildValueKey() {
    return BlocConsumer<SettingBloc, SettingState>(
        builder: (context, state) {
          if (state is SettingLoadingState) {
            return const SizedBox(
                height: 40, width: 40, child: CircularProgressIndicator());
          }
          if (state is SettingGetTokenPlusSuccessState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Key',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 8,
                ),
                Container(
                  height: 42,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                      color: DefaultTheme.ITEM_MENU_SELECTED,
                      borderRadius: BorderRadius.circular(5)),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                        state.tokenPlus,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 12, color: DefaultTheme.GREY_TEXT),
                      )),
                      const SizedBox(
                        width: 8,
                      ),
                      InkWell(
                        onTap: () async {
                          await FlutterClipboard.copy(state.tokenPlus).then(
                            (value) => Fluttertoast.showToast(
                              msg: 'Đã sao chép',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: DefaultTheme.WHITE,
                              textColor: DefaultTheme.BLACK,
                              fontSize: 15,
                              webBgColor: 'rgba(255, 255, 255)',
                              webPosition: 'center',
                            ),
                          );
                        },
                        child: Row(
                          children: const [
                            Icon(
                              Icons.copy_rounded,
                              color: DefaultTheme.BLUE_TEXT,
                              size: 16,
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Text(
                              'Sao chép',
                              style: TextStyle(
                                  color: DefaultTheme.BLUE_TEXT, fontSize: 13),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            );
          }
          return const SizedBox.shrink();
        },
        listener: (context, state) {});
  }
}