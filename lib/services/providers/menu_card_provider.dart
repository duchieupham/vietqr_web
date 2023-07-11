import 'package:VietQR/models/account_bank_detail_dto.dart';
import 'package:VietQR/models/qr_generated_dto.dart';
import 'package:flutter/widgets.dart';

class MenuCardProvider with ChangeNotifier {
  bool _isShowMenu = false;
  int _index = 0;

  AccountBankDetailDTO _bankDetailDTO = const AccountBankDetailDTO(
    id: '',
    bankAccount: '',
    userBankName: '',
    bankCode: '',
    bankName: '',
    imgId: '58b7190b-a294-4b14-968f-cd365593893e',
    type: 0,
    userId: '',
    bankTypeId: '',
    bankTypeStatus: 0,
    nationalId: '',
    qrCode: '',
    phoneAuthenticated: '',
    businessDetails: [],
    transactions: [],
    authenticated: false,
    caiValue: '',
  );

  QRGeneratedDTO _qrGeneratedDTO = const QRGeneratedDTO(
    bankCode: '',
    bankName: '',
    bankAccount: '',
    userBankName: '',
    amount: '',
    content: '',
    qrCode: '',
    imgId: '58b7190b-a294-4b14-968f-cd365593893e',
  );

  bool get showMenu => _isShowMenu;
  int get index => _index;
  AccountBankDetailDTO get bankDetailDTO => _bankDetailDTO;
  QRGeneratedDTO get qrGeneratedDTO => _qrGeneratedDTO;

  void updateBankDetail(AccountBankDetailDTO value) {
    _bankDetailDTO = value;
    _qrGeneratedDTO = QRGeneratedDTO(
      bankCode: _bankDetailDTO.bankCode,
      bankName: _bankDetailDTO.bankName,
      bankAccount: _bankDetailDTO.bankAccount,
      userBankName: _bankDetailDTO.userBankName,
      amount: '',
      content: '',
      qrCode: _bankDetailDTO.qrCode,
      imgId: _bankDetailDTO.imgId,
    );
    notifyListeners();
  }

  void updateShowMenu(bool value) {
    _isShowMenu = value;
    notifyListeners();
  }

  void updateIndex(int value) {
    _index = value;
    notifyListeners();
  }

  void reset() {
    _index = 0;
    _bankDetailDTO = const AccountBankDetailDTO(
      id: '',
      bankAccount: '',
      userBankName: '',
      bankCode: '',
      bankName: '',
      imgId: '58b7190b-a294-4b14-968f-cd365593893e',
      type: 0,
      userId: '',
      bankTypeId: '',
      bankTypeStatus: 0,
      nationalId: '',
      qrCode: '',
      phoneAuthenticated: '',
      businessDetails: [],
      transactions: [],
      authenticated: false,
      caiValue: '',
    );
    _qrGeneratedDTO = const QRGeneratedDTO(
      bankCode: '',
      bankName: '',
      bankAccount: '',
      userBankName: '',
      amount: '',
      content: '',
      qrCode: '',
      imgId: '58b7190b-a294-4b14-968f-cd365593893e',
    );
  }
}
