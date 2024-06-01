import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../commons/constants/configurations/theme.dart';
import '../../../commons/utils/share_utils.dart';
import '../../../commons/widgets/dot_dash_widget.dart';
import '../../../commons/widgets/m_button_widget.dart';
import '../../../commons/widgets/repaint_boundary_widget.dart';

class PopupQrCodeInvoice extends StatefulWidget {
  const PopupQrCodeInvoice({
    super.key,
  });

  @override
  State<PopupQrCodeInvoice> createState() => _PopupQrCodeInvoiceState();
}

class _PopupQrCodeInvoiceState extends State<PopupQrCodeInvoice> {
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

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColor.TRANSPARENT,
      child: Center(
        child: Container(
          color: AppColor.WHITE,
          width: 1200,
          height: 750,
          child: Column(
            children: [
              Container(
                width: 1200,
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Mã VietQR hoá đơn thanh toán',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const Icon(
                        Icons.close,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 500,
                    height: 690,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 50),
                    decoration: const BoxDecoration(
                        color: AppColor.WHITE,
                        border: Border(
                            right: BorderSide(
                                color: AppColor.GREY_DADADA, width: 1))),
                    child: Column(
                      children: [
                        RepaintBoundaryWidget(
                            globalKey: globalKey,
                            builder: (key) {
                              return Container(
                                width: 400,
                                height: 400,
                                decoration: BoxDecoration(
                                  image: const DecorationImage(
                                      image: AssetImage(
                                          'assets/images/bg-qr-vqr.png'),
                                      fit: BoxFit.cover),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Container(
                                    width: 320,
                                    height: 320,
                                    padding: const EdgeInsets.fromLTRB(
                                        30, 20, 30, 10),
                                    decoration: BoxDecoration(
                                      color: AppColor.WHITE,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 240,
                                          height: 240,
                                          // color: AppColor.GREY_DADADA,
                                          child: QrImageView(
                                            data: '',
                                            size: 220,
                                            version: QrVersions.auto,
                                            embeddedImage: const AssetImage(
                                                'assets/images/ic-viet-qr.png'),
                                            embeddedImageStyle:
                                                QrEmbeddedImageStyle(
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
                                                padding: const EdgeInsets.only(
                                                    left: 8),
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
                                ),
                              );
                            }),
                        const SizedBox(
                          height: 140,
                        ),
                        MButtonWidget(
                          onTap: () {
                            onSaveImage(
                              context,
                            );
                          },
                          title: 'Lưu ảnh QR',
                          isEnable: true,
                          margin: EdgeInsets.zero,
                          width: 400,
                          colorEnableBgr: AppColor.WHITE,
                          colorEnableText: AppColor.BLUE_TEXT,
                          border: Border.all(color: AppColor.BLUE_TEXT),
                          radius: 100,
                          height: 50,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 660,
                    height: 690,
                    color: AppColor.WHITE,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 660,
                          height: 70,
                          child: Text(
                            // widget.dto.invoiceName,
                            // model.detailQrDTO!.invoiceName,
                            'Hoá đơn thu phí dịch vụ phần mềm VietQR tháng 03-04/2024 Hoá đơn thu phí dịch vụ phần mềm VietQR tháng 03-04/2024 Hoá đơn thu phí dịch vụ phần mềm VietQR tháng 03-04/2024',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 25),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 40,
                          child: Text(
                            '324,000 VND',
                            // StringUtils.formatNumber(
                            //     model.detailQrDTO?.totalAmountAfterVat),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                                color: AppColor.ORANGE),
                          ),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        _buildItem(
                            'Mã hoá đơn', 'model.detailQrDTO!.invoiceNumber'),
                        _buildItem('Tài khoản ngân hàng',
                            'nasdnasdn - 28391239- anjsdnjasd'),
                        _buildItem('Tổng tiền', '128391239'),
                        _buildItem('Tiền thuế GTGT (VAT)', '18239'),
                        _buildItem('Tổng tiền thanh toán', '38192381'),
                        const Spacer(),
                        Center(
                          child: MButtonWidget(
                            onTap: () {},
                            title: 'Chi tiết hoá đơn',
                            isEnable: true,
                            margin: EdgeInsets.only(bottom: 50),
                            width: 400,
                            border: Border.all(color: AppColor.BLUE_TEXT),
                            height: 50,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItem(String leftText, String rightText) {
    TextStyle defaultStyle = const TextStyle(fontSize: 15);
    TextStyle boldStyle =
        const TextStyle(fontSize: 15, fontWeight: FontWeight.bold);
    return SizedBox(
      width: 660,
      height: 60,
      child: Column(
        children: [
          SizedBox(
            width: 660,
            height: 59,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  leftText,
                  style: defaultStyle,
                ),
                const SizedBox(width: 40),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Text(
                      rightText,
                      style: leftText == 'Tổng tiền thanh toán'
                          ? boldStyle
                          : defaultStyle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const MySeparator(
            color: AppColor.GREY_DADADA,
          ),
        ],
      ),
    );
  }
}
