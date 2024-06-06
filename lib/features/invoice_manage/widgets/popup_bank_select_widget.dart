import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/commons/widgets/dot_dash_widget.dart';
import 'package:VietQR/models/bank_account_dto.dart';
import 'package:VietQR/services/providers/invoice_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PopupBankSelectWidget extends StatefulWidget {
  final Function(BankAccountDTO) onConfirm;
  const PopupBankSelectWidget({super.key, required this.onConfirm});

  @override
  State<PopupBankSelectWidget> createState() => _PopupBankSelectWidgetState();
}

class _PopupBankSelectWidgetState extends State<PopupBankSelectWidget> {
  TextEditingController controller = TextEditingController(text: '');
  String ic_linked_bank = '3e985867-7e93-4b3c-8164-945b7265752c';
  String ic_share_bank = '98d70358-a82e-4bf5-84f8-02cb563c685b';

  BankAccountDTO? selectBank;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColor.TRANSPARENT,
      child: Center(
        child: Container(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
          color: AppColor.WHITE,
          width: 500,
          height: 700,
          child: Stack(
            children: [
              Consumer<InvoiceProvider>(
                builder: (context, provider, child) {
                  provider.selectBankAccount(null);
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          'Chọn tài khoản ngân hàng',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 50),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          width: double.infinity,
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: AppColor.GREY_DADADA)),
                          child: TextFormField(
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.multiline,
                            controller: controller,
                            onChanged: (value) {
                              provider.filterBankList(value);
                            },
                            onFieldSubmitted: (value) {
                              provider.filterBankList(value);
                            },
                            decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.only(top: 11, bottom: 10),
                                hintText: 'Tìm kiếm tài khoản ngân hàng',
                                hintStyle: TextStyle(
                                    fontSize: 20,
                                    color: AppColor.BLACK.withOpacity(0.5)),
                                enabledBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                prefixIcon: const Icon(
                                  Icons.search,
                                  size: 20,
                                ),
                                prefixIconColor: AppColor.GREY_TEXT,
                                suffixIcon: IconButton(
                                  icon: const Icon(
                                    Icons.clear,
                                    size: 20,
                                    color: AppColor.GREY_TEXT,
                                  ),
                                  onPressed: () {
                                    provider.filterBankList('');
                                    controller.clear();
                                  },
                                )),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: provider.listBank.isNotEmpty
                            ? ListView.separated(
                                separatorBuilder: (context, index) =>
                                    const MySeparator(
                                  color: AppColor.GREY_DADADA,
                                ),
                                padding: const EdgeInsets.only(top: 0),
                                itemBuilder: (context, index) {
                                  bool? isSelect = selectBank ==
                                      (provider.isFilter == true
                                          ? provider.filterBanks[index]
                                          : provider.listBank[index]);
                                  return _itemBank(
                                      isSelect: isSelect,
                                      provider.isFilter == true
                                          ? provider.filterBanks[index]
                                          : provider.listBank[index],
                                      index);
                                },
                                itemCount: provider.isFilter == true
                                    ? provider.filterBanks.length
                                    : provider.listBank.length,
                              )
                            : const SizedBox(
                                child: Center(
                                  child: Text('Chưa có TK ngân hàng được thêm'),
                                ),
                              ),
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.center,
                        child: InkWell(
                          onTap: () {
                            if (selectBank != null) {
                              provider.selectBankAccount(selectBank!);
                              widget.onConfirm(selectBank!);
                              Navigator.of(context).pop();
                            }
                          },
                          child: Container(
                            width: 350,
                            height: 50,
                            decoration: BoxDecoration(
                              color: (selectBank != null
                                  ? AppColor.BLUE_TEXT
                                  : AppColor.GREY_BUTTON),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                              child: Text(
                                'Xác nhận',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: (selectBank != null
                                      ? AppColor.WHITE
                                      : AppColor.BLACK),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              Positioned(
                top: 0,
                right: 20,
                child: InkWell(
                  onTap: () {
                    controller.clear();
                    Navigator.of(context).pop();
                  },
                  child: const Icon(
                    Icons.close,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _itemBank(BankAccountDTO dto, int index, {bool? isSelect}) {
    return InkWell(
      onTap: () {
        setState(() {
          selectBank = dto;
        });
      },
      child: Container(
        color: isSelect == true
            ? AppColor.BLUE_TEXT.withOpacity(0.3)
            : AppColor.WHITE,
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        child: Row(
          children: [
            SizedBox(
              width: 85,
              height: 50,
              child: Stack(
                children: [
                  Positioned(
                    bottom: 0,
                    child: Container(
                      width: 75,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(width: 0.5, color: Colors.grey),
                        image: DecorationImage(
                          image: ImageUtils.instance.getImageNetWork(dto.imgId),
                        ),
                      ),
                    ),
                  ),
                  if (dto.isAuthenticated && dto.isOwner)
                    Positioned(
                        top: 0,
                        right: 0,
                        child: Image(
                          image: ImageUtils.instance
                              .getImageNetWork(ic_linked_bank),
                          width: 28,
                        )),
                  if (!dto.isOwner)
                    Positioned(
                        top: 0,
                        right: 0,
                        child: Image(
                          image: ImageUtils.instance
                              .getImageNetWork(ic_share_bank),
                          width: 28,
                        )),
                ],
              ),
              // Placeholder for bank logo
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(dto.bankAccount,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold)),
                Text(dto.userBankName, style: const TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
