import 'package:VietQR/commons/constants/configurations/app_image.dart';
import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/currency_utils.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/commons/widgets/button_widget.dart';
import 'package:VietQR/models/transaction/terminal_qr_dto.dart';
import 'package:VietQR/models/transaction/trans_receive_dto.dart';
import 'package:flutter/material.dart';

class DialogChooseTerminalWidget extends StatefulWidget {
  final List<TerminalQRDTO> terminals;
  final Function(String) update;
  final TransReceiveDTO transDTO;

  const DialogChooseTerminalWidget(
      {super.key,
      required this.terminals,
      required this.update,
      required this.transDTO});

  @override
  State<DialogChooseTerminalWidget> createState() =>
      _DialogChooseTerminalWidgetState();
}

class _DialogChooseTerminalWidgetState
    extends State<DialogChooseTerminalWidget> {
  List<TerminalQRDTO> terminals = [];
  TerminalQRDTO _dto = TerminalQRDTO();
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    terminals = [...widget.terminals];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColor.TRANSPARENT,
      child: Center(
        child: Container(
          width: 600,
          height: 550,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              _buildTabWidget(),
              _buildBodyMain(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBodyMain() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Cập nhật điểm bán',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close, size: 18),
                )
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 300,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Thông tin giao dịch',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildItemInfo(
                                title: 'Số tiền:',
                                content:
                                    '${widget.transDTO.statusAmount} ${CurrencyUtils.instance.getCurrencyFormatted(widget.transDTO.amount)} ',
                                textColor: AppColor.BLUE_TEXT,
                                fontSize: 12,
                                fontWeight: FontWeight.w600),
                            const SizedBox(height: 12),
                            _buildItemInfo(
                                title: 'Mã giao dịch',
                                content: widget.transDTO.referenceNumber),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildItemInfo(
                                title: 'Thời gian TT:',
                                content: widget.transDTO.timePaymentEditNote),
                            const SizedBox(height: 12),
                            _buildItemInfo(
                                title: 'Tk nhận:',
                                content: widget.transDTO.bankAccount),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: SizedBox(
                width: 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Mã điểm bán',
                      style:
                          TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 34,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColor.GREY_BORDER),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: TextField(
                        style: const TextStyle(fontSize: 12),
                        onChanged: onSearch,
                        maxLength: 10,
                        controller: _searchController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          counterText: '',
                          contentPadding:
                              EdgeInsets.only(left: 12, right: 12, bottom: 16),
                          hintText:
                              'Nhập mã điểm bán hoặc chọn cửa hàng bên dưới',
                          hintStyle: TextStyle(
                              fontSize: 10, color: AppColor.GREY_TEXT),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Danh sách cửa hàng',
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 12),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children:
                                    List.generate(terminals.length, (index) {
                                  TerminalQRDTO dto = terminals[index];
                                  return GestureDetector(
                                    onTap: () {
                                      _dto = dto;
                                      _searchController.text = dto.terminalCode;
                                      setState(() {});
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 12),
                                      decoration: BoxDecoration(
                                          color:
                                              dto.terminalId == _dto.terminalId
                                                  ? AppColor.BLUE_TEXT
                                                      .withOpacity(0.25)
                                                  : null),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    dto.terminalName,
                                                    style: const TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    dto.terminalCode,
                                                    style: const TextStyle(
                                                        fontSize: 10,
                                                        color:
                                                            AppColor.GREY_TEXT),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        ButtonWidget(
                          text: 'Cập nhật',
                          width: 100,
                          textColor: AppColor.WHITE,
                          bgColor: AppColor.BLUE_TEXT,
                          textSize: 10,
                          function: () {
                            if (_searchController.text.isNotEmpty) {
                              widget.update.call(_searchController.text);
                            } else {
                              Navigator.pop(context);
                            }
                          },
                          borderRadius: 5,
                          height: 30,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.horizontal(left: Radius.circular(16)),
        color: AppColor.BLUE_BGR,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Text('Cập nhật GD',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Column(
              children: [
                Container(
                  color: AppColor.BLUE_TEXT.withOpacity(0.25),
                  padding: const EdgeInsets.fromLTRB(8, 6, 12, 6),
                  child: Row(
                    children: [
                      Image(
                          image: ImageUtils.instance
                              .getImageNetWork(AppImages.icStoreBlack),
                          width: 28),
                      const Text('Cập nhật điểm bán',
                          style: TextStyle(fontSize: 11))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void onSearch(String value) {
    _dto = TerminalQRDTO();
    terminals = widget.terminals;
    List<TerminalQRDTO> values = [];
    List<TerminalQRDTO> listMaps = [...terminals];
    if (value.trim().isNotEmpty) {
      values.addAll(listMaps
          .where((dto) =>
              dto.terminalCode.toUpperCase().contains(value.toUpperCase()) ||
              dto.terminalName.toUpperCase().contains(value.toUpperCase()))
          .toList());
    } else {
      values = listMaps;
    }
    setState(() {
      terminals = values;
    });
  }

  Widget _buildItemInfo(
      {required String title,
      required String content,
      Color? textColor,
      double? fontSize,
      FontWeight? fontWeight}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 10)),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                  text: content.isEmpty ? '-' : content,
                  style: TextStyle(
                      fontSize: fontSize ?? 11,
                      color: textColor,
                      height: 1.4,
                      fontWeight: fontWeight)),
              if (textColor != null)
                TextSpan(
                    text: 'VND',
                    style: TextStyle(
                        fontSize: fontSize ?? 11, color: AppColor.BLACK)),
            ],
          ),
        )
      ],
    );
  }
}
