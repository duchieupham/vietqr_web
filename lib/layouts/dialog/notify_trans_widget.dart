import 'package:VietQR/commons/constants/configurations/app_image.dart';
import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/commons/widgets/button/m_button_icon_widget.dart';
import 'package:VietQR/layouts/dashedline/horizontal_dashed_line.dart';
import 'package:VietQR/layouts/dashedline/vertical_dashed_line.dart';
import 'package:VietQR/models/notify_trans_dto.dart';
import 'package:VietQR/services/providers/countdown_new_provider.dart';
import 'package:flutter/material.dart';

class NotifyTransWidget extends StatefulWidget {
  final NotifyTransDTO dto;

  const NotifyTransWidget({super.key, required this.dto});

  @override
  State<NotifyTransWidget> createState() => _NotifyTransWidgetState();
}

class _NotifyTransWidgetState extends State<NotifyTransWidget> {
  late CountdownNewProvider countdownProvider;

  @override
  void initState() {
    super.initState();
    countdownProvider = CountdownNewProvider(30);
    countdownProvider.countDown(callback: () {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          height: 450,
          width: 550,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildStatus(),
              const VerticalDashedLine(height: 450),
              _buildInfo(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatus() {
    return Container(
      width: 250,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 30),
          SizedBox(
            width: 100,
            height: 100,
            child: Image(
              image: ImageUtils.instance.getImageNetWork(widget.dto.icon),
              width: 100,
            ),
          ),
          const SizedBox(height: 24),
          ...[
            Text(
              widget.dto.getTransStatus,
              style: const TextStyle(fontSize: 12, color: AppColor.BLACK),
            ),
            Text(
              widget.dto.getAmount,
              style: TextStyle(
                fontSize: 20,
                color: widget.dto.colorAmount,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
          const SizedBox(height: 30),
          ...[
            if (widget.dto.isTerNotEmpty)
              Text(
                widget.dto.terminalName.isNotEmpty
                    ? widget.dto.terminalName
                    : widget.dto.terminalCode,
                style: const TextStyle(
                    fontSize: 14,
                    color: AppColor.BLACK,
                    fontWeight: FontWeight.bold),
              ),
            if (widget.dto.orderId.isNotEmpty)
              Text(
                'Mã đơn ${widget.dto.orderId}',
                style: TextStyle(
                  fontSize: widget.dto.isTerEmpty ? 14 : 12,
                  color: AppColor.BLACK,
                  fontWeight: widget.dto.isTerEmpty ? FontWeight.bold : null,
                ),
              ),
          ],
          if (widget.dto.isTransUnclassified &&
              widget.dto.transType.trim() == 'C') ...[
            MButtonIconWidget(
              height: 30,
              width: 250,
              pathIcon: AppImages.icNoteTrans,
              iconColor: AppColor.BLUE_TEXT,
              title: 'Cập nhật cửa hàng',
              onTap: () {},
              border: Border.all(color: AppColor.BLUE_TEXT),
              bgColor: AppColor.TRANSPARENT,
              textColor: AppColor.BLUE_TEXT,
            ),
          ],
          const Spacer(),
          ValueListenableBuilder<int>(
            valueListenable: countdownProvider,
            builder: (_, value, child) {
              return RichText(
                text: TextSpan(
                  style: const TextStyle(fontSize: 12),
                  children: [
                    const TextSpan(text: 'Thông báo tự động đóng sau '),
                    TextSpan(
                      text: value.toString(),
                      style: const TextStyle(
                          fontSize: 12, color: AppColor.BLUE_TEXT),
                    ),
                    const TextSpan(text: 's'),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInfo() {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Spacer(),
              InkWell(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: AppColor.GREY_DADADA.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Icon(Icons.clear, size: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          const Text(
            'Thông tin giao dịch',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 24),
          ...[
            _buildItem(
              title: 'Tài khoản nhận:',
              content: '${widget.dto.bankCode} - ${widget.dto.bankAccount}',
            ),
            CustomPaint(
              painter: HorizontalDashedLine(dashWidth: 5, dashSpace: 3),
              size: const Size(double.infinity, 1),
            ),
            _buildItem(
              title: 'Thời gian TT:',
              content: widget.dto.timePayment,
            ),
            CustomPaint(
              painter: HorizontalDashedLine(dashWidth: 5, dashSpace: 3),
              size: const Size(double.infinity, 1),
            ),
            _buildItem(
              title: 'Mã GD:',
              content: widget.dto.referenceNumber,
            ),
            CustomPaint(
              painter: HorizontalDashedLine(dashWidth: 5, dashSpace: 3),
              size: const Size(double.infinity, 1),
            ),
            _buildItem(
              title: 'Nội dung TT:',
              content: widget.dto.content,
              maxLines: 3,
            ),
          ],
          const Spacer(),
          MButtonIconWidget(
            height: 30,
            width: 250,
            icon: Icons.check,
            iconSize: 14,
            iconColor: AppColor.WHITE,
            title: 'Hoàn thành',
            onTap: () => Navigator.pop(context),
            border: Border.all(color: AppColor.BLUE_TEXT),
            bgColor: AppColor.BLUE_TEXT,
            textColor: AppColor.WHITE,
          ),
        ],
      ),
    );
  }

  Widget _buildItem({
    String title = '',
    String content = '',
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 11,
                color: AppColor.GREY_TEXT.withOpacity(0.8),
              ),
            ),
          ),
          Expanded(
            child: Text(
              content.isEmpty ? '-' : content,
              textAlign: TextAlign.right,
              maxLines: maxLines,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
