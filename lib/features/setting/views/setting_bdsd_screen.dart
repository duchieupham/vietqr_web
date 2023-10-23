import 'package:VietQR/services/shared_references/user_information_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../commons/constants/configurations/theme.dart';
import '../../../services/providers/setting_provider.dart';
import '../blocs/setting_bloc.dart';
import '../events/setting_event.dart';

class SettingBDSD extends StatelessWidget {
  const SettingBDSD({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingProvider>(
      builder: (context, provider, child) {
        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          children: [
            const SizedBox(
              height: 48,
            ),
            const Text(
              'Cài đặt giọng nói',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            _buildBgItem(
              customPadding: EdgeInsets.zero,
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Giọng nói được kích hoạt khi nhận thông báo Biến động số dư trong ứng dụng VietQR',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    provider.enableVoice ? 'Bật' : 'Tắt',
                    style: const TextStyle(
                        fontSize: 12, color: AppColor.GREY_TEXT),
                  ),
                  Switch(
                    value: provider.enableVoice,
                    activeColor: AppColor.BLUE_TEXT,
                    onChanged: (bool value) {
                      provider.updateOpenVoice(value);
                      Map<String, dynamic> param = {};
                      param['userId'] =
                          UserInformationHelper.instance.getUserId();
                      param['value'] = value ? 1 : 0;
                      param['type'] = 0;
                      BlocProvider.of<SettingBloc>(context)
                          .add(UpdateVoiceSetting(param: param));
                    },
                  ),
                ],
              ),
            ),
            _buildBgNote(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    '- Giọng nói thông báo biến động số dư hoạt động khi bạn đang sử dụng ứng dụng.',
                    style: TextStyle(fontSize: 11),
                  ),
                  Text(
                    '- Các trường hợp chạy nền, tắt ứng dụng thì giọng nói sẽ không hoạt động.',
                    style: TextStyle(fontSize: 11),
                  ),
                  Text(
                    '- Âm lượng thiết bị của bạn phải luôn bật.',
                    style: TextStyle(fontSize: 11),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            // Text(
            //   'Danh sách tài khoản nhận biến động số dư',
            //   style: TextStyle(fontWeight: FontWeight.bold),
            // ),
            // _buildListBank(context, provider),
            // _buildBgNote(
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     mainAxisSize: MainAxisSize.min,
            //     children: [
            //       Text(
            //         '- Biến động số dư được bật khi bạn cho phép tính năng này hoạt động.',
            //         style: TextStyle(fontSize: 11),
            //       ),
            //       const SizedBox(
            //         height: 8,
            //       ),
            //       Text(
            //         '- Danh sách tài khoản ngân hàng khả dụng để nhận biến động số dư là các tài khoản ngân hàng đã được liên kết với hệ thống VietQR VN.',
            //         style: TextStyle(fontSize: 11),
            //       ),
            //     ],
            //   ),
            // ),
            // const SizedBox(
            //   height: 40,
            // ),
          ],
        );
      },
    );
  }

  // Widget _buildListBank(BuildContext context, SettingBDSDProvider provider) {
  //   return BlocProvider<BankBloc>(
  //       create: (context) => BankBloc(context)..add(BankCardEventGetList()),
  //       child: BlocConsumer<BankBloc, BankState>(
  //         listener: (context, state) {},
  //         builder: (context, state) {
  //           List<BankAccountDTO> listBank =
  //               state.listBanks.where((dto) => dto.isAuthenticated).toList();
  //           return Column(
  //             children: listBank.map((bank) {
  //               return Container(
  //                 height: 60,
  //                 margin: EdgeInsets.only(top: 12),
  //                 padding: EdgeInsets.symmetric(horizontal: 20),
  //                 alignment: Alignment.center,
  //                 decoration: BoxDecoration(
  //                     borderRadius: BorderRadius.circular(8),
  //                     color: AppColor.WHITE),
  //                 child: Row(
  //                   children: [
  //                     Container(
  //                       width: 35,
  //                       height: 35,
  //                       decoration: BoxDecoration(
  //                         color: AppColor.WHITE,
  //                         borderRadius: BorderRadius.circular(40),
  //                         border:
  //                             Border.all(width: 0.5, color: AppColor.GREY_TEXT),
  //                         image: DecorationImage(
  //                           image: ImageUtils.instance.getImageNetWork(
  //                             bank.imgId,
  //                           ),
  //                         ),
  //                       ),
  //                     ),
  //                     const Padding(padding: EdgeInsets.only(left: 10)),
  //                     Column(
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Text(
  //                           '${bank.bankCode} - ${bank.bankAccount}',
  //                           overflow: TextOverflow.ellipsis,
  //                           style: const TextStyle(
  //                               color: AppColor.BLACK,
  //                               fontWeight: FontWeight.w600),
  //                         ),
  //                         Text(
  //                           bank.userBankName.toUpperCase(),
  //                           maxLines: 1,
  //                           overflow: TextOverflow.ellipsis,
  //                           style: const TextStyle(
  //                             color: AppColor.BLACK,
  //                             fontSize: 10,
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                     const Spacer(),
  //                     Text(
  //                       provider.bankIds.contains(bank.id) ? 'Bật' : 'Tắt',
  //                       style:
  //                           TextStyle(fontSize: 12, color: AppColor.GREY_TEXT),
  //                     ),
  //                     Switch(
  //                       value: provider.bankIds.contains(bank.id),
  //                       activeColor: AppColor.BLUE_TEXT,
  //                       onChanged: (bool value) {
  //                         provider.updateListBank(bank.id);
  //                       },
  //                     ),
  //                   ],
  //                 ),
  //               );
  //             }).toList(),
  //           );
  //         },
  //       ));
  // }

  Widget _buildBgItem({required Widget child, EdgeInsets? customPadding}) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(top: 12),
      padding: customPadding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), color: AppColor.WHITE),
      child: child,
    );
  }

  Widget _buildBgNote({required Widget child}) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppColor.BLUE_TEXT.withOpacity(0.2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: const [
              Icon(
                Icons.info_outline,
                color: AppColor.BLUE_TEXT,
                size: 16,
              ),
              SizedBox(width: 4),
              Expanded(
                child: Text(
                  'Lưu ý:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColor.BLUE_TEXT,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 12,
          ),
          child,
        ],
      ),
    );
  }
}
