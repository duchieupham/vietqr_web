import 'dart:convert';

import 'package:VietQR/commons/enums/text_data.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class StringUtils {
  const StringUtils._privateConstructor();

  static const StringUtils _instance = StringUtils._privateConstructor();

  static StringUtils get instance => _instance;

  final String _transactionContentWithoutVietnamesePattern =
      r'^[a-zA-Z0-9.,!@#$&*/? ]+$';
  final String _transactionContentPattern = r'^[a-zA-ZÀ-ỹẠ-ỵ0-9.,!@#$&*/? ]+$';
  final String _fullNamePattern = r'^[a-zA-ZÀ-ỹẠ-ỵ0-9 ]+$';
  final String _phonePattern = r'^(?:[+0]9)?[0-9]{10}$';

  static const bool isWeb = kIsWeb;
  static final bool isAndroid =
      (defaultTargetPlatform == TargetPlatform.android);
  static final bool isIOS = (defaultTargetPlatform == TargetPlatform.iOS);

  bool isNumeric(String text) {
    return int.tryParse(text) != null;
  }

  bool isValidPassword(String text) {
    bool check = false;
    if (text.length >= 8 && text.length <= 30) {
      if (text.contains(RegExp(r'^[A-Za-z0-9_.]+$'))) {
        check = true;
      }
    }
    return check;
  }

  bool isValidConfirmText(String text, String confirmText) {
    return text.trim() == confirmText.trim();
  }

  static String formatMoney(String money) {
    if (money.length > 2) {
      var value = money;
      value = value.replaceAll(RegExp(r'\D'), '');
      value = value.replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), ',');
      return value;
    }
    return money;
  }

  bool isValidFullName(String text) {
    bool result = false;
    final RegExp regExp = RegExp(_fullNamePattern);
    if (text.isNotEmpty) {
      if (regExp.hasMatch(text)) {
        result = true;
      }
    }
    return result;
  }

  bool isValidTransactionContent(String text) {
    bool result = false;
    final RegExp regExp = RegExp(_transactionContentPattern);
    if (text.isNotEmpty) {
      if (regExp.hasMatch(text)) {
        result = true;
      }
    } else {
      result = true;
    }
    return result;
  }

  bool isValidTransactionWithoutVietnameseContent(String text) {
    bool result = false;
    final RegExp regExp = RegExp(_transactionContentWithoutVietnamesePattern);
    if (regExp.hasMatch(text)) {
      result = true;
    } else {
      result = false;
    }
    return result;
  }

  String removeDiacritic(String input) {
    String result = '';
    for (int i = 0; i < input.length; i++) {
      final char = input[i];
      final replacedChar = diacriticsMap[char] ?? char;
      result += replacedChar;
    }
    return result;
  }

  String capitalFirstCharacter(String paragraph) {
    String result = '';
    result = paragraph
        .toLowerCase()
        .trim()
        .split(" ")
        .map((str) => toBeginningOfSentenceCase(str))
        .join(" ");
    return result;
  }

  static String formatNumber(dynamic value) {
    if (value == null) {
      return '0';
    }
    var numberFormat = NumberFormat.decimalPattern('en');
    return numberFormat.format(value);
  }

  static String formatNumberAmount(dynamic value) {
    if (value == null || value == '') {
      return '0 VND';
    }

    if (value is String) {
      if (value.isNotEmpty) {
        value = int.parse(value);
      }
    }
    var numberFormat = NumberFormat.decimalPattern('vi-VI');
    return '${numberFormat.format(value).replaceAll('.', ',')} VND';
  }

  String? validatePhone(String value) {
    RegExp regExp = RegExp(_phonePattern);
    if (value.isEmpty) {
      return null;
    } else if (!regExp.hasMatch(value)) {
      return 'Số điện thoại không đúng định dạng.';
    }
    return null;
  }

  String formatPhoneNumberVN(String phoneNumber) {
    String numericString = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');

    if (numericString.length >= 10) {
      return phoneNumber.replaceAllMapped(RegExp(r'(\d{3})(\d{3})(\d+)'),
          (Match m) => "${m[1]} ${m[2]} ${m[3]}");
    } else {
      if (numericString.length == 8) {
        return '${numericString.substring(0, 4)} ${numericString.substring(4, 8)}';
      }
      return numericString;
    }
  }

  String authBase64(String username, String password) {
    String credentials = "$username:$password";
    String credentialsBase64 = base64Encode(utf8.encode(credentials));
    return credentialsBase64;
  }
}
