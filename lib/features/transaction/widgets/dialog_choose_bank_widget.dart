import 'package:VietQR/commons/constants/configurations/app_image.dart';
import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/models/bank_account_dto.dart';
import 'package:flutter/material.dart';

class DialogChooseBankWidget extends StatefulWidget {
  final List<BankAccountDTO> banks;

  const DialogChooseBankWidget({super.key, required this.banks});

  @override
  State<DialogChooseBankWidget> createState() => _DialogChooseBankWidgetState();
}

class _DialogChooseBankWidgetState extends State<DialogChooseBankWidget> {
  List<BankAccountDTO> banks = [];

  @override
  void initState() {
    super.initState();
    banks = [...widget.banks];
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
                    const Expanded(
                      child: Text(
                        'Chọn Tk ngân hàng',
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
                  height: 34,
                  decoration: BoxDecoration(
                    color: AppColor.GREY_BG,
                    border: Border.all(color: AppColor.GREY_LIGHT),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: TextField(
                    style: const TextStyle(fontSize: 12),
                    onChanged: (value) {},
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.only(left: 12, right: 12, top: 4),
                      hintText: 'Tìm kiếm theo số TK ngân hàng',
                      hintStyle:
                          TextStyle(fontSize: 12, color: AppColor.GREY_TEXT),
                      prefixIcon: Icon(Icons.search),
                      fillColor: AppColor.WHITE,
                      filled: true,
                      suffixIconConstraints: BoxConstraints(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 300,
                  child: SingleChildScrollView(
                    child: Column(
                      children: List.generate(banks.length, (index) {
                        BankAccountDTO dto = banks[index];
                        return GestureDetector(
                          onTap: () => Navigator.pop(context, dto),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 12),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: AppColor.GREY_BORDER),
                              ),
                            ),
                            child: Row(
                              children: [
                                Image(
                                    image: ImageUtils.instance
                                        .getImageNetWork(dto.imgId ?? ''),
                                    width: 32),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          dto.bankAccount,
                                          style: const TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          dto.userBankName.toUpperCase(),
                                          style: const TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Image(
                                    image: ImageUtils.instance.getImageNetWork(
                                        AppImages.icChooseNext),
                                    width: 32),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _onSelect(int value) {
    setState(() {});
  }
}
