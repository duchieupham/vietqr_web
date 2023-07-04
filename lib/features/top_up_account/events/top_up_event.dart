import 'package:equatable/equatable.dart';

class TopUpEvent extends Equatable {
  const TopUpEvent();

  @override
  List<Object?> get props => [];
}

class TopUpEventGetInfoAccount extends TopUpEvent {
  final String phoneNumber;

  const TopUpEventGetInfoAccount({
    required this.phoneNumber,
  });

  @override
  List<Object?> get props => [phoneNumber];
}
