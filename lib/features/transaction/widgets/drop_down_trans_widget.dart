import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/enums/textfield_type.dart';
import 'package:VietQR/features/transaction/widgets/dialog_trans_payment_widget.dart';
import 'package:VietQR/layouts/text_field_custom.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class DropdownTransWidget extends StatelessWidget {
  final List<DataFilter> list;
  final DataFilter filter;
  final Function(DataFilter?) callBack;
  final String? title;

  const DropdownTransWidget({
    super.key,
    required this.list,
    required this.filter,
    required this.callBack,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Text(title!,
              style:
                  const TextStyle(fontWeight: FontWeight.w600, fontSize: 11)),
        const SizedBox(height: 6),
        Container(
          height: 34,
          decoration: BoxDecoration(
              color: AppColor.WHITE,
              border: Border.all(
                  color: AppColor.BLACK_BUTTON.withOpacity(0.5), width: 0.5),
              borderRadius: BorderRadius.circular(6)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<DataFilter>(
              isExpanded: true,
              selectedItemBuilder: (context) {
                return list.map(
                  (item) {
                    return DropdownMenuItem<DataFilter>(
                      value: item,
                      alignment: AlignmentDirectional.topStart,
                      child: Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          item.name,
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                      ),
                    );
                  },
                ).toList();
              },
              items: list.map((item) {
                return DropdownMenuItem<DataFilter>(
                  value: item,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      item.name,
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ),
                );
              }).toList(),
              value: filter,
              onChanged: (value) {
                callBack.call(value);
              },
              buttonStyleData: ButtonStyleData(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: AppColor.WHITE,
                ),
              ),
              iconStyleData: const IconStyleData(
                icon: Icon(Icons.expand_more),
                iconSize: 14,
                iconEnabledColor: AppColor.BLACK,
                iconDisabledColor: Colors.grey,
              ),
              dropdownStyleData: DropdownStyleData(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(5)),
              ),
              menuItemStyleData: const MenuItemStyleData(
                padding: EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
