import 'package:VietQR/commons/constants/configurations/stringify.dart';
import 'package:VietQR/commons/utils/error_utils.dart';
import 'package:VietQR/commons/utils/log.dart';
import 'package:VietQR/features/information_user/events/information_user_event.dart';
import 'package:VietQR/features/information_user/repositories/information_user_repository.dart';
import 'package:VietQR/features/information_user/states/information_user_state.dart';
import 'package:VietQR/models/account_information_dto.dart';
import 'package:VietQR/models/password_update_dto.dart';
import 'package:VietQR/models/response_message_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InformationUserBloc
    extends Bloc<InformationUserEvent, InformationUserState> {
  InformationUserBloc() : super(InformationUserInitialState()) {
    on<InformationUserEditEvent>(_updateUserInformation);
    on<InformationUserEditPassEvent>(_updatePassword);
    on<UserEditAvatarEvent>(_updateAvatar);
    on<UserDeActiveEvent>(_deActiveUser);
    on<GetInformationUserEvent>(_getInformationUser);

  }

  final InformationUserRepository userEditRepository =
      const InformationUserRepository();

  void _updateUserInformation(InformationUserEvent event, Emitter emit) async {
    try {
      if (event is InformationUserEditEvent) {
        emit(InformationUserLoadingState());
        final ResponseMessageDTO dto =
            await userEditRepository.updateUserInformation(event.dto);
        if (dto.status == Stringify.RESPONSE_STATUS_SUCCESS) {
          emit(InformationUserSuccessfulState());
        } else {
          String msg = ErrorUtils.instance.getErrorMessage(dto.message);
          emit(InformationUserFailedState(msg: msg));
        }
      }
    } catch (e) {
      debugPrint('Error at _updateUserInformation - UserEditBloc: $e');
      emit(const InformationUserFailedState(msg: 'Vui lòng thử lại sau'));
    }
  }

  void _updatePassword(InformationUserEvent event, Emitter emit) async {
    try {
      if (event is InformationUserEditPassEvent) {
        emit(InformationUserLoadingState());
        PasswordUpdateDTO dto = PasswordUpdateDTO(
          userId: event.userId,
          oldPassword: event.oldPassword,
          newPassword: event.newPassword,
          phoneNo: event.phoneNo,
        );
        Map<String, dynamic> result =
            await userEditRepository.updatePassword(dto);
        if (result['check']) {
          emit(InformationUserPasswordSuccessfulState());
        } else {
          emit(InformationUserPasswordFailedState(msg: result['msg']));
        }
      }
    } catch (e) {
      debugPrint('Error at _updatePassworc - UserEditBloc: $e');
      emit(const InformationUserPasswordFailedState(
          msg: 'Vui lòng kiểm tra lại kết nối mạng.'));
    }
  }

  void _updateAvatar(InformationUserEvent event, Emitter emit) async {
    try {
      if (event is UserEditAvatarEvent) {
        emit(InformationUserLoadingState());
        final ResponseMessageDTO result = await userEditRepository.updateAvatar(
          event.imgId,
          event.userId,
          event.imageByte,
        );
        if (result.status == Stringify.RESPONSE_STATUS_SUCCESS) {
          emit(InformationUserAvatarSuccessState());
        } else {
          emit(
            InformationUserAvatarFailedState(
              message: ErrorUtils.instance.getErrorMessage(result.message),
            ),
          );
        }
      }
    } catch (e) {
      ResponseMessageDTO responseMessageDTO = const ResponseMessageDTO(
        status: 'FAILED',
        message: 'E05',
      );
      emit(
        InformationUserAvatarFailedState(
          message:
              ErrorUtils.instance.getErrorMessage(responseMessageDTO.message),
        ),
      );
      LOG.error(e.toString());
    }
  }

  void _deActiveUser(InformationUserEvent event, Emitter emit) async {
    try {
      if (event is UserDeActiveEvent) {
        emit(InformationUserLoadingState());
        final ResponseMessageDTO result = await userEditRepository.deActiveUser(
          event.userId,
        );
        if (result.status == Stringify.RESPONSE_STATUS_SUCCESS) {
          emit(UserDeActiveSuccessState());
        } else {
          emit(
            UserDeActiveFailedState(
              message: ErrorUtils.instance.getErrorMessage(result.message),
            ),
          );
        }
      }
    } catch (e) {
      ResponseMessageDTO responseMessageDTO = const ResponseMessageDTO(
        status: 'FAILED',
        message: 'E05',
      );
      emit(
        UserDeActiveFailedState(
          message:
              ErrorUtils.instance.getErrorMessage(responseMessageDTO.message),
        ),
      );
      LOG.error(e.toString());
    }
  }
  void _getInformationUser(InformationUserEvent event, Emitter emit) async {
    try {
      if (event is GetInformationUserEvent) {
        AccountInformationDTO accountInformationDTO =
        await userEditRepository.getUserInformation(
          event.userId,
        );
      }
    } catch (e) {
      ResponseMessageDTO responseMessageDTO = const ResponseMessageDTO(
        status: 'FAILED',
        message: 'E05',
      );

      LOG.error(e.toString());
    }
  }

}

