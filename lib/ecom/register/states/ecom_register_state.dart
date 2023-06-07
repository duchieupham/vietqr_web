import 'package:equatable/equatable.dart';

class ECOMRegisterState extends Equatable {
  const ECOMRegisterState();

  @override
  List<Object?> get props => [];
}

class ECOMRegisterInitialState extends ECOMRegisterState {}

class ECOMRegisterLoadingState extends ECOMRegisterState {}

class ECOMRegisterSuccessState extends ECOMRegisterState {}

class ECOMRegisterFailedState extends ECOMRegisterState {
  final String msg;

  const ECOMRegisterFailedState({required this.msg});

  @override
  List<Object?> get props => [msg];
}
