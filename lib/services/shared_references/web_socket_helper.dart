import 'dart:convert';
import 'dart:js_interop';

import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/constants/env/env_config.dart';
import 'package:VietQR/commons/enums/env_type.dart';
import 'package:VietQR/commons/enums/event_type.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/commons/widgets/dialog_widget.dart';
import 'package:VietQR/commons/widgets/dot_dash_widget.dart';
import 'package:VietQR/commons/widgets/toast_noti_widget.dart';
import 'package:VietQR/features/invoice_manage/bloc/invoice_bloc.dart';
import 'package:VietQR/features/invoice_manage/event/invoice_events.dart';
import 'package:VietQR/features/mobile_recharge/widget/pop_up_top_up_sucsess.dart';
import 'package:VietQR/features/transaction/widgets/transaction_success_widget.dart';
import 'package:VietQR/layouts/dialog/notify_trans_widget.dart';
import 'package:VietQR/main.dart';
import 'package:VietQR/models/notify_trans_dto.dart';
import 'package:VietQR/models/top_up_sucsess_dto.dart';
import 'package:VietQR/services/providers/invoice_provider.dart';
import 'package:VietQR/services/shared_references/media_helper.dart';
import 'package:VietQR/services/shared_references/session.dart';
import 'package:VietQR/services/shared_references/shared_pref.dart';
import 'package:VietQR/services/shared_references/user_information_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../commons/constants/configurations/stringify.dart';
import '../../commons/utils/log.dart';
import '../../features/create_qr/provider/transaction_qr_provider.dart';

class WebSocketHelper {
  WebSocketHelper._privateConstructor();

  static late WebSocketChannel _channelTransaction;

  WebSocketChannel get channelTransaction => _channelTransaction;

  static late WebSocketChannel _channelQRLink;

  WebSocketChannel get channelQRLink => _channelQRLink;

  static late WebSocketChannel _channelLoginLink;

  WebSocketChannel get channelLoginLink => _channelLoginLink;

  static final WebSocketHelper _instance =
      WebSocketHelper._privateConstructor();

  static WebSocketHelper get instance => _instance;

  Future<void> initialWebSocket() async {
    await sharedPrefs.setBool('IS_LISTEN_WS', false);
  }

  Future<void> setListenWs(bool value) async {
    await sharedPrefs.setBool('IS_LISTEN_WS', value);
  }

  bool isListenWs() {
    return sharedPrefs.getBool('IS_LISTEN_WS') ?? false;
  }

  closeListenTransaction() {
    _channelTransaction.sink.close();
  }

  void listenTransactionSocket({BuildContext? context}) async {
    context ??= NavigationService.navigatorKey.currentContext;
    String userId = UserInformationHelper.instance.getUserId();
    print(userId);
    if (userId.isNotEmpty) {
      bool isListenWebSocket = WebSocketHelper.instance.isListenWs();
      if (!isListenWebSocket) {
        try {
          setListenWs(true);
          final wsUrl =
              Uri.parse('wss://api.vietqr.org/vqr/socket?userId=$userId');
          _channelTransaction = WebSocketChannel.connect(wsUrl);

          if (_channelTransaction.closeCode == null) {
            _channelTransaction.stream.listen((event) {
              var data = jsonDecode(event);

              print('Noti nè: ------------------------------- $data');
              if (data['notificationType'] != null &&
                  (data['notificationType'] == Stringify.NOTI_INVOICE_CREATE ||
                      data['notificationType'] ==
                          Stringify.NOTI_INVOICE_SUCCESS)) {
                Toastification().showCustom(
                  context: context,
                  animationDuration: const Duration(milliseconds: 500),
                  autoCloseDuration: const Duration(seconds: 10),
                  alignment: Alignment.topRight,
                  dismissDirection: DismissDirection.horizontal,
                  builder: (context, holder) {
                    return ToastNotiWidget(
                      data: data,
                    );
                  },
                );
              }

              if (data['notificationType'] != null &&
                  data['notificationType'] ==
                      Stringify.NOTI_TYPE_UPDATE_TRANSACTION) {
                Session.instance.sendEvent(EventTypes.refreshListTransaction);
                Session.instance.sendEvent(EventTypes.updateCountNotification);
                if (!Session.instance.inQRGeneratePage) {
                  MediaHelper.instance.playAudio(data);
                  DialogWidget.instance.showDialogTrans(
                    child: NotifyTransWidget(
                      dto: NotifyTransDTO.fromJson(data),
                    ),
                  );
                }
              }
              if (data['notificationType'] != null &&
                  data['notificationType'] ==
                      Stringify.NOTI_TYPE_MOBILE_RECHARGE) {
                if (data['paymentMethod'] == "1") {
                  DialogWidget.instance.openWidgetDialog(
                    width: 500,
                    height: 540,
                    child: PopupTopUpSuccess(
                      dto: TopUpSuccessDTO.fromJson(data),
                    ),
                  );
                }
              }
            });
          } else {
            setListenWs(false);
          }
        } catch (e) {
          LOG.error('WS: $e');
        }
      }
    }
  }

  Future<void> setListenTransactionQRWS(bool value) async {
    await sharedPrefs.setBool('TRANSACTION_QR_WS', value);
  }

  bool getListenTransactionQRWS() {
    return sharedPrefs.getBool('TRANSACTION_QR_WS') ?? false;
  }

  void listenTransactionQRSocket(
      String id,
      Function(Map<String, dynamic>) transactionSuccess,
      Function transactionCancel,
      {bool isDev = false}) {
    late Uri wsUrl;
    try {
      setListenTransactionQRWS(true);
      if (EnvConfig.getEnv() == EnvType.PROD) {
        wsUrl = Uri.parse('wss://api.vietqr.org/vqr/socket?refId=$id');
      } else {
        wsUrl = Uri.parse('wss://dev.vietqr.org/vqr/socket?refId=$id');
      }

      if (isDev) {
        wsUrl = Uri.parse('wss://dev.vietqr.org/vqr/socket?refId=$id');
      }

      _channelQRLink = WebSocketChannel.connect(wsUrl);
      if (_channelQRLink.closeCode == null) {
        _channelQRLink.stream.listen((event) {
          var data = jsonDecode(event);
          if (data['notificationType'] != null) {
            if (data['notificationType'] ==
                Stringify.NOTI_TYPE_UPDATE_TRANSACTION) {
              transactionSuccess(data);
            } else if (data['notificationType'] ==
                Stringify.NOTI_TYPE_CANCEL_TRANSACTION) {
              transactionCancel();
            }
          }
        });
      } else {
        setListenTransactionQRWS(false);
      }
    } catch (e) {
      LOG.error('WS: $e');
    }
  }

  void listenLoginSocket(String loginID, Function(Map<String, dynamic>) login) {
    try {
      setListenTransactionQRWS(true);
      final wsUrl =
          Uri.parse('wss://api.vietqr.org/vqr/socket?loginId=$loginID');
      _channelLoginLink = WebSocketChannel.connect(wsUrl);
      if (_channelLoginLink.closeCode == null) {
        _channelLoginLink.stream.listen((event) {
          var data = jsonDecode(event);
          print('-------------------------------------- $data');
          login(data);
        });
      } else {
        setListenTransactionQRWS(false);
      }
    } catch (e) {
      LOG.error('WS: $e');
    }
  }
}
