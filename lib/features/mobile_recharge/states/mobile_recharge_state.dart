import 'package:VietQR/models/network_providers_dto.dart';
import 'package:VietQR/models/response_message_dto.dart';
import 'package:equatable/equatable.dart';

class MobileRechargeState extends Equatable {
  const MobileRechargeState();

  @override
  List<Object?> get props => [];
}

class MobileRechargeInitialState extends MobileRechargeState {}

class MobileRechargeLoadingState extends MobileRechargeState {}

class MobileRechargeGetListTypeSuccessState extends MobileRechargeState {
  final List<NetworkProviders> list;

  const MobileRechargeGetListTypeSuccessState({
    required this.list,
  });

  @override
  List<Object?> get props => [list];
}

class MobileRechargeGetListTypeFailedState extends MobileRechargeState {}

class MobileRechargeMobileMoneyLoadingState extends MobileRechargeState {}

class MobileRechargeMobileMoneySuccessState extends MobileRechargeState {
  final ResponseMessageDTO dto;

  const MobileRechargeMobileMoneySuccessState({
    required this.dto,
  });

  @override
  List<Object?> get props => [dto];
}

class MobileRechargeMobileMoneyFailedState extends MobileRechargeState {
  final ResponseMessageDTO dto;

  const MobileRechargeMobileMoneyFailedState({
    required this.dto,
  });

  @override
  List<Object?> get props => [dto];
}

class RechargeUpdateTypeUpdateSuccessState extends MobileRechargeState {}
