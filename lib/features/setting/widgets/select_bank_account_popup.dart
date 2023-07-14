import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/commons/widgets/divider_widget.dart';
import 'package:VietQR/models/bank_account_dto.dart';
import 'package:VietQR/services/shared_references/session.dart';
import 'package:flutter/material.dart';

class SelectBankAccountPopup extends StatelessWidget {
  final Function(BankAccountDTO) onSelect;
  const SelectBankAccountPopup({Key? key, required this.onSelect})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            const Padding(padding: EdgeInsets.only(left: 20)),
            const Text(
              'Chọn ngân hàng',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                width: 25,
                height: 25,
                alignment: Alignment.center,
                margin: const EdgeInsets.only(right: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Theme.of(context).canvasColor.withOpacity(0.3),
                ),
                child: const Icon(
                  Icons.close_rounded,
                  size: 15,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 16,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: ListView.separated(
              padding: EdgeInsets.zero,
              itemBuilder: (BuildContext context, int index) {
                return _buildItemBank(
                    Session.instance.listBankAuth[index], context);
              },
              separatorBuilder: (BuildContext context, int index) {
                return const DividerWidget(width: 476);
              },
              itemCount: Session.instance.listBankAuth.length,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildItemBank(BankAccountDTO dto, BuildContext context) {
    return InkWell(
      onTap: () {
        onSelect(dto);
        Navigator.pop(context);
      },
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: DefaultTheme.WHITE,
              image: DecorationImage(
                image: ImageUtils.instance.getImageNetWork(
                  dto.imgId,
                ),
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.only(left: 10)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${dto.bankCode} - ${dto.bankAccount}',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: DefaultTheme.BLACK,
                    fontSize: 13),
              ),
              const SizedBox(
                height: 2,
              ),
              Text(
                dto.userBankName.toUpperCase(),
                style: const TextStyle(
                  color: DefaultTheme.BLACK,
                  fontSize: 10,
                ),
              ),
            ],
          ),
          const SizedBox.shrink()
        ],
      ),
    );
  }
}
