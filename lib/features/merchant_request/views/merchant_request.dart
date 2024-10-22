import 'package:VietQR/commons/constants/configurations/app_image.dart';
import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/enums/type_menu_home.dart';
import 'package:VietQR/commons/utils/error_utils.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/commons/widgets/button_widget.dart';
import 'package:VietQR/commons/widgets/dialog_widget.dart';
import 'package:VietQR/features/dashboard/views/menu_left.dart';
import 'package:VietQR/features/home/widget/item_menu_home.dart';
import 'package:VietQR/features/home/widget/item_menu_top.dart';
import 'package:VietQR/features/merchant_request/blocs/merchant_request_bloc.dart';
import 'package:VietQR/features/merchant_request/events/merchant_request_event.dart';
import 'package:VietQR/features/merchant_request/frame/merchant_request_frame.dart';
import 'package:VietQR/features/merchant_request/page/confirm_infor.dart';
import 'package:VietQR/features/merchant_request/page/get_username_pass.dart';
import 'package:VietQR/features/merchant_request/page/infocustomer.dart';
import 'package:VietQR/features/merchant_request/provider/merchant_request_provider.dart';
import 'package:VietQR/features/merchant_request/states/merchant_request_state.dart';
import 'package:VietQR/services/providers/menu_provider.dart';
import 'package:VietQR/services/shared_references/user_information_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../home/widget/item_menu_dropdown.dart';

class MerchantRequest extends StatefulWidget {
  const MerchantRequest({super.key});

  @override
  State<MerchantRequest> createState() => _MerchantViewState();
}

class _MerchantViewState extends State<MerchantRequest> {
  final ScrollController scrollController = ScrollController();
  final PageController _pageController = PageController(initialPage: 0);
  int offset = 0;
  SubMenuType currentType = SubMenuType.LIST_TRANSACTION;
  bool isEnded = false;
  String nowMonth = '';

