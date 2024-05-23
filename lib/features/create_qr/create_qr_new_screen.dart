import 'package:VietQR/commons/widgets/button/m_button_icon_widget.dart';
import 'package:VietQR/commons/widgets/dot_dash_widget.dart';
import 'package:VietQR/features/create_qr/provider/create_qr_provider.dart';
import 'package:VietQR/features/create_qr/states/create_qr_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../commons/constants/configurations/theme.dart';
import '../../commons/utils/share_utils.dart';
import '../../commons/widgets/dashed_line.dart';
import '../../commons/widgets/m_button_widget.dart';
import '../../commons/widgets/repaint_boundary_widget.dart';
import '../../models/bank_account_dto.dart';
import '../../services/shared_references/session.dart';
import '../bank/blocs/bank_type_bloc.dart';
import '../bank/events/bank_type_event.dart';
import 'blocs/create_qr_bloc.dart';
import 'event/create_qr_event.dart';

class CreateQrNewScreen extends StatelessWidget {
  const CreateQrNewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CreateQRBloc>(
      create: (context) => CreateQRBloc(),
      child: _Screen(),
    );
  }
}

class _Screen extends StatefulWidget {
  const _Screen({super.key});

  @override
  State<_Screen> createState() => __ScreenState();
}

class __ScreenState extends State<_Screen> {
  final globalKey = GlobalKey();

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
  bool isFirstSelected = true;
  bool isEnableButton = false;
  List<BankAccountDTO> bankAccounts = [];

  late CreateQRBloc createQRBloc;
  late BankTypeBloc bankTypeBloc;
  FocusNode focusNodeWidget = FocusNode();

