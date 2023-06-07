import 'package:equatable/equatable.dart';

class ECOMLoginState extends Equatable {
  const ECOMLoginState();

  @override
  List<Object?> get props => [];
}

class ECOMLoginInitialState extends ECOMLoginState {}

class ECOMLoginLoadingState extends ECOMLoginState {}

class ECOMLoginSuccessfulState extends ECOMLoginState {}

class ECOMLoginFailedState extends ECOMLoginState {}
