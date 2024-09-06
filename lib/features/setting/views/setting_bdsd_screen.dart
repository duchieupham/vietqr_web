import 'dart:convert';

import 'package:VietQR/commons/constants/configurations/app_image.dart';
import 'package:VietQR/commons/constants/env/env_config.dart';
import 'package:VietQR/commons/enums/authentication_type.dart';
import 'package:VietQR/commons/utils/base_api.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/commons/utils/log.dart';
import 'package:VietQR/features/add_bank/blocs/bank_bloc.dart';
import 'package:VietQR/features/add_bank/states/bank_state.dart';
import 'package:VietQR/features/home/event/home_event.dart';
import 'package:VietQR/models/bank_account_dto.dart';
import 'package:VietQR/services/shared_references/user_information_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../commons/constants/configurations/theme.dart';
import '../../../services/providers/setting_provider.dart';
import '../blocs/setting_bloc.dart';
import '../events/setting_event.dart';

class SettingBDSD extends StatefulWidget {
  const SettingBDSD({super.key});

  @override
  State<SettingBDSD> createState() => _SettingBDSDState();
}

class _SettingBDSDState extends State<SettingBDSD> {
  List<BankAccountDTO> banks = [];

  bool onOffBdsd = false;

  @override
  void initState() {
    super.initState();
    getListBankAccount();

    // banks = Provider.of<SettingProvider>(context, listen: false).bankAccounts;
  }

