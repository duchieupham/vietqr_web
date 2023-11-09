import 'package:VietQR/models/response_message_dto.dart';
import 'package:equatable/equatable.dart';

class VhitekState extends Equatable {
  const VhitekState();

  @override
  List<Object?> get props => [];
}

class VhitekStateInitialState extends VhitekState {}

class VhitekStateLoadingState extends VhitekState {}

class VhitekCheckUserValidSuccessState extends VhitekState {
  final ResponseMessageDTO dto;

  const VhitekCheckUserValidSuccessState({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class VhitekCreateUserSuccessState extends VhitekState {
  final ResponseMessageDTO dto;

  const VhitekCreateUserSuccessState({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class VhitekActiveSuccessState extends VhitekState {
  final ResponseMessageDTO dto;

  const VhitekActiveSuccessState({required this.dto});

  @override
  List<Object?> get props => [dto];
}
