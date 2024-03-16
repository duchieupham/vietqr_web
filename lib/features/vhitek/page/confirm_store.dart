import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/widgets/button_widget.dart';
import 'package:VietQR/features/vhitek/blocs/vhitek_bloc.dart';
import 'package:VietQR/features/vhitek/events/vhitek_event.dart';
import 'package:VietQR/models/bank_account_dto.dart';
import 'package:VietQR/models/transaction/terminal_qr_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConfirmStore extends StatefulWidget {
  final BankAccountDTO dto;
  final TerminalQRDTO terminal;
  final String midCode;
  final Function(int) onEdit;

  const ConfirmStore(
      {super.key,
      required this.dto,
      required this.terminal,
      required this.midCode,
      required this.onEdit});

  @override
  State<ConfirmStore> createState() => _ConfirmStoreState();
}

class _ConfirmStoreState extends State<ConfirmStore> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              children: [
                const SizedBox(height: 32),
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Thông tin kich hoạt máy\ncho cửa hàng đã chính xác chứ?',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                        child: Row(
                          children: [
                            const Text(
                              'Mã máy',
                              style: TextStyle(fontSize: 10),
                            ),
                            Expanded(
                              child: Text(
                                widget.midCode,
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                        decoration: const BoxDecoration(
                          border: Border.symmetric(
                            horizontal: BorderSide(color: AppColor.GREY_BORDER),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Text(
                              'TK ngân hàng',
                              style: TextStyle(fontSize: 10),
                            ),
                            Expanded(
                              child: Text(
                                '${widget.dto.bankAccount} - ${widget.dto.bankShortName}',
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                        child: Row(
                          children: [
                            const Text(
                              'Cửa hàng / điểm bán',
                              style: TextStyle(fontSize: 10),
                            ),
                            Expanded(
                              child: Text(
                                widget.terminal.terminalCode,
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => widget.onEdit(4),
                  child: const Text(
                    'Chọn cửa hàng khác',
                    style: TextStyle(
                      color: AppColor.BLUE_TEXT,
                      decoration: TextDecoration.underline,
                      fontSize: 10,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        ButtonWidget(
          text: 'Xác nhận',
          textColor: AppColor.BLUE_TEXT,
          borderRadius: 5,
          bgColor: AppColor.BLUE_TEXT,
          function: () {
            context.read<VhitekBloc>().add(ConfirmStoreEvent(
                terminalId: widget.terminal.terminalId,
                midCode: widget.midCode));
          },
        ),
      ],
    );
  }
}
