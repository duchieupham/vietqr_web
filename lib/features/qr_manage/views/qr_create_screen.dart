import 'package:VietQR/commons/enums/check_type.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/commons/utils/string_utils.dart';
import 'package:VietQR/commons/widgets/button/m_button_icon_widget.dart';
import 'package:VietQR/commons/widgets/dot_dash_widget.dart';
import 'package:VietQR/features/create_qr/provider/create_qr_provider.dart';
import 'package:VietQR/features/qr_manage/blocs/qr_create_bloc.dart';
import 'package:VietQR/features/qr_manage/event/qr_create_events.dart';
import 'package:VietQR/features/qr_manage/states/qr_manage_state.dart';
import 'package:VietQR/models/bank_type_dto.dart';
import 'package:VietQR/models/merchant/merchant_dto.dart';
import 'package:VietQR/models/qr_generated_dto.dart';
import 'package:VietQR/models/transaction/terminal_qr_dto.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:html' as html;

import '../../../commons/constants/configurations/theme.dart';
import '../../../commons/utils/share_utils.dart';
import '../../../commons/widgets/dashed_line.dart';
import '../../../commons/widgets/m_button_widget.dart';
import '../../../commons/widgets/repaint_boundary_widget.dart';
import '../../../models/bank_account_dto.dart';
import '../../../services/shared_references/session.dart';
import '../../bank/blocs/bank_type_bloc.dart';
import '../../bank/events/bank_type_event.dart';
import '../widgets/popup_bank_select_widget.dart';

class QrGenerateScreen extends StatelessWidget {
  const QrGenerateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<QRCreateBloc>(
      create: (context) => QRCreateBloc(context),
      child: const _Screen(),
    );
  }
}

class _Screen extends StatefulWidget {
  const _Screen({super.key});

  @override
  State<_Screen> createState() => _ScreenState();
}

