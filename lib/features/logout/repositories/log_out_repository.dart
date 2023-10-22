import 'package:VietQR/commons/constants/env/env_config.dart';
import 'package:VietQR/commons/enums/authentication_type.dart';
import 'package:VietQR/commons/utils/base_api.dart';
import 'package:VietQR/commons/utils/log.dart';
import 'package:VietQR/main.dart';
import 'package:VietQR/services/providers/bank_type_provider.dart';
import 'package:VietQR/services/providers/menu_card_provider.dart';
import 'package:VietQR/services/providers/transaction_list_provider.dart';
import 'package:VietQR/services/shared_references/account_helper.dart';
import 'package:VietQR/services/shared_references/user_information_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../create_qr/provider/create_qr_provider.dart';

class LogoutRepository {
  const LogoutRepository();

  Future<bool> logout() async {
    bool result = false;
    try {
      final String url = '${EnvConfig.getBaseUrl()}accounts/logout';
      final response = await BaseAPIClient.postAPI(
        url: url,
        body: {'fcmToken': ''},
        type: AuthenticationType.NONE,
      );
      if (response.statusCode == 200) {
        await _resetServices().then((value) => result = true);
      }
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }

  Future<void> _resetServices() async {
    BuildContext context = NavigationService.navigatorKey.currentContext!;
    Provider.of<BankTypeProvider>(context, listen: false).reset();
    Provider.of<CreateQRProvider>(context, listen: false).reset();
    Provider.of<MenuCardProvider>(context, listen: false).reset();
    Provider.of<TransactionListProvider>(context, listen: false).reset();
    await UserInformationHelper.instance.initialUserInformationHelper();
    await AccountHelper.instance.initialAccountHelper();
  }
}
