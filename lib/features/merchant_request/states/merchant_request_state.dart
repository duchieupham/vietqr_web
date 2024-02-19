import 'package:VietQR/models/generate_username_pass_dto.dart';
import 'package:VietQR/models/response_message_dto.dart';
import 'package:equatable/equatable.dart';

class MerchantRequestState extends Equatable {
  const MerchantRequestState();

  @override
  List<Object?> get props => [];
}

class MerchantInitialState extends MerchantRequestState {}

class MerchantLoadingState extends MerchantRequestState {}

class InsertSuccessfulState extends MerchantRequestState {
  final ResponseMessageDTO dto;
  const InsertSuccessfulState({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class InsertFailedState extends MerchantRequestState {
  final ResponseMessageDTO dto;
  const InsertFailedState({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class CheckValidMerchantNameLoadingState extends MerchantRequestState {}

class CheckValidNameSuccessfulState extends MerchantRequestState {
  final ResponseMessageDTO dto;
  const CheckValidNameSuccessfulState({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class CheckValidNameFailedState extends MerchantRequestState {
  final ResponseMessageDTO dto;
  const CheckValidNameFailedState({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class GenerateNamePassLoadingState extends MerchantRequestState {}

class GenerateNamePassSuccessfulState extends MerchantRequestState {
  final GenerateUserNamePassDto dto;
  const GenerateNamePassSuccessfulState({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class NewConnectGetTokenLoadingState extends MerchantRequestState {}

class GetTokenSuccessfulState extends MerchantRequestState {
  final ResponseMessageDTO dto;
  const GetTokenSuccessfulState({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class GetTokenFailedState extends MerchantRequestState {
  final ResponseMessageDTO dto;
  const GetTokenFailedState({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class NewConnectGetPassLoadingState extends MerchantRequestState {}

class GetPassSystemSuccessfulState extends MerchantRequestState {
  final ResponseMessageDTO dto;
  const GetPassSystemSuccessfulState({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class GetPassSystemFailedState extends MerchantRequestState {
  final ResponseMessageDTO dto;
  const GetPassSystemFailedState({required this.dto});

  @override
  List<Object?> get props => [dto];
}
