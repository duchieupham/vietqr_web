import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/commons/utils/platform_utils.dart';
import 'package:VietQR/commons/utils/string_utils.dart';
import 'package:VietQR/commons/widgets/button_widget.dart';
import 'package:VietQR/commons/widgets/dialog_widget.dart';
import 'package:VietQR/commons/widgets/textfield_widget.dart';
import 'package:VietQR/commons/widgets/viet_qr_widget.dart';
import 'package:VietQR/features/bank/widgets/select_bank_type_widget.dart';
import 'package:VietQR/features/login/blocs/qrcode_un_authen_bloc.dart';
import 'package:VietQR/features/login/states/qrcode_un_authen_state.dart';
import 'package:VietQR/layouts/border_layout.dart';
import 'package:VietQR/layouts/box_layout.dart';
import 'package:VietQR/models/bank_type_dto.dart';
import 'package:VietQR/models/qr_generated_dto.dart';
import 'package:VietQR/services/providers/bank_type_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../commons/widgets/bottom_web.dart';
import '../events/qrcode_un_authen_event.dart';

class CreateQRCode extends StatefulWidget {
  const CreateQRCode({super.key});

  @override
  State<CreateQRCode> createState() => _CreateQRCodeState();
}

class _CreateQRCodeState extends State<CreateQRCode> {
  static final TextEditingController bankAccountController =
      TextEditingController();
  static final TextEditingController nameController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late QRCodeUnUTBloc qrCodeUnUTBloc;