  late MerchantRequestBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = MerchantRequestBloc();
  }

  void _animatedToPage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOutQuart,
    );
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return BlocProvider<MerchantRequestBloc>(
      create: (BuildContext context) => _bloc,
      child: ChangeNotifierProvider<MerchantRequestProvider>(
        create: (context) => MerchantRequestProvider()..getListBankAccount(),
        child: Consumer<MenuProvider>(builder: (context, provider, child) {
          return MerchantRequestFrame(
            menu: MenuLeft(
              currentType: MenuHomeType.MERCHANT_REQUEST,
              subMenuMerchantRequest: [
                ItemDropDownMenu(
                  title: 'API SERVICE',
                  isSelect: true,
                  onTap: () {},
                ),
                ItemDropDownMenu(
                  title: 'ECOMMERCE',
                  isSelect: false,
                  onTap: () {
                    context.go('/merchant/request/ecommerce');
                  },
                ),
                ItemDropDownMenu(
                  title: 'KẾT NỐI MÁY BÁN HÀNG',
                  isSelect: false,
                  onTap: () {
                    context.go('/merchant/request/mbh');
                  },
                ),
                if (UserInformationHelper.instance
                    .getCustomerSyncTestId()
                    .trim()
                    .isNotEmpty)
                  ItemDropDownMenu(
                    title: 'TEST CALLBACK',
                    isSelect: false,
                    onTap: () {
                      context.go('/merchant/callback');
                    },
                  ),
              ],
            ),
            title: _buildTitle(provider),
            widget1: UserInformationHelper.instance.getAccountIsMerchant()
                ? _buildBlank()
                : BlocListener<MerchantRequestBloc, MerchantRequestState>(
                    listener: (context, state) {
                      if (state is MerchantLoadingState) {
                        DialogWidget.instance.openLoadingDialog();
                      }
                      if (state is InsertSuccessfulState) {
                        Navigator.pop(context);
                        DialogWidget.instance.openMsgSuccessDialog(
                            title:
                                'Tạo yêu cầu thành công, vui lòng chờ bộ phận quản lý xác nhận.',
                            onTapClose: () {
                              context.go('/home');
                            });
                      }
                      if (state is InsertFailedState) {
                        Navigator.pop(context);

                        String msg = ErrorUtils.instance
                            .getErrorMessage(state.dto.message);
                        DialogWidget.instance.openMsgDialog(
                            title: 'Tạo yêu cầu không thành công', msg: msg);
                      }
                    },
                    child: Column(
                      children: [
                        Expanded(
                          child: PageView(
                            physics: const NeverScrollableScrollPhysics(),
                            controller: _pageController,
                            children: [
                              InforCustomer(
                                bloc: _bloc,
                              ),
                              GetUsernamePassword(
                                bloc: _bloc,
                              ),
                              const ConfirmInfo(),
                            ],
                          ),
                        ),
                        _buildButton(),
                      ],
                    ),
                  ),
          );
        }),
      ),
    );
  }

  Widget _buildButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Consumer<MerchantRequestProvider>(
          builder: (context, provider, child) {
        if (provider.page == 0) {
          return ButtonWidget(
            text: 'Tiếp tục',
            height: 40,
            borderRadius: 5,
            width: 360,
            textColor: AppColor.WHITE,
            bgColor: AppColor.BLUE_TEXT,
            function: () {
              provider.checkValidate();
              if (provider.isValidate()) {
                provider.changePage(1);
                _animatedToPage(1);
              }
            },
          );
        } else if (provider.page == 1) {
          return SizedBox(
            width: 560,
            child: Row(
              children: [
                Expanded(
                  child: ButtonWidget(
                    text: 'Trờ về',
                    height: 40,
                    borderRadius: 5,
                    textColor: AppColor.BLUE_TEXT,
                    bgColor: AppColor.WHITE,
                    function: () {
                      _animatedToPage(0);
                      provider.changePage(0);
                    },
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: ButtonWidget(
                    text: 'Tiếp tục',
                    height: 40,
                    borderRadius: 5,
                    textColor: AppColor.WHITE,
                    bgColor: AppColor.BLUE_TEXT,
                    function: () {
                      if (provider.systemUsername.isEmpty) {
                        DialogWidget.instance.openMsgDialog(
                            title: 'Thông tin không hợp lệ',
                            msg: 'Vui lòng lấy thông tin kết nối');
                      } else {
                        provider.changePage(2);
                        _animatedToPage(2);
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        } else if (provider.page == 2) {
          return SizedBox(
            width: 560,
            child: Row(
              children: [
                Expanded(
                  child: ButtonWidget(
                    text: 'Chỉnh sửa',
                    height: 40,
                    borderRadius: 5,
                    textColor: AppColor.BLUE_TEXT,
                    bgColor: AppColor.WHITE,
                    function: () {
                      _animatedToPage(0);
                      provider.changePage(0);
                    },
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: ButtonWidget(
                    text: 'Tạo yêu cầu kết nối',
                    height: 40,
                    borderRadius: 5,
                    textColor: AppColor.WHITE,
                    bgColor: AppColor.BLUE_TEXT,
                    function: () {
                      Map<String, dynamic> param = {};
                      param['merchantName'] = provider.merchant;
                      if (provider.valueTypeConnect == 0) {
                        param['url'] = provider.urlConnect;
                        param['id'] = '';
                        param['port'] = '';
                      } else {
                        param['url'] = '';
                        param['id'] = provider.ipConnect;
                        param['port'] = provider.portConnect;
                      }

                      param['suffixUrl'] = provider.suffixConnect;
                      param['address'] = provider.address;
                      param['bankAccount'] =
                          provider.bankAccountDTO.bankAccount;
                      param['bankCode'] = provider.bankAccountDTO.bankCode;
                      param['userBankName'] =
                          provider.bankAccountDTO.userBankName;
                      param['customerUsername'] = provider.username;
                      param['customerPassword'] = provider.password;
                      param['systemUsername'] = provider.systemUsername;
                      param['customerSyncActive'] = 0;
                      _bloc.add(InsertMerchantEvent(param));
                    },
                  ),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      }),
    );
  }

  Widget _buildTitle(MenuProvider provider) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 45,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(color: AppColor.BLUE_TEXT.withOpacity(0.1)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ItemMenuTop(
                title: 'API SERVICE',
                isSelect: true,
                showBottomBorder: true,
                onTap: () {},
              ),
              const SizedBox(
                width: 16,
              ),
              ItemMenuTop(
                title: 'ECOMMERCE',
                isSelect: false,
                onTap: () {
                  context.go('/merchant/request/ecommerce');
                },
              ),
              const SizedBox(
                width: 16,
              ),
              ItemMenuTop(
                title: 'KẾT NỐI MÁY BÁN HÀNG',
                isSelect: false,
                onTap: () {
                  context.go('/merchant/request/mbh');
                },
              ),
              if (UserInformationHelper.instance
                  .getCustomerSyncTestId()
                  .trim()
                  .isNotEmpty)
                ItemMenuTop(
                  title: 'TEST CALLBACK',
                  isSelect: false,
                  onTap: () {
                    context.go('/merchant/callback');
                  },
                ),
            ],
          ),
        ),
        if (!provider.isAccountIsMerchant) _buildStep(),
      ],
    );
  }

  Widget _buildStep() {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Consumer<MerchantRequestProvider>(
          builder: (context, provider, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildItemStep('Khai báo thông tin đại lý', '1', true,
                isStepFirst: true),
            buildItemStep('Lấy username - password của hệ thống', '2',
                provider.page == 1 || provider.page == 2),
            buildItemStep('Xác nhận', '3', provider.page == 2),
          ],
        );
      }),
    );
  }

  Widget buildItemStep(String title, String step, bool isStep,
      {bool isStepFirst = false}) {
    return Row(
      children: [
        if (!isStepFirst)
          Container(
            height: 2,
            width: 160,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: isStep ? AppColor.BLUE_TEXT : AppColor.GREY_TEXT),
          ),
        Container(
          height: 22,
          width: 22,
          decoration: BoxDecoration(
            color: isStep ? AppColor.BLUE_TEXT : AppColor.GREY_TEXT,
            borderRadius: BorderRadius.circular(20),
          ),
          alignment: Alignment.center,
          child: Text(
            step,
            style: const TextStyle(color: AppColor.WHITE, fontSize: 12),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            title,
            style: const TextStyle(fontSize: 12, color: AppColor.GREY_TEXT),
          ),
        ),
      ],
    );
  }

  Widget _buildBlank() {
    return Column(
      children: [
        const SizedBox(
          height: 120,
        ),
        Image(
          image: ImageUtils.instance.getImageNetWork(AppImages.ic3dMerchant),
          height: 220,
        ),
        const SizedBox(
          height: 20,
        ),
        const Text(
          'Tài khoản của bạn đã đăng ký đại lý kết nối API Service.\nVui lòng vào danh mục "Đại lý" để xem thông tin chi tiết.',
          style: TextStyle(fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
