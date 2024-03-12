import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/currency_utils.dart';
import 'package:VietQR/commons/widgets/button_widget.dart';
import 'package:VietQR/layouts/text_field_custom.dart';
import 'package:VietQR/models/transaction/trans_receive_dto.dart';
import 'package:flutter/material.dart';

class DialogUpdateNoteWidget extends StatefulWidget {
  final Function(TransReceiveDTO) update;
  final TransReceiveDTO dto;

  const DialogUpdateNoteWidget(
      {super.key, required this.update, required this.dto});

  @override
  State<DialogUpdateNoteWidget> createState() => _DialogUpdateNoteWidgetState();
}

class _DialogUpdateNoteWidgetState extends State<DialogUpdateNoteWidget> {
  final _valueController = TextEditingController();
  String _value = '';
  TransReceiveDTO dto = TransReceiveDTO();

  List<String> hasTagOutCome = [
    '#ăn_uống',
    '#hóa_dơn',
    '#gia_đình',
    '#di_chuyển',
    '#sức_khỏe',
    '#giải_trí',
    '#bảo_hiểm',
    '#đầu_tư',
    '#trả_lãi',
    '#khác'
  ];

  List<String> hasTagInCome = [
    '#tiết_kiệm',
    '#lương',
    '#thu_lãi',
    '#thu_nhập_khác',
  ];

  @override
  void initState() {
    super.initState();
    setState(() {
      dto = widget.dto;
      _valueController.text = widget.dto.note;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColor.TRANSPARENT,
      child: Center(
        child: Container(
          width: 400,
          height: 600,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Stack(
            children: [
              Column(
                children: [
                  const SizedBox(height: 12),
                  const Center(
                      child: Text(
                    'Ghi chú',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  )),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SizedBox(
                      height: 520,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Thông tin giao dịch',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          _buildInfoItem('Tài khoản:',
                              '${dto.bankShortName} - ${dto.bankAccount}'),
                          const SizedBox(
                            height: 4,
                          ),
                          _buildInfoItem('Số tiền:',
                              '${dto.statusAmount} ${CurrencyUtils.instance.getCurrencyFormatted(dto.amount)}',
                              contentColor: dto.getColorStatus,
                              contentFontWeight: FontWeight.bold),
                          const SizedBox(
                            height: 4,
                          ),
                          _buildInfoItem('Mã Giao dịch:', dto.referenceNumber),
                          const SizedBox(
                            height: 4,
                          ),
                          _buildInfoItem(
                              'Thời gian tạo:', dto.timeCreateEditNote),
                          const SizedBox(height: 4),
                          _buildInfoItem(
                              'Thời gian TT:', dto.timePaymentEditNote),
                          const SizedBox(height: 4),
                          _buildInfoItem('Nội dung:', dto.content),
                          const SizedBox(height: 16),
                          const Text(
                            'Ghi chú',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Container(
                            height: 108,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 12),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border:
                                    Border.all(color: AppColor.GREY_BUTTON)),
                            child: MTextFieldCustom(
                              autoFocus: true,
                              hintText: 'Nhập nội dung ghi chú tại đây',
                              keyboardAction: TextInputAction.done,
                              controller: _valueController,
                              enable: true,
                              onChange: (value) {
                                setState(() {
                                  _value = value;
                                });
                              },
                              inputType: TextInputType.text,
                              isObscureText: false,
                              maxLines: 5,
                              textAlign: TextAlign.left,
                              fontSize: 14,
                              onSubmitted: (value) {
                                dto.note = _value;
                                widget.update.call(dto);
                              },
                              fillColor: AppColor.TRANSPARENT,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Hastag',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildListHasTag(
                                    dto.transType.trim() == 'D'
                                        ? hasTagOutCome
                                        : hasTagInCome,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ButtonWidget(
                                text: 'Hủy',
                                width: 120,
                                textColor: AppColor.BLUE_TEXT,
                                bgColor: AppColor.BLUE_TEXT.withOpacity(0.25),
                                function: () {
                                  Navigator.pop(context);
                                },
                                borderRadius: 5,
                                height: 30,
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              ButtonWidget(
                                text: 'Lưu',
                                width: 120,
                                textColor: AppColor.WHITE,
                                bgColor: AppColor.BLUE_TEXT,
                                function: () {
                                  dto.note = _value;
                                  widget.update.call(dto);
                                },
                                borderRadius: 5,
                                height: 30,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 10,
                right: 10,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 25,
                    height: 25,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Theme.of(context).canvasColor,
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      color: AppColor.BLACK,
                      size: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListHasTag(List<String> hasTag) {
    return Wrap(
      spacing: 12,
      runSpacing: 6,
      children: hasTag.map((e) {
        return InkWell(
          onTap: () {
            setState(() {
              _value = e;
              _valueController.text = e;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
                border: Border.all(
                    color: e == _value ? AppColor.BLUE_TEXT : AppColor.WHITE),
                borderRadius: BorderRadius.circular(30),
                color: AppColor.GREY_BUTTON),
            child: Text(
              e,
              style: const TextStyle(fontSize: 11),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildInfoItem(String title, String content,
      {Color? contentColor, FontWeight contentFontWeight = FontWeight.normal}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 12, color: AppColor.BLACK),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            content.isNotEmpty ? content : '-',
            style: TextStyle(
                color: contentColor,
                fontWeight: contentFontWeight,
                fontSize: 12),
          ),
        ),
      ],
    );
  }
}
