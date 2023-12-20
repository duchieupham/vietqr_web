import 'dart:async';

import 'package:VietQR/features/home/repositories/user_setting_repository.dart';
import 'package:VietQR/features/information_user/repositories/wallet_repository.dart';
import 'package:VietQR/features/merchant/repositories/merchant_repository.dart';
import 'package:VietQR/models/account_is_merchant.dart';
import 'package:VietQR/models/wallet_dto.dart';
import 'package:VietQR/services/shared_references/guide_helper.dart';
import 'package:VietQR/services/shared_references/user_information_helper.dart';
import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../commons/enums/event_type.dart';
import '../../features/setting/repositories/setting_repository.dart';
import '../../models/bank_account_dto.dart';
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
      {String action = '', int showBankAccount = 1, int isAuthen = 0}) {
    String bankCode = qrGeneratedDTO.bankCode;
    String account = qrGeneratedDTO.bankAccount;
    String name = qrGeneratedDTO.userBankName.replaceAll(' ', '_');
    String amount = qrGeneratedDTO.amount;
    String content = qrGeneratedDTO.content.replaceAll(' ', '_');
    return '?bankCode=$bankCode&account=$account&name=$name&amount=$amount&content=$content&action=$action';
  }

  // Wallet
  final WalletRepository walletRepository = const WalletRepository();

  WalletDTO _wallet = const WalletDTO();
  WalletDTO get wallet => _wallet;
  Future fetchWallet() async {
    String userId = UserInformationHelper.instance.getUserId();
    final WalletDTO dto = await walletRepository.getInfoWallet(userId);
    _wallet = dto;
  }

  // Account setting
  final SettingRepository settingRepository = const SettingRepository();
  Future fetchAccountSetting() async {
    String userId = UserInformationHelper.instance.getUserId();
    final settingAccount = await settingRepository.getSettingAccount(userId);
    if (settingAccount.userId.isNotEmpty) {
      await UserInformationHelper.instance.setAccountSetting(settingAccount);
    }
  }

  List<BankAccountDTO> _bankAccounts = [];

  List<BankAccountDTO> get listBankAuth => _bankAccounts;

  void updateBankAccountsAuth(List<BankAccountDTO> value) {
    _bankAccounts = value
        .where((bankAccount) =>
            bankAccount.isAuthenticated &&
            bankAccount.userId == UserInformationHelper.instance.getUserId())
        .toList();
  }

  final MerchantRepository merchantRepository = const MerchantRepository();

  AccountIsMerchantDTO _accountIsMerchantDTO = const AccountIsMerchantDTO();
  AccountIsMerchantDTO get accountIsMerchantDTO => _accountIsMerchantDTO;
  List<BankAccountDTO> _listBankAccountOfMerchant = [];
  List<BankAccountDTO> get listBankAccountOfMerchant =>
      _listBankAccountOfMerchant;

  Future checkAccountIsMerchant() async {
    String userId = UserInformationHelper.instance.getUserId();
    if (userId.isNotEmpty) {
      if (_accountIsMerchantDTO.accountId.isEmpty) {
        AccountIsMerchantDTO dto =
            await merchantRepository.checkAccountIsMerchant(userId);

        UserInformationHelper.instance.setCustomerSyncId(dto.customerSyncId);
        UserInformationHelper.instance
            .setCustomerSyncTestId(dto.customerSyncTestId);
        _accountIsMerchantDTO = dto;
        if (dto.customerSyncId.isNotEmpty) {
          _listBankAccountOfMerchant =
              await merchantRepository.getListBank(dto.customerSyncId);
          UserInformationHelper.instance.setAccountIsMerchant(true);
        } else {
          UserInformationHelper.instance.setAccountIsMerchant(false);
        }
      }
    }
  }

  clearData() {
    _accountIsMerchantDTO = const AccountIsMerchantDTO();
    _listBankAccountOfMerchant = [];
  }

  bool inQRGeneratePage = false;
  updateQRGeneratePage(bool value) {
    inQRGeneratePage = value;
  }
}
