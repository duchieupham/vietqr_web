import 'package:equatable/equatable.dart';

import '../../login/model/account_login_dto.dart';

class ECOMRegisterEvent extends Equatable {
  const ECOMRegisterEvent();

  @override
  List<Object?> get props => [];
}

class ECOMRegisterEventSubmit extends ECOMRegisterEvent {
  final ECOMAccountLoginDTO dto;

  const ECOMRegisterEventSubmit({required this.dto});

  @override
  List<Object?> get props => [dto];
}
