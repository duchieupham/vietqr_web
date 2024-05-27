import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/commons/widgets/dot_dash_widget.dart';
import 'package:VietQR/features/create_qr/blocs/create_qr_bloc.dart';
import 'package:VietQR/features/create_qr/provider/create_qr_provider.dart';
import 'package:VietQR/features/qr_manage/blocs/qr_create_bloc.dart';
import 'package:VietQR/features/qr_manage/event/qr_create_events.dart';
import 'package:VietQR/models/bank_account_dto.dart';
import 'package:VietQR/models/bank_type_dto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';

class PopupBankSelectWidget extends StatefulWidget {
  final Function(String? bankId) onDone;
  final bool isAuthBank;
  const PopupBankSelectWidget(
      {super.key, required this.onDone, required this.isAuthBank});

  @override
  State<PopupBankSelectWidget> createState() => _PopupBankSelectWidgetState();
}

class _PopupBankSelectWidgetState extends State<PopupBankSelectWidget> {
  TextEditingController controller = TextEditingController(text: '');
  String ic_linked_bank = '3e985867-7e93-4b3c-8164-945b7265752c';
  String ic_share_bank = '98d70358-a82e-4bf5-84f8-02cb563c685b';

  BankAccountDTO? selectBank;
  BankTypeDTO? selectBankType;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColor.TRANSPARENT,
      child: Center(
        child: Container(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
          color: AppColor.WHITE,
          width: MediaQuery.of(context).size.width * 0.3,
          height: MediaQuery.of(context).size.height * 0.75,
          child: Stack(
            children: [
              Consumer<CreateQRProvider>(
                builder: (context, provider, child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          widget.isAuthBank == true
                              ? 'Chọn tài khoản ngân hàng'
                              : 'Chọn ngân hàng',
                          style: const TextStyle(
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
                              widget.isAuthBank == true
                                  ? provider.filterBankList(value)
                                  : provider.bankTypeFilter(value);
                            },
                            onFieldSubmitted: (value) {
                              widget.isAuthBank == true
                                  ? provider.filterBankList(value)
                                  : provider.bankTypeFilter(value);
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
                                    widget.isAuthBank == true
                                        ? provider.filterBankList('')
                                        : provider.bankTypeFilter('');
                                    controller.clear();
                                  },
                                )),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      widget.isAuthBank == true
                          ? Expanded(
                              child: provider.bankAccounts.isNotEmpty
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
                                                : provider.bankAccounts[index]);
                                        return _itemBank(
                                            isSelect: isSelect,
                                            provider.isFilter == true
                                                ? provider.filterBanks[index]
                                                : provider.bankAccounts[index],
                                            index);
                                      },
                                      itemCount: provider.isFilter == true
                                          ? provider.filterBanks.length
                                          : provider.bankAccounts.length,
                                    )
                                  : const SizedBox(
                                      child: Center(
                                        child: Text(
                                            'Chưa có TK ngân hàng được thêm'),
                                      ),
                                    ),
                            )
                          : Expanded(
                              child: provider.listBankType.isNotEmpty
                                  ? ListView.separated(
                                      separatorBuilder: (context, index) =>
                                          const MySeparator(
                                        color: AppColor.GREY_DADADA,
                                      ),
                                      padding: const EdgeInsets.only(top: 0),
                                      itemBuilder: (context, index) {
                                        bool? isSelect = selectBankType ==
                                            (provider.isFilter == true
                                                ? provider.filterBankType[index]
                                                : provider.listBankType[index]);
                                        return _itemBankType(
                                            isSelect: isSelect,
                                            provider.isFilter == true
                                                ? provider.filterBankType[index]
                                                : provider.listBankType[index],
                                            index);
                                      },
                                      itemCount: provider.isFilter == true
                                          ? provider.filterBankType.length
                                          : provider.listBankType.length,
                                    )
                                  : const SizedBox(
                                      child: Center(
                                        child:
                                            Text('Chưa có ngân hàng được thêm'),
                                      ),
                                    ),
                            ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.center,
                        child: InkWell(
                          onTap: widget.isAuthBank == true
                              ? () {
                                  if (selectBank != null) {
                                    widget.onDone(selectBank?.bankId);
                                    provider.selectBank(selectBank!);
                                    provider.bankTypeFilter('');
                                    Navigator.of(context).pop();
                                  }
                                }
                              : () {
                                  if (selectBankType != null) {
                                    widget.onDone(selectBankType?.id);
                                    provider.bankTypeSelect(selectBankType!);
                                    provider.filterBankList('');
                                    Navigator.of(context).pop();
                                  }
                                },
                          child: Container(
                            width: 350,
                            height: 50,
                            decoration: BoxDecoration(
                              color: widget.isAuthBank == true
                                  ? (selectBank != null
                                      ? AppColor.BLUE_TEXT
                                      : AppColor.WHITE)
                                  : (selectBankType != null
                                      ? AppColor.BLUE_TEXT
                                      : AppColor.WHITE),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                              child: Text(
                                'Hoàn thành',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: widget.isAuthBank == true
                                      ? (selectBank != null
                                          ? AppColor.WHITE
                                          : AppColor.BLACK)
                                      : (selectBankType != null
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
                  if (dto.isOwner)
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

  Widget _itemBankType(BankTypeDTO dto, int index, {bool? isSelect}) {
    return InkWell(
      onTap: () {
        setState(() {
          selectBankType = dto;
        });
      },
      child: Container(
        width: double.infinity,
        color: isSelect == true
            ? AppColor.BLUE_TEXT.withOpacity(0.3)
            : AppColor.WHITE,
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        child: Row(
          children: [
            Container(
              width: 75,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(width: 0.5, color: Colors.grey),
                image: DecorationImage(
                  image: ImageUtils.instance.getImageNetWork(dto.imageId),
                ),
              ),
            ),
            const SizedBox(width: 20),
            SizedBox(
              width: 300,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(dto.bankShortName,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold)),
                  Text(
                    dto.bankName,
                    style: const TextStyle(fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
