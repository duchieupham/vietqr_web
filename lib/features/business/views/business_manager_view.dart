import 'package:VietQR/commons/constants/configurations/route.dart';
import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/enums/type_menu_home.dart';
import 'package:VietQR/commons/widgets/dialog_widget.dart';
import 'package:VietQR/features/business/blocs/business_information_bloc.dart';
import 'package:VietQR/features/business/events/business_information_event.dart';
import 'package:VietQR/features/business/frame/user_information_frame.dart';
import 'package:VietQR/features/business/states/business_information_state.dart';
import 'package:VietQR/features/business/views/add_business_view.dart';
import 'package:VietQR/features/business/views/business_information_view.dart';
import 'package:VietQR/features/business/widget/business_item.dart';
import 'package:VietQR/features/business/widget/shortcut_icon.dart';
import 'package:VietQR/services/shared_references/user_information_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../home/widget/menu_left.dart';

class BusinessManagerView extends StatefulWidget {
  const BusinessManagerView({
    Key? key,
  }) : super(key: key);

  @override
  State<BusinessManagerView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<BusinessManagerView> {
  late BusinessInformationBloc businessInformationBloc;

  initialServices(BuildContext context) {
    businessInformationBloc = BlocProvider.of(context);
  }

  Future<void> _refresh() async {
    String userId = UserInformationHelper.instance.getUserId();
    businessInformationBloc
        .add(BusinessInformationEventGetList(userId: userId));
  }

  @override
  void initState() {
    super.initState();
    initialServices(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      String userId = UserInformationHelper.instance.getUserId();
      businessInformationBloc
          .add(BusinessInformationEventGetList(userId: userId));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BusinessInformationFrame(
      widget1: [_buildListShortcut()],
      widget2: [_buildBusinessWidget()], menu:const MenuLeft(
      currentType:  MenuHomeType.BUSINESS,
    ),
    );
  }

  Widget _buildBusinessWidget() {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return BlocConsumer<BusinessInformationBloc, BusinessInformationState>(
      listener: (context, state) {
        if (state is BusinessInformationInsertSuccessfulState) {
          String userId = UserInformationHelper.instance.getUserId();
          businessInformationBloc
              .add(BusinessInformationEventGetList(userId: userId));
        }
      },
      builder: (context, state) {
        if (state is BusinessLoadingListState) {
          return SizedBox(
            width: width,
            height: 200,
            child: const Center(
              child: CircularProgressIndicator(
                color: DefaultTheme.GREEN,
              ),
            ),
          );
        }
        if (state is BusinessGetListSuccessfulState) {
          if (state.list.isEmpty) {
            return SizedBox(
              width: width,
              height: 200,
            );
          } else {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 5,
                        height: 20,
                        color: DefaultTheme.GREEN,
                      ),
                      const Padding(padding: EdgeInsets.only(left: 10)),
                      const Text(
                        'Doanh nghiệp',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.list.length,
                  itemBuilder: (context, index) {
                    return BusinessItem(
                      dto: state.list[index],
                      businessInfo: () {
                        DialogWidget.instance.openPopup(
                          child: BusinessInformationView(
                            heroId: state.list[index].businessId,
                            dto: state.list[index],
                          ),
                          width: width * 0.7,
                          height: height * 0.9,
                        );

                        businessInformationBloc.add(
                            BusinessInformationEventGetList(
                                userId: UserInformationHelper.instance
                                    .getUserId()));
                      },
                      businessTransaction: () {},
                    );
                  },
                ),
              ],
            );
          }
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildListShortcut() {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          ShortcutIcon(
            context: context,
            title: 'Tạo doanh nghiệp',
            description: 'Quản lý doanh nghiệp trên hệ thống',
            icon: Icons.business_rounded,
            color: DefaultTheme.GREEN,
            function: () {
              DialogWidget.instance.openPopup(
                child: const AddBusinessView(),
                width: width * 0.6,
                height: height * 0.8,
              );
            },
          ),
          const SizedBox(
            height: 20,
          ),
          ShortcutIcon(
            context: context,
            title: 'Tài khoản ngân hàng',
            description: 'Thêm và Liên kết tài khoản ngân hàng',
            icon: Icons.credit_card_rounded,
            color: DefaultTheme.PURPLE_NEON,
            function: () {
              String userId = UserInformationHelper.instance.getUserId();
              context.go('/bank/create/$userId');
            },
          ),
        ],
      ),
    );
  }
}
