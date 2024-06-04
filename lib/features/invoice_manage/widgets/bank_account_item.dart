import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/models/invoice_detail_dto.dart';
import 'package:flutter/material.dart';

class SelectBankRecieveItem extends StatelessWidget {
  final PaymentRequestDTO dto;
  final Function(bool) onChange;
  const SelectBankRecieveItem(
      {super.key, required this.dto, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 50,
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            shape: const CircleBorder(),
            activeColor: AppColor.BLUE_TEXT,
            value: dto.isChecked,
            onChanged: (value) {
              onChange(value!);
            },
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${dto.bankShortName} - ${dto.bankAccount}',
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                dto.userBankName,
                style: const TextStyle(fontSize: 12),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
