import 'package:VietQR/models/callback_dto.dart';
import 'package:equatable/equatable.dart';

class CallbackEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetTransEvent extends CallbackEvent {
  final String? customerId;
  final bool isLoading;
  final String bankId;
  GetTransEvent({this.customerId, this.isLoading = true, required this.bankId});

  @override
  List<Object?> get props => [customerId];
}

class GetTransLoadMoreEvent extends CallbackEvent {
  final String? bankId;
  final String? customerId;
  final int offset;
  final bool isLoading;
  final List<CallBackDTO> list;

  GetTransLoadMoreEvent(
      {this.bankId,
      this.customerId,
      this.isLoading = true,
      this.offset = 0,
      this.list = const []});

  @override
  List<Object?> get props => [bankId, customerId];
}

class GetListCustomerEvent extends CallbackEvent {}

class GetListBankEvent extends CallbackEvent {
  final String customerId;

  GetListBankEvent({required this.customerId});

  @override
  List<Object?> get props => [customerId];
}

class GetInfoConnectEvent extends CallbackEvent {
  final String id;
  final String platform;

  GetInfoConnectEvent({required this.platform, required this.id});

  @override
  List<Object?> get props => [id, platform];
}

class GetTokenEvent extends CallbackEvent {
  final String systemUsername;
  final String systemPassword;

  GetTokenEvent({required this.systemUsername, required this.systemPassword});

  @override
  List<Object?> get props => [systemUsername, systemPassword];
}

class RunCallbackEvent extends CallbackEvent {
  final Map<String, dynamic> body;

  RunCallbackEvent(this.body);

  @override
  List<Object?> get props => [body];
}
