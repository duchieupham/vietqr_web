// ignore_for_file: constant_identifier_names

enum CheckType {
  C01,
  C02,
  C03,
  C04,
  C05,
}

enum TypeMoveEvent { LEFT, RIGHT, NONE }

enum TypeAddMember { MORE, ADDED, AWAIT }

extension TypeMemberExt on TypeAddMember {
  int get existed {
    switch (this) {
      case TypeAddMember.MORE:
        return 0;
      case TypeAddMember.ADDED:
        return 1;
      case TypeAddMember.AWAIT:
      default:
        return 2;
    }
  }
}

enum BlocStatus {
  NONE,
  LOADING,
  UNLOADING,
}

enum BankType {
  QR,
  NONE,
  SCAN,
  BANK,
  GET_BANK,
  SCAN_ERROR,
  SCAN_NOT_FOUND,
  ERROR,
  GET_DETAIL,
}

enum TypeQR {
  NONE,
  QR_ID,
  QR_CMT,
  QR_BANK,
  QR_BARCODE,
  OTHER,
  QR_LINK,
  NEGATIVE_TWO,
  NEGATIVE_ONE,
}

extension TypeQRExt on TypeQR {
  String get value {
    switch (this) {
      case TypeQR.NEGATIVE_TWO:
        return '-2';
      case TypeQR.NEGATIVE_ONE:
        return '-1';
      case TypeQR.QR_CMT:
      case TypeQR.QR_BANK:
      default:
        return '0';
    }
  }
}
