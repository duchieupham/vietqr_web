import 'package:VietQR/ecom/login/model/account_login_dto.dart';
import 'package:equatable/equatable.dart';

class ECOMLoginEvent extends Equatable {
  const ECOMLoginEvent();

  @override
  List<Object?> get props => [];
}

class ECOMLoginEventByPhone extends ECOMLoginEvent {
  final ECOMAccountLoginDTO dto;
  const ECOMLoginEventByPhone({required this.dto});

  @override
  List<Object?> get props => [dto];
}
