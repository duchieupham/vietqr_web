import 'dart:io';

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
  final File? image;

  const UserEditAvatarEvent({
    required this.userId,
    required this.imgId,
    required this.image,
  });

  @override
  List<Object?> get props => [userId, imgId, image];
}

class UserDeActiveEvent extends InformationUserEvent {
  final String userId;

  const UserDeActiveEvent({
    required this.userId,
  });

  @override
  List<Object?> get props => [userId];
}
