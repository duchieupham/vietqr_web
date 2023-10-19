import 'dart:convert';

import 'package:VietQR/commons/enums/event_type.dart';
import 'package:VietQR/commons/widgets/dialog_widget.dart';
import 'package:VietQR/features/transaction/widgets/transaction_success_widget.dart';
import 'package:VietQR/main.dart';
import 'package:VietQR/models/notification_transaction_success_dto.dart';
import 'package:VietQR/services/shared_references/media_helper.dart';
import 'package:VietQR/services/shared_references/session.dart';
import 'package:VietQR/services/shared_references/user_information_helper.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../commons/constants/configurations/stringify.dart';
import '../../commons/utils/log.dart';

class WebSocketHelper {
  WebSocketHelper._privateConstructor();
  static late WebSocketChannel _channelTransaction;
  WebSocketChannel get channelTransaction => _channelTransaction;
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

  void listenTransactionSocket() {
    String userId = UserInformationHelper.instance.getUserId();
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
              if (data['notificationType'] != null &&
                  data['notificationType'] ==
                      Stringify.NOTI_TYPE_UPDATE_TRANSACTION) {
                Session.instance.sendEvent(EventTypes.refreshListTransaction);
                Session.instance.sendEvent(EventTypes.updateCountNotification);
                if (!Session.instance.inQRGeneratePage) {
                  MediaHelper.instance.playAudio(data);
                  DialogWidget.instance.openWidgetDialog(
                    child: TransactionSuccessWidget(
                      dto: NotificationTransactionSuccessDTO.fromJson(data),
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

  void listenTransactionQRSocket(String id, Function transactionSuccess) {
    bool isListenWebSocket =
        WebSocketHelper.instance.getListenTransactionQRWS();

    if (!isListenWebSocket) {
      try {
        setListenTransactionQRWS(true);
        final wsUrl = Uri.parse('wss://api.vietqr.org/vqr/socket?refId=$id');
        _channelTransaction = WebSocketChannel.connect(wsUrl);
        if (_channelTransaction.closeCode == null) {
          _channelTransaction.stream.listen((event) {
            var data = jsonDecode(event);
            if (data['notificationType'] != null &&
                data['notificationType'] ==
                    Stringify.NOTI_TYPE_UPDATE_TRANSACTION) {
              transactionSuccess();
            }
          });
        } else {
          setListenTransactionQRWS(false);
        }
      } catch (e) {
        LOG.error('WS: $e');
      }
    }
  }
}
