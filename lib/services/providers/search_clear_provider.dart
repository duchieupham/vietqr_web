import 'package:VietQR/commons/enums/check_type.dart';
import 'package:VietQR/models/business_member_dto.dart';
import 'package:flutter/material.dart';

class SearchClearProvider extends ValueNotifier {
  SearchClearProvider(super.value);

  void updateClearSearch(bool check) {
    value = check;
  }
}

class SearchProvider with ChangeNotifier {
  TypeAddMember _typeMember = TypeAddMember.MORE;

  TypeAddMember get typeMember => _typeMember;

  BusinessMemberDTO _dto = BusinessMemberDTO(
    userId: '',
    status: '',
    existed: 0,
    imgId: '',
    name: '',
    phoneNo: '',
    role: 0,
  );

  BusinessMemberDTO get dto => _dto;

  void updateDTO(value) {
    _dto = value;
    notifyListeners();
  }

  void updateExisted(value) {
    _typeMember = value;
    notifyListeners();
  }
}
