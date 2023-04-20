import 'package:VietQR/main.dart';

class WebSocketHelper {
  const WebSocketHelper._privateConsrtructor();

  static const WebSocketHelper _instance =
      WebSocketHelper._privateConsrtructor();
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
}
