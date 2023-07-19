import 'package:equatable/equatable.dart';

class SettingEvent extends Equatable {
  const SettingEvent();

  @override
  List<Object?> get props => [];
}

class SettingGetTokenPlusEvent extends SettingEvent {
  final String hosting;

  const SettingGetTokenPlusEvent({required this.hosting});

  @override
  List<Object?> get props => [hosting];
}

class SettingGetListBankOfMeEvent extends SettingEvent {}