class _ScreenState extends State<_Screen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _invoiceController = TextEditingController();
  final TextEditingController _terminalController = TextEditingController();
  final TextEditingController _bankAccountController = TextEditingController();
  final TextEditingController _userBankNameController = TextEditingController();

  final globalKey = GlobalKey();

  late QRCreateBloc _qrCreateBloc;
  late CreateQRProvider _provider;
  FocusNode focusNodeWidget = FocusNode();

  void onSaveImage(BuildContext context) async {
    await Future.delayed(
      const Duration(milliseconds: 200),
      () async {
        await ShareUtils.instance.saveImageToGallery(globalKey).then(
          (value) {
            Fluttertoast.showToast(
              msg: 'Đã lưu ảnh',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Theme.of(context).cardColor,
              textColor: Theme.of(context).hintColor,
              fontSize: 15,
              webBgColor: 'rgba(255, 255, 255)',
              webPosition: 'center',
            );
          },
        );
      },
    );
  }

  bool _isChecked = false;
  bool _isExpanded = false;
  bool _isError = false;
  bool isFirstSelected = true;

  int contentLength = 0;
  int invoiceLength = 0;

  String amountInput = '';

  List<BankAccountDTO>? bankAccounts = [];
  List<BankTypeDTO>? bankTypes = [];

  BankTypeDTO? selectBankTypes =
      const BankTypeDTO(bankName: 'Chọn hoặc nhập tên ngân hàng', id: '0');

  String ic_linked_bank = '3e985867-7e93-4b3c-8164-945b7265752c';
  String ic_share_bank = '98d70358-a82e-4bf5-84f8-02cb563c685b';

  @override
  void initState() {
    _provider = Provider.of<CreateQRProvider>(context, listen: false);
    _provider.clear();
    _qrCreateBloc = BlocProvider.of(context);
    _qrCreateBloc.add(GetListBankAccount());
    _qrCreateBloc.add(GetListBankType());
    // _qrCreateBloc.add(GetListTerminalEvent());
    // Session.instance.fetchAccountSetting();
    super.initState();
  }

  @override
  void dispose() {
    _amountController.clear();
    _bankAccountController.clear();
    _contentController.clear();
    _invoiceController.clear();
    _terminalController.clear();
    _userBankNameController.clear();
    super.dispose();
  }

  void onPopupBankSelect({required bool isAuth}) async {
    return await showDialog(
      context: context,
      builder: (context) {
        return PopupBankSelectWidget(
          isAuthBank: isAuth,
          onDone: (id) {
            _qrCreateBloc.add(GetListTerminalEvent(bankId: id));
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CreateQRProvider>(
      builder: (context, provider, child) {
        bool isEnableButton = false;
        if (isFirstSelected) {
          if (provider.bankAccountDTO != null) {
            isEnableButton = true;
          }
        } else {
          if (provider.selectBankType != null &&
              _bankAccountController.text.isNotEmpty &&
              _userBankNameController.text.isNotEmpty) {
            isEnableButton = true;
          } else {
            isEnableButton = false;
          }
        }
        return BlocConsumer<QRCreateBloc, QRGenerateState>(
          listener: (context, state) {
            if (state.request == QrGenerate.GET_BANKS &&
                state.status == BlocStatus.UNLOADING) {
              bankAccounts = state.listAccountBanks;
              provider.updateBankList(bankAccounts!);
            }

            if (state.request == QrGenerate.GET_BANK_TYPE &&
                state.status == BlocStatus.UNLOADING) {
              // bankTypes = state.listBankType;
              bankTypes = state.listBankType!;
              provider.updateBankTypeList(bankTypes!);
            }
            if (state.request == QrGenerate.GET_MERCHANTS &&
                state.status == BlocStatus.UNLOADING) {
              provider.updateTerminals(state.listTerminal!);
            }

            if (state.request == QrGenerate.QR_GENERATE &&
                state.status == BlocStatus.UNLOADING) {
              if (_isChecked) {
                html.window.open(
                    Uri.base.toString().replaceFirst('/create-vietqr',
                        '/qr-generated?token=${state.dto!.transactionRefId}'),
                    'new tab');
              }
            }
          },
          builder: (context, state) {
            return Container(
              width: MediaQuery.of(context).size.width - 250,
              decoration: const BoxDecoration(
                  color: AppColor.WHITE,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _headerWidget(),
                  const Divider(),
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          width: 410,
                          padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Thông tin thiết lập mã VietQR",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  _buildOption(
                                      "Tài khoản đã thêm", isFirstSelected),
                                  const SizedBox(width: 20),
                                  _buildOption(
                                      "Tài khoản khác", !isFirstSelected),
                                ],
                              ),
                              const SizedBox(height: 20),
                              _conditionalWidget(),
                              const Spacer(),
                              _buildCheckBox(
                                isEnable: isEnableButton,
                                onTap: isEnableButton
                                    ? () {
                                        if (isFirstSelected == true) {
                                          _qrCreateBloc.add(QRGenerateEvent(
                                            bankId:
                                                provider.bankAccountDTO!.bankId,
                                            amount: amountInput,
                                            content: _contentController.text,
                                            terminalCode:
                                                provider.inputTerminal!.isEmpty
                                                    ? (provider.selectTerminal!
                                                                .terminalCode ==
                                                            '0'
                                                        ? ''
                                                        : provider
                                                            .selectTerminal!
                                                            .terminalCode)
                                                    : provider.inputTerminal,
                                            orderId: _invoiceController.text,
                                          ));
                                        } else {
                                          _qrCreateBloc.add(
                                            UnAuthQRGenerateEvent(
                                                bankAccount:
                                                    _bankAccountController.text,
                                                bankCode: provider
                                                    .selectBankType!.bankCode,
                                                userBankName:
                                                    _userBankNameController
                                                        .text,
                                                amount: amountInput,
                                                content:
                                                    _contentController.text),
                                          );
                                        }
                                      }
                                    : null,
                              ),
                            ],
                          ),
                        ),
                        if (state.request == QrGenerate.QR_GENERATE &&
                            state.dto != null &&
                            isFirstSelected == true) ...[
                          Expanded(
                            child: _buildQrCode(state.dto!),
                          ),
                          _buildInfoTrans(state.dto!,
                              orderId: _invoiceController.text),
                        ] else if (state.request ==
                                QrGenerate.UN_AUTH_QR_GENERATE &&
                            state.dto != null)
                          Expanded(
                            child: _buildQrCode(state.dto!),
                          )
                        else
                          const Expanded(child: SizedBox()),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildInfoTrans(QRGeneratedDTO dto, {required String orderId}) {
    return isFirstSelected
        ? Container(
            width: 410,
            padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Thông tin mã VietQR giao dịch",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                const Text(
                  "QR Link:",
                  style: TextStyle(fontSize: 15),
                ),
                const SizedBox(height: 5),
                const Text(
                  "Đường dẫn thanh toán qua mã VietQR",
                  style: TextStyle(fontSize: 15),
                ),
                const SizedBox(height: 10),
                Container(
                  width: 350,
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColor.GREY_DADADA),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          dto.qrLink,
                          style: const TextStyle(
                              color: AppColor.BLUE_TEXT, fontSize: 15),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          await FlutterClipboard.copy(dto.qrLink).then(
                            (value) => Fluttertoast.showToast(
                              msg: 'Đã sao chép',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: AppColor.WHITE,
                              textColor: AppColor.BLACK,
                              fontSize: 15,
                              webBgColor: 'rgba(255, 255, 255)',
                              webPosition: 'center',
                            ),
                          );
                        },
                        icon: const Tooltip(
                          message: 'Sao chép',
                          child: Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Icon(
                              Icons.file_copy_outlined,
                              color: AppColor.BLUE_TEXT,
                              size: 15,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                orderId.isNotEmpty
                    ? Container(
                        width: 350,
                        height: 50,
                        decoration: const BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: AppColor.GREY_DADADA, width: 1))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'Mã đơn hàng:',
                              style: TextStyle(fontSize: 15),
                            ),
                            Text(
                              orderId,
                              style: const TextStyle(fontSize: 15),
                            )
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
                dto.terminalCode.isNotEmpty
                    ? SizedBox(
                        width: 350,
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'Mã cửa hàng / điểm bán:',
                              style: TextStyle(fontSize: 15),
                            ),
                            Text(
                              dto.terminalCode,
                              style: const TextStyle(fontSize: 15),
                            )
                          ],
                        ),
                      )
                    : const SizedBox.shrink()
              ],
            ),
          )
        : const SizedBox(
            width: 410,
          );
  }

  Widget _buildQrCode(QRGeneratedDTO dto) {
    return Container(
      padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Mã VietQR của bạn",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          const Text(
            "Nhận tiền từ mọi ngân hàng và ví điện tử có hỗ trợ VietQR",
            style: TextStyle(fontSize: 13),
          ),
          const SizedBox(height: 20),
          RepaintBoundaryWidget(
              globalKey: globalKey,
              builder: (key) {
                return Container(
                  width: 350,
                  height: 430,
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                        image: AssetImage('assets/images/bg-qr-vqr.png'),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        Container(
                          width: 300,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: AppColor.GREY_BG,
                          ),
                          child: IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  width: 80,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24),
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: ImageUtils.instance
                                          .getImageNetWork(dto.imgId),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 40,
                                  child: VerticalDashedLine(),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 8),
                                    alignment: Alignment.centerLeft,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          dto.bankAccount,
                                          maxLines: 1,
                                          style: const TextStyle(
                                              color: AppColor.BLACK,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          dto.userBankName.toUpperCase(),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: AppColor.BLACK,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: 300,
                          height: 300,
                          padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                          decoration: BoxDecoration(
                            color: AppColor.WHITE,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 240,
                                height: 240,
                                // color: AppColor.GREY_DADADA,
                                child: QrImage(
                                  data: dto.qrCode,
                                  size: 220,
                                  version: QrVersions.auto,
                                  embeddedImage: const AssetImage(
                                      'assets/images/ic-viet-qr.png'),
                                  embeddedImageStyle: QrEmbeddedImageStyle(
                                    size: const Size(30, 30),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Image.asset(
                                        "assets/images/ic-viet-qr-code.png",
                                        height: 20,
                                      ),
                                    ),
                                    Image.asset(
                                      "assets/images/ic-napas247.png",
                                      height: 30,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
          const SizedBox(height: 20),
          if (dto.amount != '0' && dto.amount.isNotEmpty) ...[
            Text(
              '+ ${StringUtils.formatNumberAmount(dto.amount)}',
              style: const TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: AppColor.ORANGE_DARK,
              ),
            ),
            Container(
              width: 350,
              height: 1,
              color: AppColor.GREY_DADADA,
            ),
            const SizedBox(height: 20),
            Container(
              width: 350,
              height: 45,
              child: Text(
                dto.content,
                style: const TextStyle(fontSize: 18),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
          ],
          Container(
            height: 50,
            width: 350,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Tooltip(
                  message: '',
                  child: MButtonIconWidget(
                    height: 50,
                    width: 170,
                    icon: Icons.image_outlined,
                    iconSize: 15,
                    textSize: 15,
                    iconColor: AppColor.BLUE_TEXT,
                    title: 'Lưu ảnh VietQR',
                    onTap: () {
                      onSaveImage(context);
                    },
                    border: Border.all(color: AppColor.BLUE_TEXT),
                    bgColor: AppColor.WHITE,
                    textColor: AppColor.BLUE_TEXT,
                  ),
                ),
                Tooltip(
                  message: '',
                  child: MButtonIconWidget(
                    height: 50,
                    width: 170,
                    icon: Icons.print_outlined,
                    iconSize: 15,
                    textSize: 15,
                    iconColor: AppColor.BLUE_TEXT,
                    title: 'In mã VietQR',
                    onTap: () async {
                      String paramData = Session.instance
                          .formatDataParamUrl(dto, showBankAccount: 1);
                      html.window.open(
                          Uri.base.toString().replaceFirst(
                              '/create-vietqr', '/qr-generate/print$paramData'),
                          'new tab');
                    },
                    border: Border.all(color: AppColor.BLUE_TEXT),
                    bgColor: AppColor.WHITE,
                    textColor: AppColor.BLUE_TEXT,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckBox({required bool isEnable, Function()? onTap}) {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (isFirstSelected)
            SizedBox(
              height: 20,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Theme(
                    data: Theme.of(context).copyWith(
                      checkboxTheme: CheckboxThemeData(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        fillColor: MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                          if (states.contains(MaterialState.selected)) {
                            return Colors.blue;
                          }
                          return Colors.grey;
                        }),
                        checkColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                      ),
                    ),
                    child: Checkbox(
                      value: _isChecked,
                      onChanged: (bool? newValue) {
                        setState(() {
                          if (newValue != null) {
                            _isChecked = newValue;
                          }
                        });
                      },
                    ),
                  ),
                  const Text("Hiển thị mã VietQR ở tab mới"),
                ],
              ),
            ),
          const SizedBox(height: 10),
          MButtonWidget(
            onTap: onTap,
            title: 'Tạo mã VietQR',
            isEnable: isEnable,
            margin: EdgeInsets.zero,
            width: 350,
            colorDisableBgr: AppColor.GREY_BUTTON,
            colorDisableText: AppColor.BLACK,
            height: 50,
          ),
        ],
      ),
    );
  }

  Widget _conditionalWidget() {
    return isFirstSelected ? _buildBankAccount() : _buildOtherAccount();
  }

  Widget _buildOtherAccount() {
    return Consumer<CreateQRProvider>(
      builder: (context, provider, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 350,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Ngân hàng thụ hưởng*',
                        style: TextStyle(fontSize: 15),
                      ),
                      provider.selectBankType != null
                          ? InkWell(
                              onTap: () {
                                onPopupBankSelect(isAuth: false);
                              },
                              child: const Text(
                                'Chọn tài khoản',
                                style: TextStyle(
                                    fontSize: 16, color: AppColor.BLUE_TEXT),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  provider.selectBankType != null
                      ? InkWell(
                          onTap: () {
                            onPopupBankSelect(isAuth: false);
                          },
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                            width: 350,
                            height: 65,
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                                border:
                                    Border.all(color: AppColor.GREY_DADADA)),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 75,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        width: 0.5, color: Colors.grey),
                                    image: DecorationImage(
                                      image: ImageUtils.instance
                                          .getImageNetWork(
                                              provider.selectBankType!.imageId),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                          provider
                                              .selectBankType!.bankShortName,
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 4),
                                      Text(
                                        provider.selectBankType!.bankName,
                                        style: const TextStyle(fontSize: 12),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : InkWell(
                          onTap: () {
                            onPopupBankSelect(isAuth: false);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            width: 350,
                            height: 40,
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                                border:
                                    Border.all(color: AppColor.GREY_DADADA)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text(
                                  'Chọn tại khoản ngân hàng',
                                  style: TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      color: AppColor.GREY_TEXT,
                                      fontSize: 15),
                                ),
                                Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 20,
                                  color: AppColor.GREY_TEXT,
                                ),
                              ],
                            ),
                          ),
                        ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 350,
              height: 70,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                    child: Text(
                      'Số tài khoản*',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 350,
                    height: 40,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColor.GREY_DADADA),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextField(
                      controller: _bankAccountController,
                      onChanged: (value) {
                        _bankAccountController.value = TextEditingValue(
                          text: value,
                          selection:
                              TextSelection.collapsed(offset: value.length),
                        );
                        setState(() {});
                      },
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Nhập số tài khoản ngân hàng",
                        hintStyle: TextStyle(color: AppColor.GREY_TEXT),
                        contentPadding: EdgeInsets.only(bottom: 8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 350,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tên chủ tài khoản*',
                    style: TextStyle(fontSize: 15),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 350,
                    height: 40,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColor.GREY_DADADA),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextField(
                      controller: _userBankNameController,
                      keyboardType: TextInputType.name,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(
                            "[a-zA-Z ]")), // Allow letters and spaces only
                      ],
                      onChanged: (value) {
                        _userBankNameController.value = TextEditingValue(
                          text: value,
                          selection:
                              TextSelection.collapsed(offset: value.length),
                        );
                        setState(() {});
                      },
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Nhập tên chủ tài khoản",
                        hintStyle: TextStyle(color: AppColor.GREY_TEXT),
                        contentPadding: EdgeInsets.only(bottom: 8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const SizedBox(
                    height: 15,
                    child: Text(
                      'Không dấu tiếng Việt, không chứa ký tự đặc biệt.',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildToggleOption(),
            const SizedBox(height: 20),
            if (_isExpanded) _buildMoneyinfo(),
          ],
        );
      },
    );
  }

  Widget _buildBankAccount() {
    return Consumer<CreateQRProvider>(
      builder: (context, provider, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 350,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Tài khoản ngân hàng*',
                        style: TextStyle(fontSize: 15),
                      ),
                      provider.bankAccountDTO != null
                          ? InkWell(
                              onTap: () {
                                onPopupBankSelect(isAuth: true);
                              },
                              child: const Text(
                                'Chọn tài khoản',
                                style: TextStyle(
                                    fontSize: 16, color: AppColor.BLUE_TEXT),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  provider.bankAccountDTO != null
                      ? InkWell(
                          onTap: () {
                            onPopupBankSelect(isAuth: true);
                          },
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                            width: 350,
                            height: 80,
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                                border:
                                    Border.all(color: AppColor.GREY_DADADA)),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 85,
                                  height: 50,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        bottom: 0,
                                        child: Container(
                                          width: 75,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border: Border.all(
                                                width: 0.5, color: Colors.grey),
                                            image: DecorationImage(
                                              image: ImageUtils.instance
                                                  .getImageNetWork(provider
                                                      .bankAccountDTO!.imgId),
                                            ),
                                          ),
                                        ),
                                      ),
                                      if (provider.bankAccountDTO!
                                              .isAuthenticated &&
                                          provider.bankAccountDTO!.isOwner)
                                        Positioned(
                                            top: 0,
                                            right: 0,
                                            child: Image(
                                              image: ImageUtils.instance
                                                  .getImageNetWork(
                                                      ic_linked_bank),
                                              width: 28,
                                            )),
                                      if (provider.bankAccountDTO!.isOwner)
                                        Positioned(
                                            top: 0,
                                            right: 0,
                                            child: Image(
                                              image: ImageUtils.instance
                                                  .getImageNetWork(
                                                      ic_share_bank),
                                              width: 28,
                                            )),
                                    ],
                                  ),
                                  // Placeholder for bank logo
                                ),
                                const SizedBox(width: 20),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(provider.bankAccountDTO!.bankAccount,
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 4),
                                    Text(provider.bankAccountDTO!.userBankName,
                                        style: const TextStyle(fontSize: 12)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      : InkWell(
                          onTap: () {
                            onPopupBankSelect(isAuth: true);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            width: 350,
                            height: 40,
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                                border:
                                    Border.all(color: AppColor.GREY_DADADA)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text(
                                  'Chọn tại khoản ngân hàng',
                                  style: TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      color: AppColor.GREY_TEXT,
                                      fontSize: 15),
                                ),
                                Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 20,
                                  color: AppColor.GREY_TEXT,
                                ),
                              ],
                            ),
                          ),
                        ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildMoneyinfo(),
            const SizedBox(height: 20),
            _buildToggleOption(),
            const SizedBox(height: 20),
            if (_isExpanded)
              SizedBox(
                width: 350,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 350,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Mã đơn hàng ($invoiceLength/13 ký tự)',
                            style: const TextStyle(fontSize: 15),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: 350,
                            height: 40,
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColor.GREY_DADADA),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: TextField(
                              maxLength: 13,
                              maxLengthEnforcement:
                                  MaxLengthEnforcement.enforced,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(
                                    "[a-zA-Z0-9]")), // Allow letters and numbers only
                              ],
                              controller: _invoiceController,
                              onChanged: (value) {
                                invoiceLength = value.length;
                                _invoiceController.value = TextEditingValue(
                                    text: value,
                                    selection: TextSelection.collapsed(
                                        offset: value.length));
                                setState(() {});
                              },
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Nhập mã hoá đơn",
                                hintStyle: TextStyle(color: AppColor.GREY_TEXT),
                                contentPadding: EdgeInsets.only(bottom: 8),
                                counterText: "",
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const SizedBox(
                            height: 15,
                            child: Text(
                              'Không dấu tiếng Việt, không chứa ký tự đặc biệt.',
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 350,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Mã cửa hàng / điểm bán',
                            style: TextStyle(fontSize: 15),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          provider.listTerminal!.isNotEmpty
                              ? Container(
                                  width: 350,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: AppColor.GREY_DADADA),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: DropdownButton<TerminalQRDTO>(
                                    value: provider.selectTerminal,
                                    underline: const SizedBox.shrink(),
                                    icon: const RotatedBox(
                                      quarterTurns: 5,
                                      child: Icon(
                                        Icons.arrow_forward_ios,
                                        size: 12,
                                      ),
                                    ),
                                    isExpanded: true,
                                    selectedItemBuilder: (context) {
                                      return provider.listTerminal!
                                          .map((e) =>
                                              DropdownMenuItem<TerminalQRDTO>(
                                                  value: e,
                                                  child: TextField(
                                                    onChanged: (value) {
                                                      provider.inputTer(value);
                                                      // _onFilter(value);
                                                    },
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      hintText: e.terminalName,
                                                      hintStyle:
                                                          const TextStyle(
                                                              color: AppColor
                                                                  .GREY_TEXT),
                                                      contentPadding:
                                                          const EdgeInsets.only(
                                                              bottom: 8),
                                                      counterText: "",
                                                    ),
                                                  )))
                                          .toList();
                                    },
                                    items: provider.listTerminal!.map((e) {
                                      return DropdownMenuItem<TerminalQRDTO>(
                                          value: e,
                                          child: Text(
                                            e.terminalName,
                                            overflow: TextOverflow.ellipsis,
                                          ));
                                    }).toList(),
                                    onChanged: (value) {
                                      provider.selectTer(value!);
                                    },
                                  ),
                                )
                              : InkWell(
                                  onTap: () {
                                    _isError = true;
                                    setState(() {});
                                  },
                                  child: Container(
                                    width: 350,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: AppColor.GREY_DADADA),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: const [
                                        Text('Nhập hoặc chọn mã cửa hàng'),
                                        Icon(Icons.keyboard_arrow_down,
                                            size: 12)
                                      ],
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    provider.bankAccountDTO == null
                        ? Visibility(
                            visible: _isError,
                            child: const Text(
                              'Chưa chọn ngân hàng!',
                              style: TextStyle(
                                  color: AppColor.RED_TEXT, fontSize: 12),
                            ))
                        : const SizedBox.shrink(),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildMoneyinfo() {
    return Consumer<CreateQRProvider>(
      builder: (context, provider, child) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 350,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Số tiền',
                    style: TextStyle(fontSize: 15),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 350,
                    height: 40,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColor.GREY_DADADA),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _amountController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            onChanged: (value) {
                              String text = value.replaceAll(',', '');
                              setState(() {
                                amountInput = text;
                              });
                              if (text.isNotEmpty) {
                                final formatter = NumberFormat('#,###');

                                String newText =
                                    formatter.format(int.parse(text));
                                _amountController.value = TextEditingValue(
                                  text: newText,
                                  selection: TextSelection.collapsed(
                                      offset: newText.length),
                                );
                              }
                            },
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Nhập số tiền thanh toán",
                              hintStyle: TextStyle(color: AppColor.GREY_TEXT),
                              contentPadding: EdgeInsets.only(bottom: 8),
                            ),
                          ),
                        ),
                        const Text("VND"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 350,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nội dung ($contentLength/50)',
                    style: const TextStyle(fontSize: 15),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 350,
                    height: 40,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColor.GREY_DADADA),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          contentLength = value.length;
                        });
                      },
                      maxLength: 50,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      controller: _contentController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Nhập nội dung thanh toán",
                        hintStyle: TextStyle(color: AppColor.GREY_TEXT),
                        contentPadding: EdgeInsets.only(bottom: 8),
                        counterText: "",
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const SizedBox(
                    height: 15,
                    child: Text(
                      'Không dấu tiếng Việt, không chứa ký tự đặc biệt.',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildToggleOption() {
    return InkWell(
      onTap: () {
        _isExpanded = !_isExpanded;
        _amountController.clear;
        _contentController.clear();
        setState(() {});
      },
      child: Container(
        width: 350,
        height: 20,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _isExpanded ? "Đóng tuỳ chọn" : "Tuỳ chọn thêm",
              style: const TextStyle(color: AppColor.BLUE_TEXT),
            ),
            Icon(
              _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: AppColor.BLUE_TEXT,
            ),
          ],
        ),
      ),
    );
  }

  Widget _headerWidget() {
    return Container(
      padding: const EdgeInsets.fromLTRB(30, 15, 30, 10),
      width: MediaQuery.of(context).size.width * 0.22,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              "Tiện ích QR",
              style: TextStyle(fontSize: 15),
            ),
            Text(
              "/",
              style: TextStyle(fontSize: 15),
            ),
            Text(
              "Tạo mã VietQR",
              style: TextStyle(fontSize: 15),
            ),
          ]),
    );
  }

  Widget _buildOption(String title, bool isSelected) {
    return GestureDetector(
      onTap: () {
        _amountController.clear();
        _contentController.clear();
        isFirstSelected = !isFirstSelected;
        setState(() {});
      },
      child: Container(
        width: 150,
        height: 30,
        decoration: BoxDecoration(
          color:
              isSelected ? AppColor.BLUE_TEXT.withOpacity(0.3) : AppColor.WHITE,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(30),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? AppColor.BLUE_TEXT : AppColor.BLACK,
          ),
        ),
      ),
    );
  }
}
