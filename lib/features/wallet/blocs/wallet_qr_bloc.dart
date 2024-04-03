import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/commons/utils/log.dart';
import 'package:VietQR/features/wallet/events/wallet_event.dart';
import 'package:VietQR/features/wallet/repostiroties/wallet_repository.dart';
import 'package:VietQR/features/wallet/states/wallet_state.dart';
import 'package:VietQR/models/contact_detail_dto.dart';
import 'package:VietQR/models/contact_dto.dart';
import 'package:VietQR/services/shared_references/user_information_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette_generator/palette_generator.dart';

class WalletBloc extends Bloc<ContactEvent, ContactState> {
  WalletBloc() : super(WalletInitialState()) {
    on<ContactEventGetList>(_getBankAccounts);
    on<SearchContactEvent>(_searchContact);
    on<ContactEventGetDetail>(_getDetailContact);
  }

  ContactRepository contactRepository = ContactRepository();

  void _getBankAccounts(ContactEvent event, Emitter emit) async {
    String userId = UserInformationHelper.instance.getUserId();
    List<ContactDTO> list = [];

    PaletteGenerator? paletteGenerator;
    try {
      if (event is ContactEventGetList) {
        list = await contactRepository.getListSaveContact(
            userId, event.type, event.offset);
        emit(WalletLoadingListState());

        for (ContactDTO dto in list) {
          if (dto.type == 1) {
            dto.setColor(AppColor.BLUE_TEXT);
          } else if (dto.type == 3) {
            dto.setColor(AppColor.GREY_TEXT);
          } else if (dto.type != 4) {
            NetworkImage image = ImageUtils.instance.getImageNetWork(dto.imgId);
            paletteGenerator = await PaletteGenerator.fromImageProvider(image);
            if (paletteGenerator.dominantColor != null) {
              dto.setColor(paletteGenerator.dominantColor!.color);
            } else {
              dto.setColor(AppColor.WHITE);
            }
          }
        }
        list.sort((a, b) {
          return a.nickname.toLowerCase().compareTo(b.nickname.toLowerCase());
        });
        List<List<ContactDTO>> result = await _compareList(list);
        emit(GetListContactSuccessfulState(list: result));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(const GetListContactSuccessfulState(list: []));
    }
  }

  void _searchContact(ContactEvent event, Emitter emit) async {
    String userId = UserInformationHelper.instance.getUserId();
    List<ContactDTO> list = [];
    try {
      if (event is SearchContactEvent) {
        PaletteGenerator? paletteGenerator;
        emit(WalletLoadingListState());

        list = await contactRepository.searchContact(
            event.nickName, userId, event.type, event.offset);

        for (ContactDTO dto in list) {
          if (dto.type == 1) {
            dto.setColor(AppColor.BLUE_TEXT);
          } else if (dto.type == 3) {
            dto.setColor(AppColor.GREY_TEXT);
          } else if (dto.type != 4) {
            NetworkImage image = ImageUtils.instance.getImageNetWork(dto.imgId);
            paletteGenerator = await PaletteGenerator.fromImageProvider(image);
            if (paletteGenerator.dominantColor != null) {
              dto.setColor(paletteGenerator.dominantColor!.color);
            } else {
              dto.setColor(AppColor.WHITE);
            }
          }
        }

        list.sort((a, b) {
          return a.nickname.toLowerCase().compareTo(b.nickname.toLowerCase());
        });

        List<List<ContactDTO>> result = await _compareList(list);
        emit(GetListContactSuccessfulState(list: result));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(const GetListContactSuccessfulState(list: []));
    }
  }

  void _getDetailContact(ContactEvent event, Emitter emit) async {
    ContactDetailDTO contactDetailDTO = ContactDetailDTO();
    try {
      if (event is ContactEventGetDetail) {
        emit(GetDetailContactLoadingState());
        contactDetailDTO = await contactRepository.getContactDetail(event.id);

        emit(GetDetailContactSuccessState(dto: contactDetailDTO));
      }
    } catch (e) {
      LOG.error(e.toString());
      emit(GetDetailContactSuccessState(dto: contactDetailDTO));
    }
  }

  Future<List<List<ContactDTO>>> _compareList(List<ContactDTO> result) async {
    List<List<ContactDTO>> listAll = [];
    List<String> listString = [];

    if (result.isNotEmpty) {
      for (int i = 0; i < result.length; i++) {
        if (result[i].nickname.isNotEmpty) {
          String keyName = result[i].nickname[0].toUpperCase();
          listString.add(keyName);
        } else {
          listString.add('');
        }
      }

      listString = listString.toSet().toList();

      for (int i = 0; i < listString.length; i++) {
        List<ContactDTO> listCompare = [];
        listCompare = result.where((element) {
          if (element.nickname.isNotEmpty) {
            return element.nickname[0].toUpperCase() == listString[i];
          } else {
            return element.nickname.toUpperCase() == listString[i];
          }
        }).toList();

        listAll.add(listCompare);
      }
    }
    return listAll;
  }
}
