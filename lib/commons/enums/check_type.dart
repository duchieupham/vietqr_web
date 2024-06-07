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
  SUCCESS,
  LOAD_MORE,
  ERROR,
}

enum InvoiceType {
  NONE,
  GET_BANKS,
  GET_LIST_FEE,
  GET_INVOICE_LIST,
  INVOCIE_RECHARGE,
  INVOICE_DETAIL,
  INVOICE_EXCEL,
  REQUEST_PAYMENT,
  FILTER_INVOICE,
  DIALOG,
}

enum BankType {
  QR,
  NONE,
  SCAN,
  BANK,
  GET_BANK,
  GET_BANK_TYPE,
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
  QR_VCARD,
  NEGATIVE_ONE,
  QR_SALE,
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

enum TypeFilter {
  ALL,
  BANK_NUMBER,
  TRANS_CODE,
  ORDER_ID,
  CONTENT,
  CODE_SALE,
  NONE
}

extension TypeFilterExt on int {
  TypeFilter get type {
    switch (this) {
      case 9:
        return TypeFilter.ALL;
      case 0:
        return TypeFilter.BANK_NUMBER;
      case 1:
        return TypeFilter.TRANS_CODE;
      case 2:
        return TypeFilter.ORDER_ID;
      case 3:
        return TypeFilter.CONTENT;
      case 4:
        return TypeFilter.CODE_SALE;
      default:
        return TypeFilter.NONE;
    }
  }
}

enum TypeTimeFilter {
  ALL,
  TODAY,
  SEVEN_LAST_DAY,
  THIRTY_LAST_DAY,
  THREE_MONTH_LAST_DAY,
  PERIOD,
  NONE
}

extension TypeTimeFilterExt on TypeTimeFilter {
  int get id {
    switch (this) {
      case TypeTimeFilter.ALL:
        return 0;
      case TypeTimeFilter.TODAY:
        return 2;
      case TypeTimeFilter.SEVEN_LAST_DAY:
        return 1;
      case TypeTimeFilter.THIRTY_LAST_DAY:
        return 3;
      case TypeTimeFilter.THREE_MONTH_LAST_DAY:
        return 4;
      case TypeTimeFilter.PERIOD:
        return 5;
      default:
        return 0;
    }
  }
}
