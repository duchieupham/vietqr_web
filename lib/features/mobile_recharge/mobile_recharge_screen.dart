import 'package:VietQR/commons/constants/configurations/app_image.dart';
import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/enums/event_type.dart';
import 'package:VietQR/commons/utils/currency_utils.dart';
import 'package:VietQR/commons/utils/error_utils.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/commons/utils/string_utils.dart';
import 'package:VietQR/commons/widgets/dialog_widget.dart';
import 'package:VietQR/commons/widgets/divider_widget.dart';
import 'package:VietQR/features/mobile_recharge/blocs/mobile_recharge_bloc.dart';
import 'package:VietQR/features/mobile_recharge/frame/mobile_recharge_frame.dart';
import 'package:VietQR/features/mobile_recharge/provider/contact_provider.dart';
import 'package:VietQR/features/mobile_recharge/provider/mobile_recharge_provider.dart';
import 'package:VietQR/features/mobile_recharge/qr_mobile_recharge.dart';
import 'package:VietQR/features/mobile_recharge/states/mobile_recharge_state.dart';
import 'package:VietQR/features/mobile_recharge/widget/bottom_sheet_search_user.dart';
import 'package:VietQR/features/mobile_recharge/widget/list_network_providers.dart';
import 'package:VietQR/features/mobile_recharge/widget/pop_up_confirm_pass.dart';
import 'package:VietQR/features/mobile_recharge/widget/recharege_success.dart';
import 'package:VietQR/models/account_information_dto.dart';
import 'package:VietQR/models/network_providers_dto.dart';
import 'package:VietQR/models/respone_top_up_dto.dart';
import 'package:VietQR/services/shared_references/session.dart';
import 'package:VietQR/services/shared_references/user_information_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'events/mobile_recharge_event.dart';

// ignore: must_be_immutable
class MobileRechargeScreen extends StatelessWidget {
  MobileRechargeScreen({super.key});

  late FocusNode myFocusNode = FocusNode();
  TypeMobileRecharge typeMobileRecharge = TypeMobileRecharge.OTHER;
  ResponseTopUpDTO responseTopUpDTO = const ResponseTopUpDTO();
  String getIdImage(List<NetworkProviders> list) {
    String imgId = '';
    AccountInformationDTO accountInformationDTO =
        UserInformationHelper.instance.getAccountInformation();
    for (var element in list) {
      if (accountInformationDTO.carrierTypeId == element.id) {
        imgId = element.imgId;
        return imgId;
      }
    }
    return imgId;
  }

  updateMobileCarrierType(BuildContext context) {
    Map<String, dynamic> param = {};

    param['userId'] = UserInformationHelper.instance.getUserId();
    param['carrierTypeId'] =
        Provider.of<MobileRechargeProvider>(context, listen: false)
            .networkProviders
            .id;
    BlocProvider.of<MobileRechargeBloc>(context)
        .add(MobileRechargeUpdateType(data: param));
  }

