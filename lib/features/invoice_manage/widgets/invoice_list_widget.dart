import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/widgets/dot_dash_widget.dart';
import 'package:VietQR/services/providers/invoice_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InvoiceListWidget extends StatelessWidget {
  final Widget filterWidget;
  final Widget invoicelistWidget;
  final Function() onSelectStatus;
  final double width;
  const InvoiceListWidget({
    super.key,
    required this.filterWidget,
    required this.invoicelistWidget,
    required this.onSelectStatus,
    required this.width,
  });
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
      child: SizedBox(
        width: width,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          primary: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Consumer<InvoiceProvider>(
                builder: (context, provider, child) {
                  return Row(
                    children: [
                      const Text(
                        "Tìm kiếm thông tin hoá đơn ",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 30),
                      ...provider.statusList
                          .map(
                            (e) => _buildOption(e, provider),
                          )
                          .toList(),
                    ],
                  );
                },
              ),
              const SizedBox(height: 20),
              filterWidget,
              const SizedBox(height: 20),
              SizedBox(
                width: width,
                child: const MySeparator(
                  color: AppColor.GREY_DADADA,
                ),
              ),
              const SizedBox(height: 20),

              const Text(
                "Danh sách hóa đơn",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              invoicelistWidget,
              // const SizedBox(height: 1000),
              // _pagingWidget(state),
              // const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOption(InvoiceStatus status, InvoiceProvider provider) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: InkWell(
        onTap: () {
          provider.selectStatus(status);
          onSelectStatus();
        },
        child: Container(
          width: 150,
          height: 30,
          decoration: BoxDecoration(
            color: provider.invoiceStatus == status
                ? AppColor.BLUE_TEXT.withOpacity(0.3)
                : AppColor.WHITE,
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(30),
          ),
          alignment: Alignment.center,
          child: Text(
            status.name,
            style: TextStyle(
              color: provider.invoiceStatus == status
                  ? AppColor.BLUE_TEXT
                  : AppColor.BLACK,
            ),
          ),
        ),
      ),
    );
  }
}
