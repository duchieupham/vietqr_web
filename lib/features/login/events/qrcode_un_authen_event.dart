import 'package:equatable/equatable.dart';

class QRCodeUnUTEvent extends Equatable {
  const QRCodeUnUTEvent();

  @override
  List<Object?> get props => [];
}

class QRCodeUnUTCreateQR extends QRCodeUnUTEvent {
  final Map<String, dynamic> data;

  const QRCodeUnUTCreateQR({required this.data});

  @override
  List<Object?> get props => [data];
}

class QRVCardCreateQR extends QRCodeUnUTEvent {
  final Map<String, dynamic> data;

  const QRVCardCreateQR({required this.data});

  @override
  List<Object?> get props => [data];
}

class GetTransactionQRBytToken extends QRCodeUnUTEvent {
  final String token;
  final bool isDev;

  const GetTransactionQRBytToken({required this.token, this.isDev = false});

  @override
  List<Object?> get props => [token, isDev];
}

class QRGenerateCancelEvent extends QRCodeUnUTEvent {
  final String token;

  const QRGenerateCancelEvent(this.token);

  @override
  List<Object?> get props => [token];
}
