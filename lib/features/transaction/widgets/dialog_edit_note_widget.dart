import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/widgets/button_widget.dart';
import 'package:flutter/material.dart';

class DialogUpdateNoteWidget extends StatefulWidget {
  final Function(String) update;
  final String note;

  const DialogUpdateNoteWidget(
      {super.key, required this.update, required this.note});

  @override
  State<DialogUpdateNoteWidget> createState() => _DialogUpdateNoteWidgetState();
}

class _DialogUpdateNoteWidgetState extends State<DialogUpdateNoteWidget> {
  final _valueController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      _valueController.text = widget.note;
    });
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
                    const Expanded(
                      child: Text(
                        'Cập nhật ghi chú',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 12),
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
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColor.GREY_BG,
                    border: Border.all(color: AppColor.GREY_LIGHT),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextField(
                        style: const TextStyle(fontSize: 12),
                        controller: _valueController,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(bottom: 8, right: 12),
                          hintText: 'Nhập nội dung',
                          hintStyle: TextStyle(
                              fontSize: 12, color: AppColor.GREY_TEXT),
                          prefixIcon: Icon(Icons.edit,
                              color: AppColor.GREY_TEXT, size: 18),
                          fillColor: AppColor.GREY_BG,
                          filled: true,
                          suffixIconConstraints: BoxConstraints(),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
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
                        function: () =>
                            widget.update.call(_valueController.text),
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
}
