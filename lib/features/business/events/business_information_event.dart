import 'package:VietQR/models/business_information_insert_dto.dart';
import 'package:equatable/equatable.dart';

class BusinessInformationEvent extends Equatable {
  const BusinessInformationEvent();

  @override
  List<Object?> get props => [];
}

class BusinessInformationEventInsert extends BusinessInformationEvent {
  final BusinessInformationInsertDTO dto;

  const BusinessInformationEventInsert({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class BusinessInformationEventGetList extends BusinessInformationEvent {
  final String userId;

  const BusinessInformationEventGetList({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class BusinessGetDetailEvent extends BusinessInformationEvent {
  final String businessId;
  final String userId;

  const BusinessGetDetailEvent({
    required this.businessId,
    required this.userId,
  });

  @override
  List<Object?> get props => [businessId, userId];
}
