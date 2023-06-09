import 'dart:convert';

import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/log.dart';
import 'package:flutter/material.dart';
import 'dart:html';

class UserInformationUtils {
  const UserInformationUtils._privateConsrtructor();

  static const UserInformationUtils _instance =
      UserInformationUtils._privateConsrtructor();
  static UserInformationUtils get instance => _instance;

  String formatFullName(String firstName, String middleName, String lastName) {
    String result = '';
    result = '$lastName $middleName $firstName';
    return result;
  }

  String formatMemberRole(int role) {
    String result = '';
    if (role == 1) {
      result = 'Chủ thẻ';
    } else if (role == 2) {
      result = 'Quản lý';
    } else {
      result = 'Thành viên';
    }
    return result;
  }

  Color getMemberRoleColor(int role) {
    Color result = DefaultTheme.GREEN;
    if (role == 1) {
      result = DefaultTheme.BLUE_TEXT;
    } else if (role == 2) {
      result = DefaultTheme.ORANGE;
    } else {
      result = DefaultTheme.GREEN;
    }
    return result;
  }

  int getRoleForInsert(int roleUser) {
    int result = 0;
    if (roleUser == 1) {
      result = 2;
    } else if (roleUser == 2) {
      result = 3;
    } else {
      result = 3;
    }
    return result;
  }

  //get user device IP address
  Future<String> getIPAddress() async {
    String result = '';
    try {
      final response =
          await HttpRequest.request('https://api.ipify.org?format=json');
      final data = json.decode(response.responseText ?? '');
      result = data['ip'] ?? '';
    } catch (e) {
      LOG.error(e.toString());
    }
    return result;
  }
}
