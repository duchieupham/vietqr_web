import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/commons/widgets/divider_widget.dart';
import 'package:VietQR/features/branch/blocs/branch_bloc.dart';
import 'package:VietQR/features/branch/events/branch_event.dart';
import 'package:VietQR/features/branch/states/branch_state.dart';
import 'package:VietQR/layouts/box_layout.dart';
import 'package:VietQR/models/account_bank_branch_insert_dto.dart';
import 'package:VietQR/models/account_bank_connect_branch_dto.dart';
import 'package:VietQR/services/shared_references/user_information_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectBankConnectBranchWidget extends StatelessWidget {
  final String businessId;
  final String branchId;
  final BranchBloc branchBloc;
  final List<AccountBankConnectBranchDTO> list = [];
  final List<Color> colors = [];

  SelectBankConnectBranchWidget({
    super.key,
    required this.branchBloc,
    required this.branchId,
    required this.businessId,
  });

  void initialServices(BuildContext context) {
    list.clear();
    colors.clear();
    String userId = UserInformationHelper.instance.getUserId();
    branchBloc.add(BranchEventGetConnectBanks(userId: userId));
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    initialServices(context);
    return SizedBox(
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: width,
            height: 50,
            child: Row(
              children: [
                const SizedBox(
                  width: 80,
                  height: 50,
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: const Text(
                      'Kết nối TK ngân hàng',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 80,
                    alignment: Alignment.centerRight,
                    child: const Text(
                      'Xong',
                      style: TextStyle(
                        color: AppColor.GREEN,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          DividerWidget(width: width),
          const Padding(padding: EdgeInsets.only(top: 30)),
          Expanded(
            child: BlocBuilder<BranchBloc, BranchState>(
              builder: (context, state) {
                if (state is BranchGetConnectBankSuccessState) {
                  list.clear();
                  colors.clear();
                  if (list.isEmpty) {
                    list.addAll(state.list);
                    colors.addAll(state.colors);
                  }
                }
                return (list.isEmpty)
                    ? const SizedBox()
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          return _buildCardItem(
                            context: context,
                            index: index,
                            dto: list[index],
                            color: colors[index],
                          );
                        },
                      );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardItem({
    required BuildContext context,
    required int index,
    required AccountBankConnectBranchDTO dto,
    required Color color,
  }) {
    final double width = MediaQuery.of(context).size.width;

    return (dto.bankId.isNotEmpty)
        ? InkWell(
            onTap: () {},
            child: Container(
              width: width,
              height: 150,
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10),
              ),
              child: SizedBox(
                width: width,
                height: 100,
                child: Column(
                  children: [
                    Container(
                      height: 60,
                      width: width,
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 20,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            height: 30,
                            decoration: BoxDecoration(
                              color: AppColor.WHITE,
                              borderRadius: BorderRadius.circular(5),
                              image: DecorationImage(
                                image: ImageUtils.instance.getImageNetWork(
                                  dto.imgId,
                                ),
                              ),
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(left: 10)),
                          Expanded(
                            child: Text(
                              '${dto.bankCode} - ${dto.bankAccount}\n${dto.bankName}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppColor.WHITE,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 20)),
                    SizedBox(
                      width: width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Padding(padding: EdgeInsets.only(left: 20)),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  dto.bankAccountName.toUpperCase(),
                                  style: const TextStyle(
                                    color: AppColor.WHITE,
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  (dto.authenticated)
                                      ? 'Trạng thái: Đã liên kết'
                                      : 'Trạng thái: Chưa liên kết',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: AppColor.WHITE,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              String userId =
                                  UserInformationHelper.instance.getUserId();
                              AccountBankBranchInsertDTO
                                  accountBankBranchInsertDTO =
                                  AccountBankBranchInsertDTO(
                                userId: userId,
                                bankId: dto.bankId,
                                businessId: businessId,
                                branchId: branchId,
                              );
                              branchBloc.add(BranchEventConnectBank(
                                  dto: accountBankBranchInsertDTO));
                              Navigator.pop(context);
                            },
                            child: BoxLayout(
                              width: 100,
                              borderRadius: 5,
                              alignment: Alignment.center,
                              bgColor:
                                  Theme.of(context).cardColor.withOpacity(0.3),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text(
                                    'Chọn',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColor.WHITE,
                                    ),
                                  ),
                                  Icon(
                                    Icons.navigate_next_rounded,
                                    color: AppColor.WHITE,
                                    size: 15,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(left: 20)),
                        ],
                      ),
                    ),
                    const Padding(padding: EdgeInsets.only(bottom: 20)),
                  ],
                ),
              ),
            ),
          )
        : const SizedBox();
  }
}
