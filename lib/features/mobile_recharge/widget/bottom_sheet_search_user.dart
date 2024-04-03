import 'package:VietQR/commons/constants/configurations/app_image.dart';
import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/enums/event_type.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/commons/widgets/textfield_widget.dart';
import 'package:VietQR/features/mobile_recharge/blocs/contact_bloc.dart';
import 'package:VietQR/features/mobile_recharge/events/contact_event.dart';
import 'package:VietQR/features/mobile_recharge/provider/contact_provider.dart';
import 'package:VietQR/features/mobile_recharge/states/contact_state.dart';
import 'package:VietQR/models/contact_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class BottomSheetSearchUser extends StatelessWidget {
  final Function(ContactDTO) chooseContact;

  const BottomSheetSearchUser({Key? key, required this.chooseContact})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ContactBloc _bloc = ContactBloc(context)
      ..add(ContactEventGetListRecharge());
    return ChangeNotifierProvider<ContactProvider>(
      create: (context) => ContactProvider(),
      child: BlocProvider<ContactBloc>(
        create: (context) => _bloc,
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                const Spacer(),
                const SizedBox(
                  width: 32,
                ),
                const Text(
                  'Nạp tiền điện thoại',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.clear,
                    size: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: AppColor.BLACK_BUTTON.withOpacity(0.05)),
              child: TextFieldWidget(
                isObscureText: false,
                maxLines: 1,
                fillColor: AppColor.GREY_BUTTON,
                // controller: searchController,
                hintText: 'Tìm kiếm số điện thoại',
                inputType: TextInputType.number,
                prefixIcon: const Icon(Icons.search),
                keyboardAction: TextInputAction.done,
                onChange: (value) {
                  Provider.of<ContactProvider>(context, listen: false)
                      .updatePhoneNo(value.toString());
                  if (value.toString().length >= 5) {
                    _bloc.add(SearchUser(value.toString()));
                  } else if (value.toString().isEmpty) {
                    _bloc.add(ContactEventGetListRecharge());
                  } else {
                    List<ContactDTO> list = [];
                    Provider.of<ContactProvider>(context, listen: false)
                        .updateList(list);
                  }
                },
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Expanded(
                child: BlocConsumer<ContactBloc, ContactState>(
              listener: (context, state) {
                if (state.type == ContactType.GET_LIST_RECHARGE) {
                  if (state.listContactDTO.isNotEmpty) {
                    Provider.of<ContactProvider>(context, listen: false)
                        .updateList(state.listContactDTO);
                  }
                }

                if (state.type == ContactType.SEARCH_USER) {
                  Provider.of<ContactProvider>(context, listen: false)
                      .updateList(state.listContactDTO);
                }
              },
              builder: (context, state) {
                return Consumer<ContactProvider>(
                    builder: (context, provider, child) {
                  if (provider.listSearch.isEmpty) {
                    ContactDTO dto = ContactDTO(
                      id: '',
                      nickname: 'Không xác định',
                      status: 0,
                      type: 0,
                      imgId: '',
                      description: '',
                      phoneNo: provider.phoneNo,
                      carrierTypeId: '',
                      relation: 0,
                    );
                    if (provider.phoneNo.isNotEmpty) {
                      return _buildItemSave(context, dto: dto);
                    } else {
                      return const SizedBox.shrink();
                    }
                  }
                  return ListView.separated(
                    itemCount: provider.listSearch.length,
                    separatorBuilder: (context, index) {
                      if (index == provider.listSearch.length - 1) {
                        return const SizedBox.shrink();
                      }
                      String firstLetterA =
                          (provider.listSearch[index].nickname)[0];
                      String firstLetterB =
                          (provider.listSearch[index + 1].nickname)[0];
                      if (firstLetterA != firstLetterB) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 4, left: 24),
                          child: Text(
                            firstLetterB,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 4, left: 24),
                              child: Text(
                                  (provider.listSearch[index].nickname)[0],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                            ),
                            _buildItemSave(context,
                                dto: provider.listSearch[index]),
                          ],
                        );
                      }
                      return _buildItemSave(context,
                          dto: provider.listSearch[index]);
                    },
                  );
                });
              },
            ))
          ],
        ),
      ),
    );
  }

  Widget _buildItemSave(BuildContext context, {required ContactDTO? dto}) {
    return GestureDetector(
      onTap: () async {
        chooseContact(dto!);
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppColor.WHITE,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 35,
              height: 35,
              margin: const EdgeInsets.only(top: 2),
              decoration: BoxDecoration(
                color: AppColor.WHITE,
                borderRadius: BorderRadius.circular(40),
                border: Border.all(color: AppColor.GREY_LIGHT.withOpacity(0.3)),
                image: DecorationImage(
                    image: ImageUtils.instance.getImageNetWork(
                        dto!.imgId.isNotEmpty
                            ? dto.imgId
                            : AppImages.avtVietqr),
                    fit: BoxFit.cover),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dto?.nickname ?? '',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColor.BLACK,
                      height: 1.4,
                    ),
                  ),
                  Text(
                    dto?.phoneNo ?? '',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