  QRGeneratedDTO qrGeneratedDTO = const QRGeneratedDTO(
    bankCode: '',
    bankName: '',
    bankAccount: '',
    userBankName: '',
    amount: '',
    content: '',
    qrCode: '',
    imgId: '58b7190b-a294-4b14-968f-cd365593893e',
  );
  @override
  void initState() {
    super.initState();
    qrCodeUnUTBloc = BlocProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          children: [
            if (PlatformUtils.instance.resizeWhen(constraints.maxWidth, 800))
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.fromLTRB(30, 100, 30, 30),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildFormInput()),
                    Expanded(child: _buildQRCode())
                  ],
                ),
              ))
            else ...[
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: _buildFormInput(),
              ),
              _buildQRCode(
                  horizontalInfo: true,
                  horizontalInfoWidth: constraints.maxWidth,
                  width: 320)
            ],
            if (PlatformUtils.instance
                .resizeWhen(constraints.maxWidth, 800)) ...[
              const Divider(
                color: DefaultTheme.BLACK_DARK,
                thickness: 0.5,
                height: 0.5,
              ),
              const BottomWeb()
            ]
          ],
        );
      },
    );
  }

  Widget _buildFormInput() {
    return Consumer<BankTypeProvider>(
      builder: (context, provider, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView(
            shrinkWrap: true,
            children: [
              const Text(
                'Thông tin thiết lập mã QR',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const Padding(padding: EdgeInsets.only(top: 30)),
              _buildListBank(),
              const Padding(padding: EdgeInsets.only(top: 25)),
              BorderLayout(
                height: 50,
                isError: provider.bankAccountErr,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextFieldWidget(
                  isObscureText: false,
                  maxLines: 1,
                  hintText: 'Số tài khoản \u002A',
                  controller: bankAccountController,
                  inputType: TextInputType.number,
                  focusNode: _focusNode,
                  keyboardAction: TextInputAction.next,
                  onTapOutside: (value) {
                    if (_focusNode.hasFocus) {
                      _focusNode.unfocus();
                      _focusNode.unfocus();
                    }
                  },
                  onChange: (vavlue) {
                    provider.updateBankAccountErr(
                      (bankAccountController.text.isEmpty ||
                          !StringUtils.instance
                              .isNumeric(bankAccountController.text)),
                    );
                  },
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 5)),
              Visibility(
                visible: provider.bankAccountErr,
                child: const Text(
                  'Số tài khoản không hợp lệ',
                  style: TextStyle(
                    fontSize: 12,
                    color: DefaultTheme.RED_TEXT,
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 10)),
              BorderLayout(
                height: 50,
                isError: provider.nameErr,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextFieldWidget(
                  isObscureText: false,
                  maxLines: 1,
                  hintText: 'Chủ tài khoản \u002A',
                  controller: nameController,
                  inputType: TextInputType.number,
                  keyboardAction: TextInputAction.next,
                  onChange: (vavlue) {
                    provider.updateNameErr(
                      nameController.text.isEmpty,
                    );
                  },
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 5)),
              Visibility(
                visible: provider.nameErr,
                child: const Text(
                  'Chủ tài khoản không hợp lệ',
                  style: TextStyle(
                    fontSize: 12,
                    color: DefaultTheme.RED_TEXT,
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 50)),
              ButtonWidget(
                width: (provider.bankType.status == 0) ? 380 : 380 / 2 - 10,
                height: 40,
                text: 'Thêm',
                borderRadius: 5,
                textColor: DefaultTheme.WHITE,
                bgColor: DefaultTheme.GREEN,
                function: () {
                  if (provider.bankType.bankCode.isNotEmpty) {
                    provider.updateBankAccountErr(
                      (bankAccountController.text.isEmpty ||
                          !StringUtils.instance
                              .isNumeric(bankAccountController.text)),
                    );
                    provider.updateNameErr(
                      nameController.text.isEmpty,
                    );
                    if (provider.isValidUnauthenticateForm()) {
                      Map<String, dynamic> data = {};
                      data['bankAccount'] = bankAccountController.text;
                      data['userBankName'] = nameController.text;
                      data['bankCode'] = provider.bankType.bankCode;
                      qrCodeUnUTBloc.add(QRCodeUnUTCreateQR(data: data));
                    }
                  } else {
                    DialogWidget.instance.openMsgDialog(
                      title: 'Không thể tạo',
                      msg: 'Vui lòng chọn ngân hàng thụ hưởng',
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildListBank() {
    return Consumer<BankTypeProvider>(
      builder: (context, provider, child) {
        return InkWell(
          onTap: () {
            DialogWidget.instance.openPopup(
              child: const SelectBankTypeWidget(
                authenticated: false,
              ),
              width: 500,
              height: 500,
            );
          },
          child: (provider.bankType.bankCode.isEmpty)
              ? BoxLayout(
                  bgColor: DefaultTheme.GREY_BG,
                  height: 50,
                  borderRadius: 5,
                  child: Row(
                    children: const [
                      Text(
                        'Chọn ngân hàng thụ hưởng',
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                      Spacer(),
                      Icon(
                        Icons.arrow_drop_down_circle_outlined,
                        size: 12,
                      ),
                    ],
                  ),
                )
              : _buildSelectedBankType(
                  context,
                  provider.bankType,
                ),
        );
      },
    );
  }

  Widget _buildSelectedBankType(BuildContext context, BankTypeDTO dto) {
    return SizedBox(
      height: 120,
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 20),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(padding: EdgeInsets.only(top: 10)),
                Text(
                  dto.bankCode,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Padding(padding: EdgeInsets.only(top: 2)),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  child: Text(
                    dto.bankName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: _buildLogo(context, 70, dto.imageId, BoxFit.contain),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo(
      BuildContext context, double size, String imageId, BoxFit fit) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size),
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: UnconstrainedBox(
        child: Container(
          width: size - 10,
          height: size - 10,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size - 10),
            color: DefaultTheme.WHITE,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).shadowColor.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 2,
                offset: const Offset(1, 2),
              ),
            ],
            image: DecorationImage(
                fit: fit, image: ImageUtils.instance.getImageNetWork(imageId)),
          ),
        ),
      ),
    );
  }

  Widget _buildQRCode(
      {bool horizontalInfo = false,
      double horizontalInfoWidth = 400,
      double width = 400}) {
    return BlocConsumer<QRCodeUnUTBloc, QRCodeUnUTState>(
      listener: (context, state) {
        if (state is CreateSuccessfulState) {
          qrGeneratedDTO = state.dto;
        }
      },
      builder: (context, state) {
        if (state is CreateQRLoadingState) {
          return const UnconstrainedBox(
            child: SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(
                color: DefaultTheme.GREEN,
              ),
            ),
          );
        }
        return (qrGeneratedDTO.qrCode.isEmpty)
            ? _buildQRCodeBlank()
            : Padding(
                padding: const EdgeInsets.only(top: 26),
                child: UnconstrainedBox(
                  child: VietQRWidget(
                    width: width,
                    horizontalInfoWidth: horizontalInfoWidth,
                    horizontalInfo: horizontalInfo,
                    qrGeneratedDTO: qrGeneratedDTO,
                    content: '',
                  ),
                ),
              );
      },
    );
  }

  Widget _buildQRCodeBlank() {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: QrImage(
          data: 'http://localhost:55687/login',
          size: 260,
          foregroundColor: Colors.black38,
          embeddedImageStyle: QrEmbeddedImageStyle(
            size: const Size(30, 30),
          ),
        ),
      ),
    );
  }
}
