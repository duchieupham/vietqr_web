import 'package:VietQR/models/related_transaction_receive_dto.dart';

class BusinessItemDTO {
  final String businessId;
  final String code;
  final int role;
  final String imgId;
  final String coverImgId;
  final String name;
  final String address;
  final String taxCode;
  final List<RelatedTransactionReceiveDTO> transactions;
  final int totalMember;
  final int totalBranch;

  const BusinessItemDTO({
    required this.businessId,
    required this.code,
    required this.role,
    required this.imgId,
    required this.coverImgId,
    required this.name,
    required this.address,
    required this.taxCode,
    required this.transactions,
    required this.totalMember,
    required this.totalBranch,
  });

  factory BusinessItemDTO.fromJson(Map<String, dynamic> json) {
    List<RelatedTransactionReceiveDTO> transactions = [];
    if (json['transactions'] != null) {
      json['transactions'].forEach((v) {
        transactions.add(RelatedTransactionReceiveDTO.fromJson(v));
      });
    }
    return BusinessItemDTO(
      businessId: json['businessId'] ?? '',
      code: json['code'] ?? '',
      role: json['role'] ?? 0,
      imgId: json['imgId'] ?? '',
      coverImgId: json['coverImgId'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      taxCode: json['taxCode'] ?? '',
      transactions: transactions,
      totalMember: json['totalMember'] ?? 0,
      totalBranch: json['totalBranch'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['businessId'] = businessId;
    data['code'] = code;
    data['role'] = role;
    data['imgId'] = imgId;
    data['coverImgId'] = coverImgId;
    data['name'] = name;
    data['address'] = address;
    data['taxCode'] = taxCode;
    data['transactions'] = transactions;
    data['totalMember'] = totalMember;
    data['totalBranch'] = totalBranch;
    return data;
  }
}