  @override
  void initState() {
    createQRBloc = CreateQRBloc()..add(GetListBankAccount());
    bankTypeBloc = BlocProvider.of(context);
    bankTypeBloc.add(const BankTypeEventGetListUnauthenticated());
    Session.instance.fetchAccountSetting();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    FocusScope.of(context).requestFocus(focusNodeWidget);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CreateQRProvider>(
      create: (context) => CreateQRProvider(),
      child: BlocProvider(
        create: (context) => CreateQRBloc(),
        child: BlocConsumer<CreateQRBloc, CreateQRState>(
          listener: (context, state) {
            if (state is GetListBankAccountSuccessfulState) {
              bankAccounts = state.list;
              // context
              //     .read<CreateQRProvider>()
              //     .updateBankAccountDto(bankAccounts.first);
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
                              Spacer(),
                              _buildCheckBox(),
                            ],
                          ),
                        ),
                        Expanded(child: _buildQrCode()),
                        _buildInfoTrans(),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfoTrans() {
    return Container(
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
                    'https://vietqr.vn/qr-generated?... dai oi la dai sieu dai',
                    style: TextStyle(color: AppColor.BLUE_TEXT, fontSize: 15),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                InkWell(
                  onTap: () {},
                  child: Tooltip(
                    message: 'Sao chép',
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: const Icon(
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
          Container(
            width: 350,
            height: 50,
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColor.GREY_DADADA, width: 1))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Mã đơn hàng:',
                  style: TextStyle(fontSize: 15),
                ),
                Text(
                  'BILL0001',
                  style: TextStyle(fontSize: 15),
                )
              ],
            ),
          ),
          Container(
            width: 350,
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Mã cửa hàng / điểm bán:',
                  style: TextStyle(fontSize: 15),
                ),
                Text(
                  'CH0001',
                  style: TextStyle(fontSize: 15),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQrCode() {
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

                                      // image: DecorationImage(
                                      //   image: ImageUtils.instance.getImageNetWork(
                                      //       widget.qrGeneratedDTO.imgId),
                                      // ),
                                      ),
                                ),
                                Container(
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
                                          'widget.qrGeneratedDTO.bankAccount,',
                                          maxLines: 1,
                                          style: TextStyle(
                                              color: AppColor.BLACK,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          'widget.qrGeneratedDTO.userBankName'
                                              .toUpperCase(),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
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
                                  data: '',
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
          Text(
            '+ 68,000 VND',
            style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: AppColor.ORANGE_DARK),
          ),
          const SizedBox(height: 20),
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
              'VQR39C21EDE26 Noi dung thanh toan giao dich 68k',
              style: TextStyle(fontSize: 18),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
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
                    onTap: () {},
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

  Widget _buildCheckBox() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
      height: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (isFirstSelected)
            Container(
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
                  Text("Hiển thị mã VietQR ở tab mới"),
                ],
              ),
            ),
          const SizedBox(height: 10),
          MButtonWidget(
            title: 'Tạo mã VietQR',
            isEnable: isEnableButton,
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                  'Ngân hàng thụ hưởng*',
                  style: TextStyle(fontSize: 15),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {},
                child: Container(
                  width: 350,
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      border: Border.all(color: AppColor.GREY_DADADA)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Chọn ngân hàng',
                          style: const TextStyle(
                              overflow: TextOverflow.ellipsis,
                              color: AppColor.GREY_TEXT,
                              fontSize: 15),
                        ),
                        const Icon(
                          Icons.keyboard_arrow_down,
                          size: 20,
                          color: AppColor.GREY_TEXT,
                        ),
                      ],
                    ),
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
                  // controller: _amountController,
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
          height: 90,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
                child: Text(
                  'Tên chủ tài khoản*',
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
                  // controller: _amountController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Nhập tên chủ tài khoản",
                    hintStyle: TextStyle(color: AppColor.GREY_TEXT),
                    contentPadding: EdgeInsets.only(bottom: 8),
                  ),
                ),
              ),
              const SizedBox(height: 5),
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
  }

  Widget _buildBankAccount() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                  'Tài khoản ngân hàng*',
                  style: TextStyle(fontSize: 15),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {},
                child: Container(
                  width: 350,
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      border: Border.all(color: AppColor.GREY_DADADA)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Chọn tại khoản ngân hàng',
                          style: const TextStyle(
                              overflow: TextOverflow.ellipsis,
                              color: AppColor.GREY_TEXT,
                              fontSize: 15),
                        ),
                        const Icon(
                          Icons.keyboard_arrow_down,
                          size: 20,
                          color: AppColor.GREY_TEXT,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _buildMoneyinfo(),
        // SizedBox(
        //   width: 350,
        //   height: 70,
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       const SizedBox(
        //         height: 20,
        //         child: Text(
        //           'Số tiền',
        //           style: TextStyle(fontSize: 15),
        //         ),
        //       ),
        //       const SizedBox(
        //         height: 10,
        //       ),
        //       Container(
        //         width: 350,
        //         height: 40,
        //         decoration: BoxDecoration(
        //           border: Border.all(color: AppColor.GREY_DADADA),
        //           borderRadius: BorderRadius.circular(5),
        //         ),
        //         padding: const EdgeInsets.symmetric(horizontal: 10),
        //         child: Row(
        //           children: [
        //             Expanded(
        //               child: TextField(
        //                 // controller: _amountController,
        //                 decoration: const InputDecoration(
        //                   border: InputBorder.none,
        //                   hintText: "Nhập số tiền thanh toán",
        //                   hintStyle: TextStyle(color: AppColor.GREY_TEXT),
        //                   contentPadding: EdgeInsets.only(bottom: 8),
        //                 ),
        //               ),
        //             ),
        //             const Text("VND"),
        //           ],
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        // const SizedBox(height: 20),
        // SizedBox(
        //   width: 350,
        //   height: 90,
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       const SizedBox(
        //         height: 20,
        //         child: Text(
        //           'Nội dung (0/50)',
        //           style: TextStyle(fontSize: 15),
        //         ),
        //       ),
        //       const SizedBox(
        //         height: 10,
        //       ),
        //       Container(
        //         width: 350,
        //         height: 40,
        //         decoration: BoxDecoration(
        //           border: Border.all(color: AppColor.GREY_DADADA),
        //           borderRadius: BorderRadius.circular(5),
        //         ),
        //         padding: const EdgeInsets.symmetric(horizontal: 10),
        //         child: TextField(
        //           // controller: _amountController,
        //           decoration: const InputDecoration(
        //             border: InputBorder.none,
        //             hintText: "Nhập nội dung thanh toán",
        //             hintStyle: TextStyle(color: AppColor.GREY_TEXT),
        //             contentPadding: EdgeInsets.only(bottom: 8),
        //             counterText: "",
        //           ),
        //           maxLength: 50,
        //         ),
        //       ),
        //       const SizedBox(height: 5),
        //       const SizedBox(
        //         height: 15,
        //         child: Text(
        //           'Không dấu tiếng Việt, không chứa ký tự đặc biệt.',
        //           style: TextStyle(fontSize: 13),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        const SizedBox(height: 20),
        _buildToggleOption(),
        const SizedBox(height: 20),
        if (_isExpanded)
          SizedBox(
            width: 350,
            height: 180,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 350,
                  height: 90,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                        child: Text(
                          'Mã đơn hàng (0/13 ký tự)',
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
                          // controller: _amountController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Nhập mã hoá đơn",
                            hintStyle: TextStyle(color: AppColor.GREY_TEXT),
                            contentPadding: EdgeInsets.only(bottom: 8),
                            counterText: "",
                          ),
                          maxLength: 13,
                        ),
                      ),
                      const SizedBox(height: 5),
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
                  height: 70,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                        child: Text(
                          'Mã cửa hàng / điểm bán',
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
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                // controller: _amountController,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Nhập hoặc chọn mã cửa hàng",
                                  hintStyle:
                                      TextStyle(color: AppColor.GREY_TEXT),
                                  contentPadding: EdgeInsets.only(bottom: 8),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {},
                              child: Icon(
                                Icons.keyboard_arrow_down,
                                size: 20,
                                color: AppColor.GREY_TEXT,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildMoneyinfo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                  'Số tiền',
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
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        // controller: _amountController,
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
          height: 90,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
                child: Text(
                  'Nội dung (0/50)',
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
                  // controller: _amountController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Nhập nội dung thanh toán",
                    hintStyle: TextStyle(color: AppColor.GREY_TEXT),
                    contentPadding: EdgeInsets.only(bottom: 8),
                    counterText: "",
                  ),
                  maxLength: 50,
                ),
              ),
              const SizedBox(height: 5),
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
  }

  Widget _buildToggleOption() {
    return InkWell(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: Container(
        width: 350,
        height: 20,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _isExpanded ? "Đóng tuỳ chọn" : "Tuỳ chọn thêm",
              style: TextStyle(color: AppColor.BLUE_TEXT),
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
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        const Text(
          "Tiện ích QR",
          style: TextStyle(fontSize: 15),
        ),
        const Text(
          "/",
          style: TextStyle(fontSize: 15),
        ),
        const Text(
          "Tạo mã VietQR",
          style: TextStyle(fontSize: 15),
        ),
      ]),
    );
  }

  Widget _buildOption(String title, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isFirstSelected = !isFirstSelected;
        });
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
