enum EventTypes {
  refreshListTransaction,
  updateCountNotification,
  refreshListAccountBank,
}

class EventType {
  final dynamic data;
  final EventTypes eventType;
  EventType(this.eventType, this.data);
}

enum ContactType {
  NONE,
  GET_LIST,
  GET_LIST_PEN,
  GET_DETAIL,
  GET_LIST_RECHARGE,
  REMOVE,
  UPDATE,
  UPDATE_RELATION,
  ERROR,
  SAVE,
  SUGGEST,
  NICK_NAME,
  SCAN,
  SCAN_ERROR,
  SEARCH_USER,
  OTHER,
  VCARD,
  INSERT_VCARD,
}

enum TypeContact {
  VietQR_ID,
  Bank,
  Other,
  VCard,
  Login_Web,
  Sale,
  NONE,
  UPDATE,
  ERROR,
  NOT_FOUND,
}

enum TypeMobileRecharge { QR, SUCCESS, OTHER }
