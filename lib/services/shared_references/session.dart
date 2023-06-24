import 'dart:async';
import 'dart:html' as html;
import 'package:VietQR/features/home/repositories/user_setting_repository.dart';
import 'package:VietQR/services/shared_references/account_helper.dart';
import 'package:VietQR/services/shared_references/guide_helper.dart';
import 'package:VietQR/services/shared_references/user_information_helper.dart';
import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../commons/enums/event_type.dart';
import '../../models/qr_generated_dto.dart';

class Session {
  static final Session _singleton = Session._privateConstructor();

  Session._privateConstructor();

  static Future<Session> get load async {
    await _singleton.init();
    return _singleton;
  }

  late SharedPreferences sharedPrefs;
  static Session get instance => _singleton;
  final StreamController<EventType> _eventStream =
      StreamController<EventType>();
  late StreamSubscription<EventType> _eventListener;
  final _initSession = AsyncMemoizer();

  Future init() => _initSession.runOnce(_init);

  Future _init() async {
    // muốn khởi tạo những gì khi mới vào app sẽ viết ở đây
    _eventListener = _eventStream.stream.listen(_handleEvent);
  }

  final Map<EventTypes, List<Function>> _eventListeners = {};

  bool checkEventExitsListener(EventTypes eventType) =>
      _eventListeners.containsKey(eventType);
  final Map<EventTypes, List<Future>> _eventHandleEx = {};

  Future _handleEvent(EventType et) async {
    if (_eventHandleEx.containsKey(et.eventType)) {
      await Future.wait(_eventHandleEx[et.eventType] as Iterable<Future>);
      _handleEvent(et);
      return;
    }

    if (_eventListeners.containsKey(et.eventType)) {
      for (final Function handler in _eventListeners[et.eventType]!) {
        try {
          handler();
        } catch (e) {
          debugPrint(
              '--------------------handle event error  ${et.eventType} : $e');
        }
      }
    }

    if (_eventHandleEx.containsKey(et.eventType)) {
      await Future.wait(_eventHandleEx[et.eventType] as Iterable<Future>);
      _eventHandleEx.remove(et.eventType);
    }
  }

  void registerEventListener(EventTypes eventType, Function function) {
    if (!_eventListeners.containsKey(eventType)) {
      final List<Function> listF = [];
      _eventListeners[eventType] = listF;
    }
    _eventListeners[eventType]!.add(function);
  }

  void unRegisterEventListener(EventTypes eventType, Function function) {
    if (_eventListeners.containsKey(eventType)) {
      _eventListeners[eventType]!.remove(function);
    }
  }

  Future sendEvent(EventTypes eventType, [dynamic data]) async {
    final EventType et = EventType(eventType, data);
    _eventStream.add(et);
  }

  final UserSettingRepository _userSettingRepository =
      const UserSettingRepository();

  Future getGuideWeb() async {
    String userId = UserInformationHelper.instance.getUserId();
    if (userId.isNotEmpty) {
      bool value = await _userSettingRepository.getGuideWeb(userId);
      await GuideHelper.instance.updateGuideDisable(value);
    }
  }

  String _userECOMId = '';
  String get userECOMId => _userECOMId;

  String _userECOMToken = '';
  String get userECOMToken => _userECOMToken;
  void updateUserECOMId(String value) {
    _userECOMId = value;
  }

  void updateUserECOMToken(String value) {
    _userECOMToken = value;
  }

  String formatDataParamUrl(QRGeneratedDTO qrGeneratedDTO,
      {String action = '', int showBankAccount = 1}) {
    String bankCode = qrGeneratedDTO.bankCode;
    String account = qrGeneratedDTO.bankAccount;
    String name = qrGeneratedDTO.userBankName.replaceAll(' ', '_');
    String amount = qrGeneratedDTO.amount;
    String content = qrGeneratedDTO.content.replaceAll(' ', '_');
    return '?bankCode=$bankCode&account=$account&name=$name&amount=$amount&content=$content&action=$action&showBankAccount=$showBankAccount';
  }
}
