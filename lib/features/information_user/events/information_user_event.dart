import 'dart:typed_data';

import 'package:VietQR/models/account_information_dto.dart';
import 'package:equatable/equatable.dart';

class InformationUserEvent extends Equatable {
  const InformationUserEvent();
  @override
  List<Object?> get props => [];
}

class InformationUserEditEvent extends InformationUserEvent {
  final AccountInformationDTO dto;

  const InformationUserEditEvent({required this.dto});

  @override
  List<Object?> get props => [dto];
}

class InformationUserEditPassEvent extends InformationUserEvent {
  final String userId;
  final String phoneNo;
  final String oldPassword;
  final String newPassword;

  const InformationUserEditPassEvent({
    required this.userId,
    required this.phoneNo,
    required this.oldPassword,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [userId, phoneNo, oldPassword, newPassword];
}

class UserEditAvatarEvent extends InformationUserEvent {
  final String userId;
  final String imgId;
  final List<int>? imageByte;

  const UserEditAvatarEvent({
    required this.userId,
    required this.imgId,
    required this.imageByte,
  });

  @override
  List<Object?> get props => [userId, imgId, imageByte];
}

class UserDeActiveEvent extends InformationUserEvent {
  final String userId;

  const UserDeActiveEvent({
    required this.userId,
  });

  @override
  List<Object?> get props => [userId];
}

class GetInformationUserEvent extends InformationUserEvent {
  final String userId;

  const GetInformationUserEvent({
    required this.userId,
  });

  @override
  List<Object?> get props => [userId];
}
