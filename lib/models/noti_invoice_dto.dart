class NotificationInvoiceDTO {
  String userId;
  int totalInvoice;
  int totalUnpaid;

  NotificationInvoiceDTO({
    required this.userId,
    required this.totalInvoice,
    required this.totalUnpaid,
  });

  factory NotificationInvoiceDTO.fromJson(Map<String, dynamic> json) {
    return NotificationInvoiceDTO(
      userId: json['userId'] as String,
      totalInvoice: json['totalInvoice'] as int,
      totalUnpaid: json['totalUnpaid'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'totalInvoice': totalInvoice,
      'totalUnpaid': totalUnpaid,
    };
  }
}
