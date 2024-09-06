import 'package:VietQR/commons/constants/configurations/app_image.dart';
import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/constants/env/env_config.dart';
import 'package:VietQR/commons/enums/authentication_type.dart';
import 'package:VietQR/commons/utils/base_api.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/commons/utils/log.dart';
import 'package:VietQR/models/bank_account_dto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ChooseBankWidget extends StatefulWidget {
  final List<BankAccountDTO> banks;

  const ChooseBankWidget({super.key, required this.banks});

  @override
  State<ChooseBankWidget> createState() => _ChooseBankWidgetState();
}

class _ChooseBankWidgetState extends State<ChooseBankWidget> {
  List<BankAccountDTO> banks = [];

  @override
  void initState() {
    super.initState();
    banks = [...widget.banks];
    setState(() {});
  }

  Future<bool> setNotificationBDSD(String bankId, int value) async {
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Material(
        color: AppColor.TRANSPARENT,
        child: Center(
          child: Container(
            width: 500,
            height: 550,
            padding: const EdgeInsets.symmetric(vertical: 24),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Chọn Tk ngân hàng',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 12),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.close, size: 18),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 30),
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
                        contentPadding:
                            EdgeInsets.only(left: 12, right: 12, top: 4),
                        hintText: 'Tìm kiếm theo số TK ngân hàng',
                        hintStyle:
                            TextStyle(fontSize: 12, color: AppColor.GREY_TEXT),
                        prefixIcon: Icon(Icons.search,
                            color: AppColor.GREY_TEXT, size: 18),
                        fillColor: AppColor.GREY_BG,
                        filled: true,
                        suffixIconConstraints: BoxConstraints(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                if (banks.isNotEmpty)
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: List.generate(banks.length, (index) {
                          BankAccountDTO dto = banks[index];
                          return Container(
                            padding: const EdgeInsets.fromLTRB(0, 12, 16, 12),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: AppColor.GREY_BORDER),
                              ),
                            ),
                            child: InkWell(
                              onTap: () => Navigator.pop(context, dto),
                              child: Row(
                                children: [
                                  Image(
                                      image: ImageUtils.instance
                                          .getImageNetWork(dto.imgId),
                                      width: 62),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                  Image(
                                      image: ImageUtils.instance
                                          .getImageNetWork(
                                              AppImages.icChooseNext),
                                      width: 32),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  )
                else
                  const Expanded(
                    child: Center(
                      child: Text(
                        'không có cửa hàng',
                        style: TextStyle(fontSize: 12, color: AppColor.BLACK),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onSearch(String value) {
    banks = widget.banks;
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
