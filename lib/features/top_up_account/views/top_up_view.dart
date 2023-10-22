import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/widgets/ambient_avatar_widget.dart';
import 'package:VietQR/commons/widgets/button_icon_widget.dart';
import 'package:VietQR/commons/widgets/button_widget.dart';
import 'package:VietQR/commons/widgets/dialog_widget.dart';
import 'package:VietQR/commons/widgets/textfield_widget.dart';
import 'package:VietQR/features/top_up_account/blocs/top_up_bloc.dart';
import 'package:VietQR/features/top_up_account/states/top_up_state.dart';
import 'package:VietQR/layouts/border_layout.dart';

import 'package:VietQR/services/shared_references/user_information_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../create_qr/provider/create_qr_provider.dart';
import '../frames/top_up_frame.dart';

class TopUpAccount extends StatefulWidget {
  const TopUpAccount({super.key});

  @override
  State<TopUpAccount> createState() => _TopUpAccountState();
}

class _TopUpAccountState extends State<TopUpAccount> {
  final TextEditingController phoneNoController = TextEditingController();
  final TextEditingController topUpNoController = TextEditingController();
  late TopUpBloc _topUpBloc;
  FocusNode focusNode = FocusNode();
  List<String> listTopUpExample = [
    '10.000 VND',
    '20.000 VND',
    '30.000 VND',
    '50.000 VND',
    '100.000 VND',
    '200.000 VND',
    '500.000 VND'
  ];
  @override
  void initState() {
    _topUpBloc = TopUpBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<TopUpBloc>(
          create: (context) => _topUpBloc,
          child: Container(
            height: double.infinity,
            color: Theme.of(context).cardColor,
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: TopUpFrame(
              widget1: _buildInputPhoneNumber(),
              widget2: _buildTopUpAccount(),
            ),
          )),
    );
  }

  Widget _buildInputPhoneNumber() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Nhập số điện thoại bạn muốn nạp tiền',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: BorderLayout(
                  height: 50,
                  isError: false,
                  child: TextFieldWidget(
                    isObscureText: false,
                    autoFocus: true,
                    hintText: 'Số điện thoại',
                    fontSize: 12,
                    controller: phoneNoController,
                    inputType: TextInputType.text,
                    keyboardAction: TextInputAction.done,
                    onSubmitted: (value) {},
                    onChange: (vavlue) {},
                  ),
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              ButtonIconWidget(
                height: 50,
                width: 50,
                icon: Icons.search,
                title: '',
                function: () {
                  DialogWidget.instance.openMsgDialog(
                    title: 'Tính năng đang bảo trì',
                    msg: 'Vui lòng thử lại sau',
                  );
                },
                bgColor: AppColor.GREEN,
                textColor: AppColor.WHITE,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTopUpAccount() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: BlocConsumer<TopUpBloc, TopUpState>(
          listener: (context, state) {},
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // _buildInfoAccount(),
                const Text(
                  'Số tiền bạn muốn nạp',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 10)),
                Consumer<CreateQRProvider>(
                  builder: (context, provider, child) {
                    return Column(
                      children: [
                        BorderLayout(
                          height: 50,
                          isError: provider.amountErr,
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFieldWidget(
                                  isObscureText: false,
                                  autoFocus: true,
                                  focusNode: focusNode,
                                  hintText: 'VD: 50,000',
                                  fontSize: 12,
                                  controller: topUpNoController,
                                  inputType: TextInputType.number,
                                  keyboardAction: TextInputAction.next,
                                  onChange: (vavlue) {
                                    // if (amountController.text.isNotEmpty) {
                                    //   if (StringUtils.instance.isNumeric(
                                    //       amountController.text)) {
                                    //     provider.updateAmountErr(false);
                                    //     if (amountController.text.length >=
                                    //         4) {
                                    //       provider.updateValidCreate(true);
                                    //     } else {
                                    //       provider.updateValidCreate(false);
                                    //     }
                                    //   } else {
                                    //     provider.updateAmountErr(true);
                                    //     provider.updateValidCreate(false);
                                    //   }
                                    // } else {
                                    //   provider.updateAmountErr(false);
                                    //   provider.updateValidCreate(false);
                                    // }
                                  },
                                ),
                              ),
                              const Text(
                                'VND',
                                style: TextStyle(fontSize: 12),
                              ),
                              const Padding(padding: EdgeInsets.only(left: 20)),
                            ],
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(top: 5)),
                        if (provider.amountErr)
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Số tiền không đúng định dạng',
                              style: TextStyle(
                                color: AppColor.RED_CALENDAR,
                                fontSize: 12,
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
                const Padding(padding: EdgeInsets.only(top: 8)),
                _buildTopUpExample(),
                const Padding(padding: EdgeInsets.only(top: 24)),
                ButtonWidget(
                  height: 40,
                  text: 'XÁC NHẬN',
                  borderRadius: 5,
                  textColor: AppColor.WHITE,
                  bgColor: AppColor.GREY_BUTTON,
                  function: () {},
                ),
              ],
            );
          }),
    );
  }

  Widget _buildTopUpExample() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: listTopUpExample.map((e) {
        return _buildChoiceChip(e);
      }).toList(),
    );
  }

  Widget _buildInfoAccount() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: Row(
        children: [
          const Spacer(),
          _buildAvatarWidget(),
          const SizedBox(
            width: 16,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Test',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                'tranvankimcuong@gmail.com',
              ),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildAvatarWidget() {
    double size = 100;
    String imgId = UserInformationHelper.instance.getAccountInformation().imgId;
    return (imgId.isEmpty)
        ? ClipOval(
            child: SizedBox(
              width: size,
              height: size,
              child: Image.asset('assets/images/ic-avatar.png'),
            ),
          )
        : AmbientAvatarWidget(imgId: imgId, size: size);
  }

  Widget _buildChoiceChip(
    String text,
    // ValueChanged<Object>? onTap,
  ) {
    return UnconstrainedBox(
      child: InkWell(
        onTap: () {
          // contentController.clear();
          // contentController.value = contentController.value.copyWith(
          //   text: text.toString(),
          // );
          // return onTap!(text);
        },
        focusNode: null,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
