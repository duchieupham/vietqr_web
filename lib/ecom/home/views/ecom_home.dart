import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/widgets/button_icon_widget.dart';
import 'package:VietQR/features/bank/blocs/bank_bloc.dart';
import 'package:VietQR/features/token/blocs/token_bloc.dart';
import 'package:VietQR/models/bank_account_dto.dart';
import 'package:VietQR/models/transaction/trans_receive_dto.dart';
import 'package:VietQR/services/shared_references/session.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ECOMHomeScreen extends StatefulWidget {
  const ECOMHomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreen();
}

class _HomeScreen extends State<ECOMHomeScreen> {
  late BankBloc _bankBloc;
  late TokenBloc _tokenBloc;
  int currentPage = 0;
  List<BankAccountDTO> bankAccounts = [];
  List<Color> cardColors = [];

  late WebSocketChannel channel;

  List<TransReceiveDTO> transactions = [];
  String userId = Session.instance.userECOMId;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: SizedBox(
            width: width * 0.9,
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
                SelectableText(Session.instance.userECOMToken),
                const SizedBox(
                  height: 70,
                ),
                Tooltip(
                  message: 'Sao chép mã QR',
                  child: ButtonIconWidget(
                    width: width * 0.6,
                    height: 45,
                    icon: Icons.copy_rounded,
                    title: 'Coppy token',
                    function: () async {
                      await FlutterClipboard.copy(
                              Session.instance.userECOMToken)
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
                    bgColor: Theme.of(context).cardColor,
                    textColor: Theme.of(context).hintColor,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Tooltip(
                  message: 'Thêm tài khoản ngân hàng',
                  child: ButtonIconWidget(
                    width: width * 0.6,
                    height: 45,
                    icon: Icons.add_rounded,
                    title: 'Thêm tài khoản ngân hàng',
                    function: () {
                      context.push('/ecom/bank/create/$userId');
                    },
                    bgColor: Theme.of(context).cardColor,
                    textColor: AppColor.GREEN,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
