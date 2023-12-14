import 'dart:convert';

import 'package:VietQR/main.dart';
import 'package:VietQR/models/account_information_dto.dart';
import 'package:VietQR/models/info_user_dto.dart';
import 'package:VietQR/models/setting_account_sto.dart';

class UserInformationHelper {
  const UserInformationHelper._privateConsrtructor();

  static const UserInformationHelper _instance =
      UserInformationHelper._privateConsrtructor();
  static UserInformationHelper get instance => _instance;

  Future<void> initialUserInformationHelper() async {
    const AccountInformationDTO accountInformationDTO = AccountInformationDTO(
      userId: '',
      firstName: '',
      middleName: '',
      lastName: '',
      birthDate: '',
      gender: 0,
      address: '',
      email: '',
      imgId: '',
      phoneNo: '',
    );
    await sharedPrefs.setString('USER_ID', '');
    await sharedPrefs.setString('PHONE_NO', '');
    await sharedPrefs.setString(
        'ACCOUNT_INFORMATION', accountInformationDTO.toDataString().toString());
  }

  Future<void> setUserId(String userId) async {
    await sharedPrefs.setString('USER_ID', userId);
  }

  Future<void> setPhoneNo(String phoneNo) async {
    await sharedPrefs.setString('PHONE_NO', phoneNo);
  }

  String getPhoneNo() {
    return sharedPrefs.getString('PHONE_NO')!;
  }

  Future<void> setAccountInformation(AccountInformationDTO dto) async {
    await sharedPrefs.setString(
        'ACCOUNT_INFORMATION', dto.toDataString().toString());
  }

  AccountInformationDTO getAccountInformation() {
    return AccountInformationDTO.fromJson(
        json.decode(sharedPrefs.getString('ACCOUNT_INFORMATION')!));
  }

  String getUserId() {
    return sharedPrefs.getString('USER_ID')!;
  }

  Future<void> setCustomerSyncId(String userId) async {
    await sharedPrefs.setString('Customer_SyncId', userId);
  }

  Future<void> setCustomerSyncTestId(String userId) async {
    await sharedPrefs.setString('Customer_Sync_Test_Id', userId);
  }

  String getCustomerSyncId() {
    return sharedPrefs.getString('Customer_SyncId')!;
  }

  String getCustomerSyncTestId() {
    return sharedPrefs.getString('Customer_Sync_Test_Id')!;
  }

  String getUserFullname() {
    return ('${getAccountInformation().lastName} ${getAccountInformation().middleName} ${getAccountInformation().firstName}')
        .trim();
  }

  Future<void> setAccountSetting(SettingAccountDTO dto) async {
    await sharedPrefs.setString('ACCOUNT_SETTING', dto.toSPJson().toString());
  }

  SettingAccountDTO getAccountSetting() {
    return SettingAccountDTO.fromJson(
        json.decode(sharedPrefs.getString('ACCOUNT_SETTING')!));
  }

  Future<void> setImageId(String imgId) async {
    AccountInformationDTO dto = AccountInformationDTO.fromJson(
        json.decode(sharedPrefs.getString('ACCOUNT_INFORMATION')!));
    AccountInformationDTO newDto = AccountInformationDTO(
        address: dto.address,
        birthDate: dto.birthDate,
        email: dto.email,
        firstName: dto.firstName,
        gender: dto.gender,
        imgId: imgId,
        lastName: dto.lastName,
        middleName: dto.middleName,
        userId: dto.userId,
        phoneNo: dto.phoneNo);
    await sharedPrefs.setString(
        'ACCOUNT_INFORMATION', newDto.toDataString().toString());
  }

  Future<void> setLoginAccount(List<String> list) async {
    await sharedPrefs.setStringList('LOGIN_ACCOUNT', list);
  }

  List<InfoUserDTO> getLoginAccount() {
    return ListLoginAccountDTO.fromJson(
            sharedPrefs.getStringList('LOGIN_ACCOUNT'))
        .list;
  }
}
