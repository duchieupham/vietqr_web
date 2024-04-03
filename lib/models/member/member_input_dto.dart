class MemberInputDTO {
  String merchantId;
  String value;
  int type;
  int page;
  int size;

  MemberInputDTO({
    this.merchantId = '',
    this.value = '',
    this.type = 0, // type: 0: phoneNo, 1: fullName
    this.page = 1,
    this.size = 20,
  });
}
