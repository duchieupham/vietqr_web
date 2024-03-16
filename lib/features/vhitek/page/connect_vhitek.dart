import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/models/transaction/terminal_qr_dto.dart';
import 'package:flutter/material.dart';

class ConnectVhitek extends StatefulWidget {
  final List<TerminalQRDTO> terminals;
  final Function(TerminalQRDTO) onUpdateTerminal;
  final String codeVhitek;

  const ConnectVhitek({
    super.key,
    required this.terminals,
    required this.codeVhitek,
    required this.onUpdateTerminal,
  });

  @override
  State<ConnectVhitek> createState() => _ConnectVhitekState();
}

class _ConnectVhitekState extends State<ConnectVhitek> {
  final searchController = TextEditingController();
  List<TerminalQRDTO> terminals = [];
  TerminalQRDTO _dto = TerminalQRDTO();

  @override
  void initState() {
    super.initState();
    terminals = [...widget.terminals];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: AppColor.GREY_BORDER, width: 1),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Máy bán hàng',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
              ),
              Text(
                widget.codeVhitek.toUpperCase(),
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Chọn cửa hàng/điểm bán\nđể kết nối với máy bán hàng',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14, height: 1.4),
                ),
                const Text(
                  'Có 40 cửa hàng thuộc STK 123456789',
                  style: TextStyle(
                      fontSize: 10, color: AppColor.GREY_TEXT, height: 1.4),
                ),
                const SizedBox(height: 16),
                Container(
                  height: 34,
                  decoration: BoxDecoration(
                    color: AppColor.GREY_BG,
                    border: Border.all(color: AppColor.GREY_LIGHT),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: TextField(
                    style: const TextStyle(fontSize: 12),
                    controller: searchController,
                    onChanged: onSearch,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding:
                          const EdgeInsets.only(left: 12, right: 12, top: 4),
                      hintText: 'Tìm kiếm cửa hàng / điểm bán',
                      hintStyle: const TextStyle(
                          fontSize: 12, color: AppColor.GREY_TEXT),
                      prefixIcon: const Icon(Icons.search,
                          color: AppColor.GREY_TEXT, size: 14),
                      suffixIcon: searchController.text.isNotEmpty
                          ? GestureDetector(
                              onTap: _onClear,
                              child: const Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: Icon(Icons.close, size: 18),
                              ),
                            )
                          : null,
                      suffixIconConstraints: const BoxConstraints(),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: GridView.builder(
                    padding: EdgeInsets.zero,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 12,
                      childAspectRatio: (1 / .4),
                    ),
                    itemCount: terminals.length,
                    itemBuilder: (context, index) {
                      var data = terminals[index];
                      return _buildItemTerminal(data);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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

  Widget _buildItemTerminal(TerminalQRDTO dto) {
    bool isSelect = dto.terminalId == _dto.terminalId;
    return GestureDetector(
      onTap: () {
        _dto = dto;
        searchController.text = dto.terminalCode;
        widget.onUpdateTerminal(dto);
        setState(() {});
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: isSelect ? AppColor.BLUE_TEXT.withOpacity(0.25) : null,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: isSelect ? AppColor.BLUE_TEXT : AppColor.GREY_BORDER,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dto.terminalName,
                    maxLines: 2,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                        color: isSelect ? AppColor.BLUE_TEXT : AppColor.BLACK),
                  ),
                  Text(
                    dto.terminalCode,
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelect ? AppColor.BLUE_TEXT : AppColor.BLACK,
                    ),
                  ),
                ],
              ),
            ),
            Image.asset('assets/images/ic-navigate-next-blue.png', width: 30),
          ],
        ),
      ),
    );
  }

  void _onClear() {
    searchController.clear();
    terminals = [...widget.terminals];
    setState(() {});
  }
}
