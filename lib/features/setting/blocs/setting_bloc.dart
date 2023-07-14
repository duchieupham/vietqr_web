import 'package:VietQR/commons/constants/configurations/stringify.dart';
import 'package:VietQR/commons/utils/log.dart';
import 'package:VietQR/features/setting/events/setting_event.dart';
import 'package:VietQR/features/setting/repositories/setting_repository.dart';
import 'package:VietQR/features/setting/states/setting_state.dart';
import 'package:VietQR/services/shared_references/user_information_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  SettingBloc() : super(SettingInitialState()) {
    on<SettingGetTokenPlusEvent>(_requestTokenPlus);
  }
}

const SettingRepository _settingRepository = SettingRepository();

void _requestTokenPlus(SettingEvent event, Emitter emit) async {
  try {
    if (event is SettingGetTokenPlusEvent) {
      Map<String, String> data = {};
      data['userId'] =
          UserInformationHelper.instance.getAccountInformation().userId;
      data['phoneNo'] =
          UserInformationHelper.instance.getAccountInformation().phoneNo;
      data['hosting'] = event.hosting;
      emit(SettingLoadingState());
      var result = await _settingRepository.requestTokenPlus(data);
      if (result.isNotEmpty) {
        emit(SettingGetTokenPlusSuccessState(tokenPlus: result));
      } else {
        emit(SettingGetTokenPlusFailedState());
      }
    }
  } catch (e) {
    LOG.error(e.toString());
    emit(SettingGetTokenPlusFailedState());
  }
}
