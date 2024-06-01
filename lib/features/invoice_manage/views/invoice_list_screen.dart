import 'package:VietQR/features/invoice_manage/views/popup_qr_widget.dart';
import 'package:VietQR/features/invoice_manage/views/title_invoice_widget.dart';
import 'package:flutter/material.dart';

import '../../../commons/constants/configurations/theme.dart';
import '../../../commons/utils/custom_scroll.dart';
import '../../../commons/widgets/dot_dash_widget.dart';
import '../../../layouts/box_layout.dart';
import '../../../main.dart';
import '../../transaction/widgets/dialog_pick_date.dart';
import 'item_invoice_widget.dart';

class InvoiceListScreen extends StatelessWidget {
  const InvoiceListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _Screen();
  }
}

class _Screen extends StatefulWidget {
  const _Screen({super.key});

  @override
  State<_Screen> createState() => _ScreenState();
}

class _ScreenState extends State<_Screen> {
  final controller1 = ScrollController();
  final controller2 = ScrollController();
  int? type = 9;
  DateTime? selectDate;
  bool isFirstSelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.BLUE_BGR,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
            color: AppColor.WHITE,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _headerWidget(),
            const Divider(
              color: AppColor.GREY_DADADA,
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        "Tìm kiếm thông tin hoá đơn ",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 30),
                      _buildOption("Chưa thanh toán", isFirstSelected),
                      const SizedBox(width: 20),
                      _buildOption("Đã thanh toán", !isFirstSelected),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _filterWidget(),
                  const SizedBox(height: 20),
                  const MySeparator(
                    color: AppColor.GREY_DADADA,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Danh sách hoá đơn",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            _buildListInvoice(),
            const SizedBox(height: 10),
            // _pagingWidget(),
            // const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(String title, bool isSelected) {
    return GestureDetector(
      onTap: () {
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

  Widget buildItemList() {
    return ItemInvoiceWidget();
  }

  Widget _buildListInvoice() {
    return Expanded(
      child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width - 220,
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Scrollbar(
                    controller: controller1,
                    child: SingleChildScrollView(
                      controller: controller1,
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        width: 1570,
                        child: Column(
                          children: [
                            const TitleItemInvoiceWidget(),
                            buildItemList(),
                            buildItemList(),
                            buildItemList(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 1570,
                  child: Row(
                    children: [
                      const Expanded(child: SizedBox()),
                      SingleChildScrollView(
                        controller: controller2,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColor.WHITE,
                              boxShadow: [
                                BoxShadow(
                                    color:
                                        AppColor.GREY_BORDER.withOpacity(0.8),
                                    blurRadius: 5,
                                    spreadRadius: 1,
                                    offset: const Offset(0, 0)),
                              ],
                            ),
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color:
                                          AppColor.BLUE_TEXT.withOpacity(0.3)),
                                  child: Row(
                                    children: [
                                      Container(
                                          height: 50,
                                          width: 120,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: AppColor.GREY_TEXT
                                                      .withOpacity(0.3))),
                                          child: const Text(
                                            'Trạng thái',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: AppColor.BLACK,
                                                fontWeight: FontWeight.bold),
                                          )),
                                      Container(
                                          height: 50,
                                          width: 140,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: AppColor.GREY_TEXT
                                                      .withOpacity(0.3))),
                                          child: const Text(
                                            'Thao tác',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: AppColor.BLACK,
                                                fontWeight: FontWeight.bold),
                                          )),
                                    ],
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  child: Row(
                                    children: [
                                      Container(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            border: Border(
                                                left: BorderSide(
                                                    color: AppColor.GREY_TEXT
                                                        .withOpacity(0.3)),
                                                bottom: BorderSide(
                                                    color: AppColor.GREY_TEXT
                                                        .withOpacity(0.3)),
                                                right: BorderSide(
                                                    color: AppColor.GREY_TEXT
                                                        .withOpacity(0.3)))),
                                        height: 50,
                                        width: 120,
                                        child: SelectionArea(
                                            child: Text(
                                          'cho thanh toan',
                                          // e.status == 0
                                          //     ? 'Chờ thanh toán'
                                          //     : e.status == 1
                                          //         ? 'Đã thanh toán'
                                          //         : 'Khoản thu lệch',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 12,
                                            // color: e.status == 0
                                            //     ? AppColor.ORANGE_DARK
                                            //     : e.status == 1
                                            //         ? AppColor.GREEN
                                            //         : AppColor.GREEN_STATUS,
                                          ),
                                        )),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        alignment: Alignment.centerLeft,
                                        decoration: BoxDecoration(
                                            border: Border(
                                                left: BorderSide(
                                                    color: AppColor.GREY_TEXT
                                                        .withOpacity(0.3)),
                                                bottom: BorderSide(
                                                    color: AppColor.GREY_TEXT
                                                        .withOpacity(0.3)),
                                                right: BorderSide(
                                                    color: AppColor.GREY_TEXT
                                                        .withOpacity(0.3)))),
                                        height: 50,
                                        width: 140,
                                        child: SelectionArea(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Visibility(
                                                // visible: e.status == 0,
                                                child: Tooltip(
                                                  message: 'Mã QR',
                                                  child: InkWell(
                                                    onTap: () {
                                                      onShowPopup();
                                                    },
                                                    child: BoxLayout(
                                                      width: 30,
                                                      height: 30,
                                                      borderRadius: 100,
                                                      alignment:
                                                          Alignment.center,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              0),
                                                      bgColor: AppColor
                                                          .BLUE_TEXT
                                                          .withOpacity(0.3),
                                                      child: const Icon(
                                                        Icons.qr_code,
                                                        size: 12,
                                                        color:
                                                            AppColor.BLUE_TEXT,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Visibility(
                                                // visible: e.status == 0,
                                                child:
                                                    const SizedBox(width: 10),
                                              ),
                                              Tooltip(
                                                message: 'Thông tin hoá đơn',
                                                child: InkWell(
                                                  onTap: () {
                                                    // setState(() {
                                                    //   selectInvoiceId =
                                                    //       e.invoiceId;
                                                    //   // pageType =
                                                    //   //     PageInvoice.DETAIL;
                                                    // });
                                                    // _model.onChangePage(
                                                    //     PageInvoice
                                                    //         .DETAIL);
                                                  },
                                                  child: BoxLayout(
                                                    width: 30,
                                                    height: 30,
                                                    borderRadius: 100,
                                                    alignment: Alignment.center,
                                                    padding:
                                                        const EdgeInsets.all(0),
                                                    bgColor: AppColor.BLUE_TEXT
                                                        .withOpacity(0.3),
                                                    child: const Icon(
                                                      Icons.info,
                                                      size: 12,
                                                      color: AppColor.BLUE_TEXT,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Tooltip(
                                                message: 'Xuất Excel',
                                                child: InkWell(
                                                  onTap: () {
                                                    // onShowPopupExcel();
                                                    // DialogWidget
                                                    //     .instance
                                                    //     .openMsgDialog(
                                                    //         title:
                                                    //             'Bảo trì',
                                                    //         msg:
                                                    //             'Chúng tôi đang bảo trì tính năng này trong khoảng 2-3 ngày để mang lại trải nghiệm tốt nhất cho người dùng. Cảm ơn quý khách đã sử dụng dịch vụ của chúng tôi.');
                                                  },
                                                  child: BoxLayout(
                                                    width: 30,
                                                    height: 30,
                                                    borderRadius: 100,
                                                    alignment: Alignment.center,
                                                    padding:
                                                        const EdgeInsets.all(0),
                                                    bgColor: AppColor.BLUE_TEXT
                                                        .withOpacity(0.3),
                                                    child: const Icon(
                                                      Icons.list,
                                                      size: 12,
                                                      color: AppColor.BLUE_TEXT,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // ...list.map(
                                //   (e) {
                                // return Container(
                                //   alignment: Alignment.center,
                                //   child: Row(
                                //     children: [
                                //       Container(
                                //         padding: const EdgeInsets.only(
                                //             right: 10),
                                //         alignment: Alignment.center,
                                //         decoration: BoxDecoration(
                                //             border: Border(
                                //                 left: BorderSide(
                                //                     color: AppColor
                                //                         .GREY_TEXT
                                //                         .withOpacity(0.3)),
                                //                 bottom: BorderSide(
                                //                     color: AppColor
                                //                         .GREY_TEXT
                                //                         .withOpacity(0.3)),
                                //                 right: BorderSide(
                                //                     color: AppColor
                                //                         .GREY_TEXT
                                //                         .withOpacity(
                                //                             0.3)))),
                                //         height: 50,
                                //         width: 120,
                                //         child: SelectionArea(
                                //             child: Text(
                                //           e.status == 0
                                //               ? 'Chờ thanh toán'
                                //               : e.status == 1
                                //                   ? 'Đã thanh toán'
                                //                   : 'Khoản thu lệch',
                                //           textAlign: TextAlign.center,
                                //           style: TextStyle(
                                //             fontSize: 12,
                                //             color: e.status == 0
                                //                 ? AppColor.ORANGE_DARK
                                //                 : e.status == 1
                                //                     ? AppColor.GREEN
                                //                     : AppColor.GREEN_STATUS,
                                //           ),
                                //         )),
                                //       ),
                                //       Container(
                                //         padding: const EdgeInsets.symmetric(
                                //             horizontal: 8),
                                //         alignment: Alignment.centerLeft,
                                //         decoration: BoxDecoration(
                                //             border: Border(
                                //                 left: BorderSide(
                                //                     color: AppColor
                                //                         .GREY_TEXT
                                //                         .withOpacity(0.3)),
                                //                 bottom: BorderSide(
                                //                     color: AppColor
                                //                         .GREY_TEXT
                                //                         .withOpacity(0.3)),
                                //                 right: BorderSide(
                                //                     color: AppColor
                                //                         .GREY_TEXT
                                //                         .withOpacity(
                                //                             0.3)))),
                                //         height: 50,
                                //         width: 120,
                                //         child: SelectionArea(
                                //           child: Row(
                                //             children: [
                                //               Visibility(
                                //                 visible: e.status == 0,
                                //                 child: Tooltip(
                                //                   message: 'Mã QR',
                                //                   child: InkWell(
                                //                     onTap: () {
                                //                       // onShowPopup(e);
                                //                     },
                                //                     child: BoxLayout(
                                //                       width: 30,
                                //                       height: 30,
                                //                       borderRadius: 100,
                                //                       alignment:
                                //                           Alignment.center,
                                //                       padding:
                                //                           const EdgeInsets
                                //                               .all(0),
                                //                       bgColor: AppColor
                                //                           .BLUE_TEXT
                                //                           .withOpacity(0.3),
                                //                       child: const Icon(
                                //                         Icons.qr_code,
                                //                         size: 12,
                                //                         color: AppColor
                                //                             .BLUE_TEXT,
                                //                       ),
                                //                     ),
                                //                   ),
                                //                 ),
                                //               ),
                                //               Visibility(
                                //                 visible: e.status == 0,
                                //                 child: const SizedBox(
                                //                     width: 10),
                                //               ),
                                //               Tooltip(
                                //                 message:
                                //                     'Thông tin hoá đơn',
                                //                 child: InkWell(
                                //                   onTap: () {
                                //                     // setState(() {
                                //                     //   selectInvoiceId =
                                //                     //       e.invoiceId;
                                //                     //   // pageType =
                                //                     //   //     PageInvoice.DETAIL;
                                //                     // });
                                //                     // _model.onChangePage(
                                //                     //     PageInvoice
                                //                     //         .DETAIL);
                                //                   },
                                //                   child: BoxLayout(
                                //                     width: 30,
                                //                     height: 30,
                                //                     borderRadius: 100,
                                //                     alignment:
                                //                         Alignment.center,
                                //                     padding:
                                //                         const EdgeInsets
                                //                             .all(0),
                                //                     bgColor: AppColor
                                //                         .BLUE_TEXT
                                //                         .withOpacity(0.3),
                                //                     child: const Icon(
                                //                       Icons.info,
                                //                       size: 12,
                                //                       color: AppColor
                                //                           .BLUE_TEXT,
                                //                     ),
                                //                   ),
                                //                 ),
                                //               ),
                                //               Visibility(
                                //                 visible: e.status == 0,
                                //                 child: const SizedBox(
                                //                     width: 10),
                                //               ),
                                //               Visibility(
                                //                 visible: e.status == 0,
                                //                 child: Tooltip(
                                //                   message: 'Chỉnh sửa',
                                //                   child: InkWell(
                                //                     onTap: () {
                                //                       // setState(() {
                                //                       //   selectInvoiceId =
                                //                       //       e.invoiceId;
                                //                       //   // pageType =
                                //                       //   //     PageInvoice.EDIT;
                                //                       // });
                                //                       // _model.onChangePage(
                                //                       //     PageInvoice
                                //                       //         .EDIT);
                                //                     },
                                //                     child: BoxLayout(
                                //                       width: 30,
                                //                       height: 30,
                                //                       borderRadius: 100,
                                //                       alignment:
                                //                           Alignment.center,
                                //                       padding:
                                //                           const EdgeInsets
                                //                               .all(0),
                                //                       bgColor: AppColor
                                //                           .BLUE_TEXT
                                //                           .withOpacity(0.3),
                                //                       child: const Icon(
                                //                         Icons.edit,
                                //                         size: 12,
                                //                         color: AppColor
                                //                             .BLUE_TEXT,
                                //                       ),
                                //                     ),
                                //                   ),
                                //                 ),
                                //               ),
                                //               const SizedBox(width: 10),
                                //               Tooltip(
                                //                 message: 'Xuất Excel',
                                //                 child: InkWell(
                                //                   onTap: () {
                                //                     // onShowPopupExcel();
                                //                     // DialogWidget
                                //                     //     .instance
                                //                     //     .openMsgDialog(
                                //                     //         title:
                                //                     //             'Bảo trì',
                                //                     //         msg:
                                //                     //             'Chúng tôi đang bảo trì tính năng này trong khoảng 2-3 ngày để mang lại trải nghiệm tốt nhất cho người dùng. Cảm ơn quý khách đã sử dụng dịch vụ của chúng tôi.');
                                //                   },
                                //                   child: BoxLayout(
                                //                     width: 30,
                                //                     height: 30,
                                //                     borderRadius: 100,
                                //                     alignment:
                                //                         Alignment.center,
                                //                     padding:
                                //                         const EdgeInsets
                                //                             .all(0),
                                //                     bgColor: AppColor
                                //                         .BLUE_TEXT
                                //                         .withOpacity(0.3),
                                //                     child: const Icon(
                                //                       Icons.list,
                                //                       size: 12,
                                //                       color: AppColor
                                //                           .BLUE_TEXT,
                                //                     ),
                                //                   ),
                                //                 ),
                                //               ),
                                //               const SizedBox(width: 10),
                                //               Tooltip(
                                //                 message: 'Xoá',
                                //                 child: InkWell(
                                //                   onTap: () {
                                //                     // DialogWidget
                                //                     //     .instance
                                //                     //     .openMsgDialogQuestion(
                                //                     //   title: "Hóa đơn",
                                //                     //   msg:
                                //                     //       'Xác nhận xóa hóa đơn!!',
                                //                     //   onConfirm:
                                //                     //       () async {
                                //                     //     Navigator.of(
                                //                     //             context)
                                //                     //         .pop();
                                //                     //     bool? result =
                                //                     //         await model
                                //                     //             .deleteInvoice(
                                //                     //                 e.invoiceId);
                                //                     //     if (result!) {
                                //                     //       model.filterListInvoice(
                                //                     //           time:
                                //                     //               selectDate!,
                                //                     //           page: 1,
                                //                     //           filter:
                                //                     //               textInput()!);
                                //                     //     }
                                //                     //   },
                                //                     // );

                                //                     //
                                //                     // DialogWidget
                                //                     //     .instance
                                //                     //     .openMsgDialog(
                                //                     //         title: 'Bảo trì',
                                //                     //         msg: 'Chúng tôi đang bảo trì tính năng này trong khoảng 2-3 ngày để mang lại trải nghiệm tốt nhất cho người dùng. Cảm ơn quý khách đã sử dụng dịch vụ của chúng tôi.');
                                //                   },
                                //                   child: BoxLayout(
                                //                     width: 30,
                                //                     height: 30,
                                //                     borderRadius: 100,
                                //                     alignment:
                                //                         Alignment.center,
                                //                     padding:
                                //                         const EdgeInsets
                                //                             .all(0),
                                //                     bgColor: AppColor
                                //                         .RED_TEXT
                                //                         .withOpacity(0.3),
                                //                     child: const Icon(
                                //                       Icons.delete_forever,
                                //                       size: 12,
                                //                       color:
                                //                           AppColor.RED_TEXT,
                                //                     ),
                                //                   ),
                                //                 ),
                                //               ),
                                //             ],
                                //           ),
                                //         ),
                                //       ),
                                //     ],
                                //   ),
                                // );
                                // },
                                // )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }

  void onShowPopup() async {
    return await showDialog(
      context: context,
      builder: (context) => PopupQrCodeInvoice(),
    );
  }

  Widget _filterWidget() {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Tìm kiếm theo",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
            ),
            const SizedBox(height: 10),
            Container(
              height: 40,
              width: type == 9 ? 250 : 500,
              padding: const EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColor.GREY_DADADA)),
              child: Row(
                children: [
                  SizedBox(
                    height: 40,
                    width: 220,
                    child: DropdownButton<int>(
                      isExpanded: true,
                      value: type,
                      underline: const SizedBox.shrink(),
                      icon: const RotatedBox(
                        quarterTurns: 5,
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 12,
                        ),
                      ),
                      items: const [
                        DropdownMenuItem<int>(
                            value: 9,
                            child: Text(
                              "Tất cả (mặc định)",
                            )),
                        DropdownMenuItem<int>(
                            value: 2,
                            child: Text(
                              "TK ngân hàng",
                            )),
                      ],
                      onChanged: (value) {
                        setState(() {
                          type = value;
                        });
                        // model.changeTypeInvoice(value);
                      },
                    ),
                  ),
                  if (type == 2)
                    Expanded(
                      child: Row(
                        children: [
                          const SizedBox(width: 8),
                          const SizedBox(
                            height: 40,
                            child: VerticalDivider(
                              thickness: 1,
                              color: AppColor.GREY_DADADA,
                            ),
                          ),
                          SizedBox(
                            width: 234,
                            // padding: const EdgeInsets.symmetric(
                            //     horizontal: 10),
                            child: TextField(
                              // controller: _bankController,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.only(bottom: 8),

                                // contentPadding:
                                //     EdgeInsets.only(bottom: 0),
                                border: InputBorder.none,
                                hintText: 'Nhập số TK ngân hàng',
                                hintStyle: TextStyle(
                                    fontSize: 15, color: AppColor.GREY_TEXT),
                              ),
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
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Thời gian",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
            ),
            const SizedBox(height: 10),
            Container(
              width: 300,
              padding: const EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColor.GREY_DADADA)),
              child: Row(
                children: [
                  const SizedBox(
                    width: 60,
                    child: Center(
                      child: Text('Tháng'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const SizedBox(
                    height: 40,
                    child: VerticalDivider(
                      thickness: 1,
                      color: AppColor.GREY_DADADA,
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        _onPickMonth(getMonth());
                      },
                      child: Container(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              (selectDate == null
                                  ? '${getMonth().month}/${getMonth().year}'
                                  : '${selectDate?.month}/${selectDate?.year}'),
                              style: const TextStyle(fontSize: 15),
                            ),
                            const Icon(Icons.calendar_month_outlined)
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(width: 30),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Thời gian",
              style: TextStyle(fontSize: 15, color: AppColor.WHITE),
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () {},
              child: Container(
                height: 40,
                width: 150,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColor.BLUE_TEXT,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.search,
                      size: 15,
                      color: AppColor.WHITE,
                    ),
                    SizedBox(width: 8),
                    Text(
                      "Tìm kiếm",
                      style: TextStyle(color: AppColor.WHITE, fontSize: 15),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _headerWidget() {
    return Container(
      padding: const EdgeInsets.fromLTRB(30, 15, 30, 10),
      // width: MediaQuery.of(context).size.width,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Quản lý hoá đơn",
            style: TextStyle(fontSize: 15),
          ),
          Text(
            "   /   ",
            style: TextStyle(fontSize: 15),
          ),
          Text(
            " Danh sách hoá đơn",
            style: TextStyle(fontSize: 15),
          ),
        ],
      ),
    );
  }

  void _onPickMonth(DateTime dateTime) async {
    DateTime? result = await showDialog(
      barrierDismissible: false,
      context: NavigationService.navigatorKey.currentContext!,
      builder: (BuildContext context) {
        return Material(
          color: AppColor.TRANSPARENT,
          child: Center(
            child: DialogPickDate(
              dateTime: dateTime,
            ),
          ),
        );
      },
    );
    if (result != null) {
      setState(() {
        selectDate = result;
      });
      // _model.filterListInvoice(
      //     time: selectDate!, page: 1, filter: textInput()!);
    }
    // else {
    //   selectDate = _model.getMonth();
    // }
  }

  DateTime getMonth() {
    DateTime now = DateTime.now();
    int newMonth = now.month;
    int newYear = now.year;

    if (newMonth < 1) {
      newMonth = 12; // Set month to December
      newYear--; // Decrement year
    }

    return DateTime(newYear, newMonth);
  }

  DateTime getPreviousMonth() {
    DateTime now = DateTime.now();
    int newMonth = now.month - 1;
    int newYear = now.year;

    if (newMonth < 1) {
      newMonth = 12; // Set month to December
      newYear--; // Decrement year
    }

    return DateTime(newYear, newMonth);
  }

  // Widget _pagingWidget() {
  //   return ScopedModelDescendant<InvoiceViewModel>(
  //     builder: (context, child, model) {
  //       bool isPaging = false;
  //       if (model.status == ViewStatus.Loading ||
  //           model.status == ViewStatus.Error) {
  //         return const SizedBox.shrink();
  //       }

  //       MetaDataDTO paging = model.metadata!;
  //       if (paging.page! != paging.totalPage!) {
  //         isPaging = true;
  //       }

  //       return paging != null
  //           ? Padding(
  //               padding: const EdgeInsets.only(left: 30),
  //               child: Row(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Container(
  //                     padding: const EdgeInsets.all(4),
  //                     child: Text(
  //                       "Trang ${paging.page}/${paging.totalPage}",
  //                       style: const TextStyle(fontSize: 15),
  //                     ),
  //                   ),
  //                   const SizedBox(width: 30),
  //                   InkWell(
  //                     onTap: () async {
  //                       if (paging.page != 1) {
  //                         await model.filterListInvoice(
  //                           time: selectDate!,
  //                           page: paging.page! - 1,
  //                           filter: textInput()!,
  //                         );
  //                       }
  //                     },
  //                     child: Container(
  //                       padding: const EdgeInsets.all(4),
  //                       decoration: BoxDecoration(
  //                           borderRadius: BorderRadius.circular(100),
  //                           border: Border.all(
  //                               color: paging.page != 1
  //                                   ? AppColor.BLACK
  //                                   : AppColor.GREY_DADADA)),
  //                       child: Center(
  //                         child: Icon(
  //                           Icons.chevron_left_rounded,
  //                           color: paging.page != 1
  //                               ? AppColor.BLACK
  //                               : AppColor.GREY_DADADA,
  //                           size: 20,
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                   const SizedBox(width: 15),
  //                   InkWell(
  //                     onTap: () async {
  //                       if (isPaging) {
  //                         await model.filterListInvoice(
  //                           time: selectDate!,
  //                           page: paging.page! + 1,
  //                           filter: textInput()!,
  //                         );
  //                       }
  //                     },
  //                     child: Container(
  //                       padding: const EdgeInsets.all(4),
  //                       decoration: BoxDecoration(
  //                           borderRadius: BorderRadius.circular(100),
  //                           border: Border.all(
  //                               color: isPaging
  //                                   ? AppColor.BLACK
  //                                   : AppColor.GREY_DADADA)),
  //                       child: Center(
  //                         child: Icon(
  //                           Icons.chevron_right_rounded,
  //                           color: isPaging
  //                               ? AppColor.BLACK
  //                               : AppColor.GREY_DADADA,
  //                           size: 20,
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             )
  //           : const SizedBox.shrink();
  //     },
  //   );
  // }
}
