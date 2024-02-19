import 'package:equatable/equatable.dart';

class MerchantRequestEvent extends Equatable {
  const MerchantRequestEvent();

  @override
  List<Object?> get props => [];
}

class InsertMerchantEvent extends MerchantRequestEvent {
  final Map<String, dynamic> param;

  const InsertMerchantEvent(this.param);

  @override
  List<Object?> get props => [param];
}

class CheckValidMerchantName extends MerchantRequestEvent {
  final Map<String, dynamic> param;

  const CheckValidMerchantName(this.param);

  @override
  List<Object?> get props => [param];
}

class ClearState extends MerchantRequestEvent {}

class GenerateUserNamePass extends MerchantRequestEvent {
  final Map<String, dynamic> param;

  const GenerateUserNamePass(this.param);

  @override
  List<Object?> get props => [param];
}

class GetTokenEvent extends MerchantRequestEvent {
  final Map<String, dynamic> param;
  const GetTokenEvent({required this.param});

  @override
  List<Object?> get props => [param];
}
