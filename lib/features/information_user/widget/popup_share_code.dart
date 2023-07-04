import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/widgets/dialog_widget.dart';
import 'package:VietQR/features/information_user/blocs/wallet_bloc.dart';
import 'package:VietQR/features/information_user/events/wallet_event.dart';
import 'package:VietQR/features/information_user/states/wallet_state.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PopupShareCode extends StatelessWidget {
  const PopupShareCode({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(padding: EdgeInsets.only(top: 20)),
        _buildTitle(context),
        const Padding(padding: EdgeInsets.only(bottom: 65)),
        _buildFormCode(context),
        const Padding(padding: EdgeInsets.only(bottom: 30)),
      ],
    );
  }

  Widget _buildFormCode(BuildContext context) {
    return BlocProvider<WalletBloc>(
      create: (context) => WalletBloc()..add(WalletGetInfoEvent()),
      child: BlocConsumer<WalletBloc, WalletState>(
        listener: (context, state) {
          if (state is WalletLoadingState) {
            DialogWidget.instance.openLoadingDialog();
          }
          if (state is WalletFailedState) {
            Navigator.pop(context);
            DialogWidget.instance.openMsgDialog(
              title: 'Đã có lỗi xảy ra',
              msg: 'Vui lòng thử lại sau.',
            );
          }
          if (state is WalletSuccessfulState) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          if (state is WalletSuccessfulState) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Mã giới thiệu',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  _buildCardCode(state.walletDTO.sharingCode, context),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Link giới thiệu',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  _buildCardCode(
                      'https://vietqr.vn/register?share_code=${state.walletDTO.sharingCode}',
                      context),
                ],
              ),
            );
          }
          return _buildBlankWallet(context);
        },
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return SizedBox(
      child: Row(
        children: [
          const Padding(padding: EdgeInsets.only(left: 25)),
          const Spacer(),
          const Text(
            'Mã giới thiệu',
            style: TextStyle(
              fontSize: 18,
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
    );
  }

  Widget _buildCardCode(String code, BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
          color: DefaultTheme.CARD_CODE_BG,
          borderRadius: BorderRadius.circular(3)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            code,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: DefaultTheme.GREY_TEXT),
          ),
          InkWell(
              onTap: () async {
                await FlutterClipboard.copy(code).then(
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
              child: Image.asset(
                'assets/images/ic-copy.png',
                width: 28,
              )),
        ],
      ),
    );
  }

  Widget _buildBlankWallet(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Mã giới thiệu',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          _buildCardCode('', context),
          const SizedBox(
            height: 20,
          ),
          const Text(
            'Link giới thiệu',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          _buildCardCode('', context),
        ],
      ),
    );
  }
}