  Future<void> getListBankAccount() async {
    List<BankAccountDTO> result = [];

    try {
      final String url =
          '${EnvConfig.getBaseUrl()}account-bank/${UserInformationHelper.instance.getUserId()}';
      final response = await BaseAPIClient.getAPI(
        url: url,
        type: AuthenticationType.SYSTEM,
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data != null) {
          result = data.map<BankAccountDTO>((json) {
            return BankAccountDTO.fromJson(json);
          }).toList();
          setState(() {
            banks = result
                .where((e) =>
                    e.userId == UserInformationHelper.instance.getUserId() &&
                    e.isAuthenticated)
                .toList();
            onOffBdsd = banks.every((element) => element.pushNotification == 1);
          });
        }
      }
    } catch (e) {
      LOG.error(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingProvider>(
      builder: (context, provider, child) {
        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          children: [
            const SizedBox(
              height: 48,
            ),
            const Text(
              'Cài đặt giọng nói',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            _buildBgItem(
              customPadding: EdgeInsets.zero,
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Giọng nói được kích hoạt khi nhận thông báo Biến động số dư trong ứng dụng VietQR',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    provider.enableVoice ? 'Bật' : 'Tắt',
                    style: const TextStyle(
                        fontSize: 12, color: AppColor.GREY_TEXT),
                  ),
                  Switch(
                    value: provider.enableVoice,
                    activeColor: AppColor.BLUE_TEXT,
                    onChanged: (bool value) {
                      provider.updateOpenVoice(value);
                      Map<String, dynamic> param = {};
                      param['userId'] =
                          UserInformationHelper.instance.getUserId();
                      param['value'] = value ? 1 : 0;
                      param['type'] = 0;
                      BlocProvider.of<SettingBloc>(context)
                          .add(UpdateVoiceSetting(param: param));
                    },
                  ),
                ],
              ),
            ),
            _buildBgNote(
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '- Giọng nói thông báo biến động số dư hoạt động khi bạn đang sử dụng ứng dụng.',
                    style: TextStyle(fontSize: 11),
                  ),
                  Text(
                    '- Các trường hợp chạy nền, tắt ứng dụng thì giọng nói sẽ không hoạt động.',
                    style: TextStyle(fontSize: 11),
                  ),
                  Text(
                    '- Âm lượng thiết bị của bạn phải luôn bật.',
                    style: TextStyle(fontSize: 11),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            const Text(
              'Danh sách tài khoản nhận biến động số dư',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 16,
            ),
            _buildListBank(),
            _buildBgNote(
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '- Biến động số dư được bật khi bạn cho phép tính năng này hoạt động.',
                    style: TextStyle(fontSize: 11),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    '- Danh sách tài khoản ngân hàng khả dụng để nhận biến động số dư là các tài khoản ngân hàng đã được liên kết với hệ thống VietQR VN.',
                    style: TextStyle(fontSize: 11),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 40,
            ),
          ],
        );
      },
    );
  }

  Widget _buildListBank() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            height: 34,
            decoration: BoxDecoration(
              color: AppColor.GREY_BG,
              border: Border.all(color: AppColor.GREY_LIGHT),
              borderRadius: BorderRadius.circular(5),
            ),
            child: TextField(
              style: const TextStyle(fontSize: 12),
              onChanged: onSearch,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 12, right: 12, top: 4),
                hintText: 'Tìm kiếm theo số TK ngân hàng',
                hintStyle: TextStyle(fontSize: 12, color: AppColor.GREY_TEXT),
                prefixIcon:
                    Icon(Icons.search, color: AppColor.GREY_TEXT, size: 18),
                fillColor: AppColor.GREY_BG,
                filled: true,
                suffixIconConstraints: BoxConstraints(),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: Container(
                width: 100,
                height: 45,
                padding: const EdgeInsets.all(4),
                color: AppColor.BLUE_TEXT.withOpacity(0.3),
                child: const Center(
                  child: Text(
                    'Tài khoản ngân hàng',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            Container(
              height: 45,
              // width: 100,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              color: AppColor.BLUE_TEXT.withOpacity(0.3),
              child: const Center(
                child: Text(
                  'Thông báo BĐSD',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Thông báo BĐSD tất cả ngân hàng',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              CupertinoSwitch(
                activeColor: AppColor.BLUE_TEXT,
                value: onOffBdsd,
                onChanged: (value) async {
                  await setNotificationBDSD(value ? 1 : 0).then(
                    (isSuccess) {
                      getListBankAccount();
                    },
                  );
                },
              )
            ],
          ),
        ),
        if (banks.isNotEmpty)
          Column(
            children: List.generate(banks.length, (index) {
              BankAccountDTO dto = banks[index];
              return Container(
                padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: AppColor.GREY_BORDER),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Image(
                              image: ImageUtils.instance
                                  .getImageNetWork(dto.imgId),
                              width: 62),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    dto.bankAccount,
                                    style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    dto.userBankName.toUpperCase(),
                                    style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    CupertinoSwitch(
                      activeColor: AppColor.BLUE_TEXT,
                      value: dto.pushNotification == 0 ? false : true,
                      onChanged: (value) async {
                        await setBankNotiBDSD(dto.bankId, value ? 1 : 0).then(
                          (value) {
                            if (value) {
                              setState(() {
                                banks[index] = BankAccountDTO(
                                  bankAccount: dto.bankAccount,
                                  bankCode: dto.bankCode,
                                  bankId: dto.bankId,
                                  bankName: dto.bankName,
                                  bankShortName: dto.bankShortName,
                                  bankTypeId: dto.bankTypeId,
                                  bankTypeStatus: dto.bankTypeStatus,
                                  caiValue: dto.caiValue,
                                  ewalletToken: dto.ewalletToken,
                                  imgId: dto.imgId,
                                  isAuthenticated: dto.isAuthenticated,
                                  isOwner: dto.isOwner,
                                  nationalId: dto.nationalId,
                                  phoneAuthenticated: dto.phoneAuthenticated,
                                  pushNotification:
                                      dto.pushNotification == 0 ? 1 : 0,
                                  qrCode: dto.qrCode,
                                  terminalId: dto.terminalId,
                                  type: dto.type,
                                  unlinkedType: dto.unlinkedType,
                                  userBankName: dto.userBankName,
                                  userId: dto.userId,
                                );
                              });
                            }
                          },
                        );
                      },
                    ),
                  ],
                ),
              );
            }),
          )
        else
          Center(
            child: Text(
              'không có cửa hàng',
              style: TextStyle(fontSize: 12, color: AppColor.BLACK),
            ),
          ),
      ],
    );
  }

  Widget _buildBgItem({required Widget child, EdgeInsets? customPadding}) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(top: 12),
      padding: customPadding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), color: AppColor.WHITE),
      child: child,
    );
  }

  Widget _buildBgNote({required Widget child}) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppColor.BLUE_TEXT.withOpacity(0.2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: const [
              Icon(
                Icons.info_outline,
                color: AppColor.BLUE_TEXT,
                size: 16,
              ),
              SizedBox(width: 4),
              Expanded(
                child: Text(
                  'Lưu ý:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColor.BLUE_TEXT,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          child,
        ],
      ),
    );
  }

  Future<bool> setNotificationBDSD(int value) async {
    try {
      Map<String, dynamic> body = {};
      body['value'] = value;
      final String url =
          '${EnvConfig.getBaseUrl()}account-bank/user/${UserInformationHelper.instance.getUserId()}/update-noti';
      final response = await BaseAPIClient.postAPI(
        url: url,
        body: body,
        type: AuthenticationType.SYSTEM,
      );
      return response.statusCode == 200;
    } catch (e) {
      LOG.error(e.toString());
    }
    return false;
  }

  Future<bool> setBankNotiBDSD(String bankId, int value) async {
    try {
      Map<String, dynamic> body = {};
      body['value'] = value;
      final String url =
          '${EnvConfig.getBaseUrl()}account-bank/update-noti/$bankId';
      final response = await BaseAPIClient.postAPI(
        url: url,
        body: body,
        type: AuthenticationType.SYSTEM,
      );
      return response.statusCode == 200;
    } catch (e) {
      LOG.error(e.toString());
    }
    return false;
  }

  void onSearch(String value) {
    banks = Provider.of<SettingProvider>(context, listen: false).bankAccounts;
    List<BankAccountDTO> values = [];
    List<BankAccountDTO> listMaps = [...banks];
    if (value.trim().isNotEmpty) {
      values.addAll(listMaps
          .where((dto) =>
              dto.bankAccount.toUpperCase().contains(value.toUpperCase()) ||
              dto.bankShortName.toUpperCase().contains(value.toUpperCase()) ||
              dto.userBankName.toUpperCase().contains(value.toUpperCase()))
          .toList());
    } else {
      values = listMaps;
    }
    setState(() {
      banks = values;
    });
  }
}