  updateInformationUser(BuildContext context) {
    AccountInformationDTO accountInformationDTO =
        UserInformationHelper.instance.getAccountInformation();
    AccountInformationDTO accountInformationDTONew = AccountInformationDTO(
        userId: accountInformationDTO.userId,
        firstName: accountInformationDTO.firstName,
        middleName: accountInformationDTO.middleName,
        lastName: accountInformationDTO.lastName,
        birthDate: accountInformationDTO.birthDate,
        gender: accountInformationDTO.gender,
        address: accountInformationDTO.address,
        email: accountInformationDTO.email,
        imgId: accountInformationDTO.imgId,
        nationalDate: accountInformationDTO.nationalDate,
        nationalId: accountInformationDTO.nationalId,
        oldNationalId: accountInformationDTO.oldNationalId,
        carrierTypeId:
            Provider.of<MobileRechargeProvider>(context, listen: false)
                .networkProviders
                .id,
        phoneNo: accountInformationDTO.phoneNo);
    UserInformationHelper.instance
        .setAccountInformation(accountInformationDTONew);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MobileRechargeProvider>(
      create: (context) => MobileRechargeProvider(),
      child: BlocProvider<MobileRechargeBloc>(
        create: (context) =>
            MobileRechargeBloc()..add(MobileRechargeGetListType()),
        child: BlocConsumer<MobileRechargeBloc, MobileRechargeState>(
          listener: (context, state) {
            if (state is RechargeUpdateTypeUpdateSuccessState) {
              updateInformationUser(context);
            }
            if (state is MobileRechargeMobileMoneySuccessState) {
              if (UserInformationHelper.instance.getPhoneNo() ==
                  Provider.of<MobileRechargeProvider>(context, listen: false)
                      .phoneNo) {
                updateMobileCarrierType(context);
              }

              Navigator.pop(context);
              if (Provider.of<MobileRechargeProvider>(context, listen: false)
                      .paymentTypeMethod ==
                  1) {
                List<String> listParam = state.dto.message.split('*');

                responseTopUpDTO = ResponseTopUpDTO(
                    imgId: listParam[1],
                    content: listParam[0],
                    qrCode: listParam[2],
                    amount: Provider.of<MobileRechargeProvider>(context,
                            listen: false)
                        .money);
                typeMobileRecharge = TypeMobileRecharge.QR;
              } else {
                typeMobileRecharge = TypeMobileRecharge.SUCCESS;
              }
            }
            if (state is MobileRechargeMobileMoneyLoadingState) {
              DialogWidget.instance
                  .openLoadingDialog(msg: 'Đang thực hiện thanh toán');
            }

            if (state is MobileRechargeMobileMoneyFailedState) {
              Navigator.pop(context);
              DialogWidget.instance.openMsgDialog(
                  title: 'Nạp tiền thất bại',
                  msg: ErrorUtils.instance.getErrorMessage(state.dto.message));
            }
            if (state is MobileRechargeGetListTypeSuccessState) {
              Provider.of<MobileRechargeProvider>(context, listen: false)
                  .init(state.list);
            }
          },
          builder: (context, state) {
            if (typeMobileRecharge == TypeMobileRecharge.QR) {
              return QRMobileRechargeScreen(
                dto: responseTopUpDTO,
                phoneNo:
                    Provider.of<MobileRechargeProvider>(context, listen: false)
                        .phoneNo,
                nwProviders:
                    Provider.of<MobileRechargeProvider>(context, listen: false)
                        .networkProviders
                        .name,
              );
            } else if (typeMobileRecharge == TypeMobileRecharge.SUCCESS) {
              return RechargeSuccess(
                money:
                    Provider.of<MobileRechargeProvider>(context, listen: false)
                        .money,
                phoneNo:
                    Provider.of<MobileRechargeProvider>(context, listen: false)
                        .phoneNo,
              );
            }

            return MobileRechargeFrame(
              widget1: _buildTemplateSection('Phương thức thanh toán',
                  child: _buildPaymentMethods()),
              widget2: Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        _buildTemplateSection(
                          'Số điện thoại',
                          child: _buildPhoneNumber(context, state,
                              accountInformationDTO: UserInformationHelper
                                  .instance
                                  .getAccountInformation(),
                              phoneNumber:
                                  UserInformationHelper.instance.getPhoneNo()),
                        ),
                        const SizedBox(
                          height: 28,
                        ),
                        _buildTemplateSection('Mệnh giá', child: _buildTopUp()),
                      ],
                    ),
                  ),
                  Consumer<MobileRechargeProvider>(
                    builder: (context, provider, child) {
                      return Container(
                        padding:
                            const EdgeInsets.fromLTRB(0, 16, 0, kToolbarHeight),
                        color: AppColor.WHITE,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Text(
                                    'Số dư tài khoản VietQR: ',
                                    style: TextStyle(fontSize: 10),
                                  ),
                                  Text(
                                    '${CurrencyUtils.instance.getCurrencyFormatted(Session.instance.wallet.amount)} VQR',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const Spacer(),
                                ],
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: DividerWidget(
                                width: double.infinity,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Tổng tiền cần thanh toán:',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        Text(
                                          '${provider.money} ${provider.paymentTypeMethod == 1 ? 'VND' : 'VQR'}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                      if (int.parse(Session
                                                  .instance.wallet.amount) >=
                                              int.parse(provider.money
                                                  .replaceAll(',', '')) ||
                                          provider.paymentTypeMethod == 1) {
                                        DialogWidget.instance.openWidgetDialog(
                                          width: 300,
                                          height: 300,
                                          child: PopupConfirmPassword(
                                            onConfirmSuccess: (otp) {
                                              Navigator.of(context).pop();
                                              Map<String, dynamic> data = {};
                                              data['phoneNo'] =
                                                  provider.phoneNo.isNotEmpty
                                                      ? provider.phoneNo
                                                      : UserInformationHelper
                                                          .instance
                                                          .getPhoneNo();
                                              data['userId'] =
                                                  UserInformationHelper.instance
                                                      .getUserId();
                                              data['rechargeType'] =
                                                  provider.rechargeType;
                                              data['otp'] = otp;
                                              data['carrierTypeId'] =
                                                  provider.networkProviders.id;
                                              data['paymentMethod'] =
                                                  provider.paymentTypeMethod;
                                              BlocProvider.of<
                                                          MobileRechargeBloc>(
                                                      context)
                                                  .add(
                                                      MobileRechargeMobileMoney(
                                                          data: data));
                                            },
                                          ),
                                        );
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 28, vertical: 10),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: int.parse(Session.instance
                                                          .wallet.amount) <
                                                      int.parse(provider.money
                                                          .replaceAll(
                                                              ',', '')) &&
                                                  provider.paymentTypeMethod ==
                                                      0
                                              ? AppColor.GREY_BUTTON
                                              : AppColor.BLUE_TEXT),
                                      child: Text(
                                        'Thanh toán',
                                        style: TextStyle(
                                            color: int.parse(Session.instance
                                                            .wallet.amount) <
                                                        int.parse(provider.money
                                                            .replaceAll(
                                                                ',', '')) &&
                                                    provider.paymentTypeMethod ==
                                                        0
                                                ? AppColor.BLACK
                                                : AppColor.WHITE),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPhoneNumber(BuildContext context, MobileRechargeState state,
      {required AccountInformationDTO accountInformationDTO,
      required String phoneNumber}) {
    double height = MediaQuery.of(context).size.height;
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 8, 20, 12),
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(8)),
      child: Column(
        children: [
          Consumer<MobileRechargeProvider>(builder: (context, provider, child) {
            String imgId = provider.networkProviders.imgId;
            return Row(
              children: [
                if (state is MobileRechargeLoadingState)
                  Container(
                    width: 45,
                    height: 45,
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                          width: 0.5,
                          color: AppColor.GREY_TEXT.withOpacity(0.3)),
                    ),
                    child: const CircularProgressIndicator(),
                  )
                else if (imgId.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      DialogWidget.instance.showModalBottomContent(
                        context: context,
                        widget: ListNetWorkProvider(
                          list: provider.listNetworkProviders,
                          onTap: (networkProviders) {
                            provider.updateNetworkProviders(networkProviders);
                          },
                        ),
                        height: height * 0.6,
                      );
                    },
                    child: Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                            width: 0.5,
                            color: AppColor.GREY_TEXT.withOpacity(0.3)),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: provider.networkProviders.imgId.isNotEmpty
                              ? ImageUtils.instance.getImageNetWork(
                                  provider.networkProviders.imgId)
                              : ImageUtils.instance.getImageNetWork(imgId),
                        ),
                      ),
                    ),
                  )
                else
                  _buildBlankLogo(
                      context, provider.listNetworkProviders, provider),
                const Padding(padding: EdgeInsets.only(left: 10)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            provider.phoneNo.isNotEmpty
                                ? provider.phoneNo
                                : StringUtils.instance
                                    .formatPhoneNumberVN(phoneNumber),
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                          // SizedBox(
                          //   width: 94,
                          //   height: 22,
                          //   child: TextField(
                          //     controller:
                          //         TextEditingController(text: phoneNumber),
                          //     readOnly: true,
                          //     focusNode: myFocusNode,
                          //     style: const TextStyle(
                          //         fontWeight: FontWeight.w600, fontSize: 16),
                          //     decoration: const InputDecoration(
                          //         contentPadding: EdgeInsets.zero),
                          //   ),
                          // ),
                        ],
                      ),
                      Text(
                        provider.nameUser.isNotEmpty
                            ? provider.nameUser
                            : '${accountInformationDTO.lastName} ${accountInformationDTO.middleName} ${accountInformationDTO.firstName}'
                                .trim(),
                        style: const TextStyle(
                            fontSize: 10, color: AppColor.GREY_TEXT),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    DialogWidget.instance.openWidgetDialog(
                      child: ChangeNotifierProvider<ContactProvider>(
                        create: (context) => ContactProvider(),
                        child: BottomSheetSearchUser(
                          chooseContact: (dto) {
                            Provider.of<MobileRechargeProvider>(context,
                                    listen: false)
                                .updateInfoUser(dto);
                          },
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                        color: AppColor.GREY_BUTTON,
                        borderRadius: BorderRadius.circular(20)),
                    child: const Icon(
                      Icons.edit_note,
                      size: 16,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 5),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTopUp() {
    return Consumer<MobileRechargeProvider>(
      builder: (context, provider, child) {
        return _buildSuggestMoney(provider);
      },
    );
  }

  Widget _buildSuggestMoney(MobileRechargeProvider provider) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: _buildItemSuggest(
                onChange: (value) {
                  provider.updateMoney(value);
                  provider.updateRechargeType(1);
                },
                text: '10,000',
                money: provider.money,
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: _buildItemSuggest(
                onChange: (value) {
                  provider.updateMoney(value);
                  provider.updateRechargeType(2);
                },
                text: '20,000',
                money: provider.money,
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: _buildItemSuggest(
                onChange: (value) {
                  provider.updateMoney(value);
                  provider.updateRechargeType(3);
                },
                text: '50,000',
                money: provider.money,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 12,
        ),
        Row(
          children: [
            Expanded(
              child: _buildItemSuggest(
                onChange: (value) {
                  provider.updateMoney(value);
                  provider.updateRechargeType(4);
                },
                text: '100,000',
                money: provider.money,
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: _buildItemSuggest(
                onChange: (value) {
                  provider.updateMoney(value);
                  provider.updateRechargeType(5);
                },
                text: '200,000',
                money: provider.money,
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: _buildItemSuggest(
                onChange: (value) {
                  provider.updateMoney(value);
                  provider.updateRechargeType(6);
                },
                text: '500,000',
                money: provider.money,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildItemSuggest({
    ValueChanged<String>? onChange,
    required String text,
    required String money,
  }) {
    return GestureDetector(
      onTap: () {
        onChange!(text);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: text == money
              ? Border.all(color: AppColor.BLUE_TEXT, width: 0.8)
              : Border.all(color: AppColor.WHITE, width: 0.8),
          color: text == money
              ? AppColor.BLUE_TEXT.withOpacity(0.3)
              : AppColor.WHITE,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: TextStyle(
                  fontWeight: text == money ? FontWeight.w600 : FontWeight.w400,
                  height: 1.4,
                  color: text == money ? AppColor.BLUE_TEXT : AppColor.BLACK),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTemplateSection(String title, {required Widget child}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        const SizedBox(
          height: 8,
        ),
        child,
      ],
    );
  }

  Widget _buildBlankLogo(BuildContext context, List<NetworkProviders> list,
      MobileRechargeProvider provider) {
    double height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        DialogWidget.instance.showModalBottomContent(
          context: context,
          widget: ListNetWorkProvider(
            list: list,
            onTap: (networkProviders) {
              provider.updateNetworkProviders(networkProviders);
            },
          ),
          height: height * 0.6,
        );
      },
      child: Container(
        height: 45,
        width: 45,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
              width: 0.5, color: AppColor.GREY_TEXT.withOpacity(0.3)),
          image: provider.networkProviders.imgId.isNotEmpty
              ? DecorationImage(
                  fit: BoxFit.cover,
                  image: ImageUtils.instance
                      .getImageNetWork(provider.networkProviders.imgId),
                )
              : null,
        ),
        child: provider.networkProviders.imgId.isEmpty
            ? const Text(
                'Chọn nhà\nmạng',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10),
              )
            : const SizedBox.shrink(),
      ),
    );
  }

  Widget _buildPaymentMethods() {
    return Consumer<MobileRechargeProvider>(
        builder: (context, provider, child) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              provider.updatePaymentMethod(1);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: AppColor.WHITE,
                border: Border.all(
                    color: provider.paymentTypeMethod == 1
                        ? AppColor.BLUE_TEXT
                        : AppColor.WHITE,
                    width: 0.5),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Image(
                      image: ImageUtils.instance
                          .getImageNetWork(AppImages.logoVietqrVn),
                      height: 20,
                    ),
                  ),
                  Expanded(
                      flex: 4,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Mã VietQR VN',
                            style: TextStyle(fontSize: 15),
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Text(
                            'Quét mã VietQR để thực hiện thanh toán',
                            style: TextStyle(
                                fontSize: 12, color: AppColor.GREY_TEXT),
                          ),
                        ],
                      )),
                  Container(
                    height: 10,
                    width: 10,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: provider.paymentTypeMethod == 1
                            ? AppColor.BLUE_TEXT
                            : AppColor.WHITE,
                        borderRadius: BorderRadius.circular(20)),
                    child: Container(
                      height: 5,
                      width: 5,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: AppColor.WHITE,
                          borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // const SizedBox(
          //   height: 12,
          // ),
          // GestureDetector(
          //   onTap: () {
          //     provider.updatePaymentMethod(0);
          //   },
          //   child: Container(
          //     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(5),
          //       color: AppColor.WHITE,
          //       border: Border.all(
          //           color: provider.paymentTypeMethod == 0
          //               ? AppColor.BLUE_TEXT
          //               : AppColor.WHITE,
          //           width: 0.5),
          //     ),
          //     child: Row(
          //       children: [
          //         Expanded(
          //           child: Image.asset(
          //             'assets/images/logo-vqr-unit.png',
          //             height: 20,
          //           ),
          //         ),
          //         Expanded(
          //             flex: 4,
          //             child: Column(
          //               mainAxisSize: MainAxisSize.min,
          //               crossAxisAlignment: CrossAxisAlignment.start,
          //               children: const [
          //                 Text(
          //                   'VQR',
          //                   style: TextStyle(fontSize: 15),
          //                 ),
          //                 SizedBox(
          //                   height: 2,
          //                 ),
          //                 Text(
          //                   'Thanh toán bằng tiền dịch vụ VQR',
          //                   style: TextStyle(
          //                       fontSize: 12, color: AppColor.GREY_TEXT),
          //                 ),
          //               ],
          //             )),
          //         Container(
          //           height: 10,
          //           width: 10,
          //           alignment: Alignment.center,
          //           decoration: BoxDecoration(
          //               color: provider.paymentTypeMethod == 0
          //                   ? AppColor.BLUE_TEXT
          //                   : AppColor.WHITE,
          //               borderRadius: BorderRadius.circular(20)),
          //           child: Container(
          //             height: 5,
          //             width: 5,
          //             alignment: Alignment.center,
          //             decoration: BoxDecoration(
          //                 color: AppColor.WHITE,
          //                 borderRadius: BorderRadius.circular(20)),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      );
    });
  }
}
