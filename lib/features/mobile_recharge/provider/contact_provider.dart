import 'dart:io';

import 'package:VietQR/models/contact_dto.dart';
import 'package:flutter/material.dart';

class ContactProvider extends ChangeNotifier {
  int tab = 0;
  bool isEnableBTSave = false;

  List<ContactDTO> listContactDTO = [];

  List<ContactDTO> listSearch = [];

  List<List<ContactDTO>> listAll = [];
  List<List<ContactDTO>> listAllSearch = [];

  String colorType = '0';

  int offset = 0;

  String phoneNo = '';

  File? file;

  bool isIntro = false;

  void updateFile(value) {
    file = value;
    notifyListeners();
  }

  void updateOffset(value) {
    offset = value;
    notifyListeners();
  }

  void updateColorType(value) {
    colorType = value;
    notifyListeners();
  }

  void updatePhoneNo(String value) {
    phoneNo = value;
    notifyListeners();
  }

  void updateTab(value) {
    tab = value;
    notifyListeners();
  }

  void updateListAll(List<List<ContactDTO>> value, List<ContactDTO> list) {
    listAll = value;
    listAllSearch = value;

    listContactDTO = list;
    notifyListeners();
  }

  void updateList(value) {
    listContactDTO = value;
    listSearch = value;
    notifyListeners();
  }

  void onChangeName(String value) {
    if (value.isNotEmpty) {
      isEnableBTSave = true;
    } else {
      isEnableBTSave = false;
    }
    notifyListeners();
  }

  Future<List<List<ContactDTO>>> _compareList(List<ContactDTO> result) async {
    List<List<ContactDTO>> listAll = [];
    List<String> listString = [];

    if (result.isNotEmpty) {
      for (int i = 0; i < result.length; i++) {
        if (result[i].nickname.isNotEmpty) {
          String keyName = result[i].nickname[0].toUpperCase();
          listString.add(keyName);
        } else {
          listString.add('');
        }
      }

      listString = listString.toSet().toList();

      for (int i = 0; i < listString.length; i++) {
        List<ContactDTO> listCompare = [];
        listCompare = result.where((element) {
          if (element.nickname.isNotEmpty) {
            return element.nickname[0].toUpperCase() == listString[i];
          } else {
            return element.nickname.toUpperCase() == listString[i];
          }
        }).toList();

        listAll.add(listCompare);
      }
    }
    return listAll;
  }

  void onSearchAll(String value) async {
    if (value.isNotEmpty) {
      List<ContactDTO> data = listContactDTO
          .where((element) => element.nickname
              .toLowerCase()
              .trim()
              .contains(value.toLowerCase().trim()))
          .toList();

      List<List<ContactDTO>> list = await _compareList(data);

      listAllSearch = list;
    } else {
      listAllSearch = listAll;
    }
    notifyListeners();
  }

  final List<String> listColor = [
    'assets/images/color-type-0.png',
    'assets/images/color-type-1.png',
    'assets/images/color-type-2.png',
    'assets/images/color-type-3.png',
    'assets/images/color-type-4.png',
  ];
}
