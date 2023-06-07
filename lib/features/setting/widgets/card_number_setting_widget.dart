import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/widgets/button_icon_widget.dart';
import 'package:VietQR/commons/widgets/dialog_widget.dart';
import 'package:VietQR/features/setting/blocs/card_num_bloc.dart';
import 'package:VietQR/features/setting/events/card_num_event.dart';
import 'package:VietQR/features/setting/states/card_num_state.dart';
import 'package:VietQR/models/account_card_num_dto.dart';
import 'package:VietQR/services/providers/card_number_login_provider.dart';
import 'package:VietQR/services/providers/card_number_setting_provider.dart';
import 'package:VietQR/services/shared_references/user_information_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class CardNumberSettingWidget extends StatelessWidget {
  late CardNumBloc _cardNumBloc;
  final Duration _duration = const Duration(milliseconds: 300);

  int _enterCount = 0;
  String _vietQRId = '';
  String _confitmVietQRId = '';
  String _cardNumber = '';

  CardNumberSettingWidget({super.key});

  void initialServices(BuildContext context) {
    _cardNumBloc = BlocProvider.of(context);
    _enterCount = 0;
    _vietQRId = '';
    _confitmVietQRId = '';
    _cardNumber = '';
    _cardNumBloc.add(
        CardNumEventGet(userId: UserInformationHelper.instance.getUserId()));
    Future.delayed(const Duration(milliseconds: 0), () {
      Provider.of<CardNumberSettingProvider>(context, listen: false).reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    initialServices(context);
    return BlocConsumer<CardNumBloc, CardNumState>(
      listener: (context, state) {
        if (state is CardNumGetSuccessState) {
          _cardNumber = state.cardNumber;
          if (_cardNumber.isEmpty) {
            RawKeyboard.instance.addListener((RawKeyEvent event) {
              if (_enterCount == 0) {
                _vietQRId += event.character ?? '';
                if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
                  _enterCount += 1;
                  //update
                  Future.delayed(const Duration(milliseconds: 0), () {
                    Provider.of<CardNumberSettingProvider>(context,
                            listen: false)
                        .updateVietQRId(_vietQRId);
                    Future.delayed(const Duration(milliseconds: 300), () {
                      Provider.of<CardNumberSettingProvider>(context,
                              listen: false)
                          .updateEnterCount(_enterCount);
                    });
                  });
                }
              } else {
                _confitmVietQRId += event.character ?? '';
                if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
                  _enterCount == 0;
                  //update
                  Future.delayed(const Duration(milliseconds: 0), () {
                    Provider.of<CardNumberSettingProvider>(context,
                            listen: false)
                        .updateConfirm(_confitmVietQRId);
                    _cardNumBloc.add(
                      CardNumEventCompare(
                        id: Provider.of<CardNumberSettingProvider>(context,
                                listen: false)
                            .vietQRId,
                        confirm: Provider.of<CardNumberSettingProvider>(context,
                                listen: false)
                            .confirm,
                      ),
                    );
                  });
                }
              }
            });
          } else {
            Future.delayed(const Duration(milliseconds: 0), () {
              Provider.of<CardNumberSettingProvider>(context, listen: false)
                  .reset();
            });
          }
        }
        if (state is CardNumCompareSuccessState) {
          Future.delayed(const Duration(milliseconds: 0), () {
            _cardNumBloc.add(
              CardNumEventUpdate(
                dto: AccountCardNumDTO(
                  userId: UserInformationHelper.instance.getUserId(),
                  cardNumber: Provider.of<CardNumberSettingProvider>(context,
                          listen: false)
                      .vietQRId,
                ),
              ),
            );
          });
        }
        if (state is CardNumCompareFailedState) {
          DialogWidget.instance.openMsgDialog(
            title: "Không thể cập nhật",
            msg: "Xác nhận VietQR ID Card không khớp.",
          );
        }
        if (state is CardNumUpdateSuccessState) {
          //navigate
          // Navigator.pop(context);
          Fluttertoast.showToast(
            msg: 'Cập nhật VietQR ID Card thành công',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: DefaultTheme.WHITE,
            textColor: DefaultTheme.BLACK,
            fontSize: 15,
            webBgColor: 'rgba(255, 255, 255)',
            webPosition: 'center',
          );
          _cardNumBloc.add(CardNumEventGet(
              userId: UserInformationHelper.instance.getUserId()));
        }
        if (state is CardNumUpdateFailedState) {
          DialogWidget.instance.openMsgDialog(
              title: "Không thể cập nhật", msg: "Vui lòng thử lại sau.");
        }
      },
      builder: (context, state) {
        if (state is CardNumGetSuccessState) {
          _cardNumber = state.cardNumber;
        }
        return Column(
          children: [
            const Padding(padding: EdgeInsets.only(top: 20)),
            SizedBox(
              width: width,
              child: Row(
                children: [
                  const Padding(padding: EdgeInsets.only(left: 25)),
                  const Spacer(),
                  const Text(
                    'VietQR ID Card',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 25,
                      height: 25,
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(right: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Theme.of(context).canvasColor.withOpacity(0.3),
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        size: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(padding: EdgeInsets.only(bottom: 50)),
            Image.asset(
              'assets/images/ic-card-nfc.png',
              width: 200,
              height: 200,
            ),
            const Spacer(),
            (_cardNumber.isEmpty)
                ? Consumer<CardNumberSettingProvider>(
                    builder: (context, provider, child) {
                      return (provider.vietQRId.isNotEmpty &&
                              provider.enterCount == 0)
                          ? Container(
                              width: width,
                              height: 10,
                              alignment: Alignment.center,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: provider.vietQRId.length,
                                itemBuilder: (context, index) => Container(
                                  width: 10,
                                  height: 10,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 2.5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: DefaultTheme.GREY_TEXT,
                                  ),
                                ),
                              ),
                            )
                          : (provider.confirm.isNotEmpty &&
                                  provider.enterCount == 1)
                              ? Container(
                                  width: width,
                                  height: 10,
                                  alignment: Alignment.center,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemCount: provider.confirm.length,
                                    itemBuilder: (context, index) => Container(
                                      width: 10,
                                      height: 10,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 2.5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: DefaultTheme.GREY_TEXT,
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox();
                    },
                  )
                : Container(
                    width: width,
                    height: 10,
                    alignment: Alignment.center,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: _cardNumber.length,
                      itemBuilder: (context, index) => Container(
                        width: 10,
                        height: 10,
                        margin: const EdgeInsets.symmetric(horizontal: 2.5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: DefaultTheme.GREY_TEXT,
                        ),
                      ),
                    ),
                  ),
            const Spacer(),
            if (_cardNumber.isEmpty) ...[
              Consumer<CardNumberSettingProvider>(
                builder: (context, provider, child) {
                  return Text(
                    (provider.enterCount == 0) ? 'Quét Lần 1' : 'Quét lần 2',
                    style: const TextStyle(
                      fontSize: 25,
                    ),
                  );
                },
              ),
              const Padding(padding: EdgeInsets.only(top: 10)),
            ],
            (_cardNumber.isNotEmpty)
                ? UnconstrainedBox(
                    child: ButtonIconWidget(
                      width: 250,
                      height: 40,
                      icon: Icons.remove_circle_outline,
                      title: 'Gỡ VietQR ID Card',
                      function: () {
                        _cardNumBloc.add(
                          CardNumEventUpdate(
                            dto: AccountCardNumDTO(
                                userId:
                                    UserInformationHelper.instance.getUserId(),
                                cardNumber: ''),
                          ),
                        );
                      },
                      bgColor: Theme.of(context).canvasColor,
                      textColor: DefaultTheme.RED_TEXT,
                    ),
                  )
                : const Text(
                    'Quét thẻ VietQR ID 2 lần để thiết lập đăng nhập',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
            const Padding(padding: EdgeInsets.only(bottom: 30)),
          ],
        );
      },
    );
  }
}
