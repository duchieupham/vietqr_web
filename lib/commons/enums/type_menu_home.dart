// ignore_for_file: constant_identifier_names

enum MenuHomeType {
  HOME,
  TRANSACTION,
  BANK_ACCOUNT,
  OPEN_BANK_MB_ACCOUNT,
  SCAN_QR,
  CREATE_QR,
  ADD_LINK_BANK_ACCOUNT,
  WALLET_QR,
  BUSINESS,
  INTRO_VIET_QR,
  SETTING,
  LOGOUT,
  OTHER,
}

extension PageIndex on int {
  MenuHomeType get pageIndex {
    switch (this) {
      case 0:
        return MenuHomeType.HOME;
      case 1:
        return MenuHomeType.TRANSACTION;
      case 2:
        return MenuHomeType.BANK_ACCOUNT;
      case 3:
        return MenuHomeType.OPEN_BANK_MB_ACCOUNT;
      default:
        return MenuHomeType.HOME;
    }
  }
}

extension MenuType on MenuHomeType {
  int get value {
    switch (this) {
      case MenuHomeType.HOME:
        return 0;
      case MenuHomeType.TRANSACTION:
        return 1;
      case MenuHomeType.BANK_ACCOUNT:
        return 2;
      case MenuHomeType.OPEN_BANK_MB_ACCOUNT:
        return 3;
      default:
        return 0;
    }
  }
}
