import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/widgets/button_widget.dart';
import 'package:VietQR/models/transaction/terminal_qr_dto.dart';
import 'package:flutter/material.dart';

class DialogChooseTerminalWidget extends StatefulWidget {
  final List<TerminalQRDTO> terminals;
  final Function(TerminalQRDTO) update;
  final String terminalCode;

  const DialogChooseTerminalWidget(
      {super.key,
      required this.terminals,
      required this.update,
      required this.terminalCode});

  @override
  State<DialogChooseTerminalWidget> createState() =>
      _DialogChooseTerminalWidgetState();
}

class _DialogChooseTerminalWidgetState
    extends State<DialogChooseTerminalWidget> {
  List<TerminalQRDTO> terminals = [];
  TerminalQRDTO _dto = TerminalQRDTO();

  @override
  void initState() {
    super.initState();
    terminals = [...widget.terminals];
    int index = terminals
        .indexWhere((element) => element.terminalCode == widget.terminalCode);
    if (index != -1) _dto = terminals[index];

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Material(
        color: AppColor.TRANSPARENT,
        child: Center(
          child: Container(
            width: 300,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            margin: const EdgeInsets.symmetric(horizontal: 60),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Cập nhật giao dịch',
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 12),
                          ),
                          Text(
                            'Gán các điểm bán tương ứng cho giao dịch chưa hạch toán.',
                            style: TextStyle(
                                fontSize: 10, color: AppColor.GREY_TEXT),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close, size: 18),
                    )
                  ],
                ),
                const SizedBox(height: 30),
                Container(
                  width: 300,
                  height: 34,
                  decoration: BoxDecoration(
                    color: AppColor.GREY_BG,
                    border: Border.all(color: AppColor.GREY_LIGHT),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: TextField(
                    style: const TextStyle(fontSize: 12),
                    onChanged: onSearch,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.only(left: 12, right: 12, top: 4),
                      hintText: 'Tìm kiếm cửa hàng',
                      hintStyle:
                          TextStyle(fontSize: 12, color: AppColor.GREY_TEXT),
                      prefixIcon: Icon(Icons.search,
                          color: AppColor.GREY_TEXT, size: 18),
                      fillColor: AppColor.GREY_BG,
                      filled: true,
                      suffixIconConstraints: BoxConstraints(),
                    ),
                  ),
                ),
                if (terminals.isNotEmpty)
                  SizedBox(
                    height: 300,
                    child: SingleChildScrollView(
                      child: Column(
                        children: List.generate(terminals.length, (index) {
                          TerminalQRDTO dto = terminals[index];
                          return GestureDetector(
                            onTap: () => Navigator.pop(context, dto),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 12),
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom:
                                      BorderSide(color: AppColor.GREY_BORDER),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            dto.terminalName,
                                            style: const TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            dto.terminalCode,
                                            style: const TextStyle(
                                                fontSize: 10,
                                                color: AppColor.GREY_TEXT),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Radio(
                                    value: dto.terminalId,
                                    groupValue: _dto.terminalId,
                                    onChanged: (value) {
                                      setState(() {
                                        _dto = dto;
                                      });
                                    },
                                    activeColor: AppColor.BLUE_TEXT,
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  )
                else
                  const SizedBox(
                    height: 300,
                    child: Center(
                      child: Text(
                        'không có cửa hàng',
                        style: TextStyle(fontSize: 12, color: AppColor.BLACK),
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ButtonWidget(
                        text: 'Đóng',
                        textColor: AppColor.BLUE_TEXT,
                        bgColor: AppColor.BLUE_TEXT.withOpacity(0.25),
                        textSize: 10,
                        function: () {
                          Navigator.pop(context);
                        },
                        borderRadius: 5,
                        height: 30,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ButtonWidget(
                        text: 'Cập nhật',
                        textColor: AppColor.WHITE,
                        bgColor: AppColor.BLUE_TEXT,
                        textSize: 10,
                        function: () => widget.update.call(_dto),
                        borderRadius: 5,
                        height: 30,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onSearch(String value) {
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

  _onSelect(int value) {
    setState(() {});
  }
}
