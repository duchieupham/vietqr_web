import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/platform_utils.dart';
import 'package:VietQR/features/enterprise/page/views/member_store_view.dart';
import 'package:VietQR/features/enterprise/page/views/transaction_store_view.dart';
import 'package:VietQR/features/enterprise/page/widgets/sub_tab_detail_store_widget.dart';
import 'package:flutter/material.dart';

import 'info_store_view.dart';

class StoreDetailView extends StatefulWidget {
  final String terminalId;

  const StoreDetailView({super.key, required this.terminalId});

  @override
  State<StoreDetailView> createState() => _StoreDetailViewState();
}

class _StoreDetailViewState extends State<StoreDetailView> {
  double get width => MediaQuery.of(context).size.width;

  bool get isKWeb => (PlatformUtils.instance.resizeWhen(width, 1360));

  int tab = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeader(context),
        if (!isKWeb)
          _buildMobile(
            tab == 0
                ? InfoStoreView(terminalId: widget.terminalId)
                : tab == 1
                    ? MemberStoreView(terminalId: widget.terminalId)
                    : TransactionStoreView(terminalId: widget.terminalId),
          ),
        if (isKWeb)
          _buildWeb(
            tab == 0
                ? InfoStoreView(terminalId: widget.terminalId)
                : tab == 1
                    ? MemberStoreView(terminalId: widget.terminalId)
                    : TransactionStoreView(terminalId: widget.terminalId),
          ),
      ],
    );
  }

  BorderSide get _borderSize =>
      BorderSide(color: AppColor.GREY_TEXT.withOpacity(0.3));

  Widget _buildMobile(Widget child) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        decoration: BoxDecoration(border: Border(top: _borderSize)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(border: Border(right: _borderSize)),
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    SubTabDetailStoreWidget(
                      tab: tab,
                      onSelectTab: (value) {
                        setState(() {
                          tab = value;
                        });
                      },
                    ),
                    const SizedBox(height: 30),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            child,
                            ...[
                              const SizedBox(height: 24),
                              _buildTextButton(
                                title: 'Cập nhật thông tin',
                                isMobile: true,
                              ),
                              _buildTextButton(
                                  title: 'Thống kê', isMobile: true),
                              _buildTextButton(
                                title: 'Xoá cửa hàng',
                                isBorder: false,
                                isMobile: true,
                                textColor: AppColor.RED_EC1010,
                                iconColor: AppColor.RED_EC1010,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeb(Widget child) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        decoration: BoxDecoration(border: Border(top: _borderSize)),
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(border: Border(right: _borderSize)),
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    SubTabDetailStoreWidget(
                      tab: tab,
                      onSelectTab: (value) {
                        setState(() {
                          tab = value;
                        });
                      },
                    ),
                    const SizedBox(height: 30),
                    Expanded(child: child),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Column(
                children: [
                  _buildTextButton(title: 'Cập nhật thông tin'),
                  _buildTextButton(title: 'Thống kê'),
                  _buildTextButton(
                    title: 'Xoá cửa hàng',
                    isBorder: false,
                    textColor: AppColor.RED_EC1010,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextButton({
    required String title,
    bool isBorder = true,
    bool isMobile = false,
    Color? textColor,
    Color? iconColor,
  }) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: isMobile ? 300 : 180,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: isBorder
              ? Border(
                  bottom:
                      BorderSide(color: AppColor.GREY_TEXT.withOpacity(0.3)))
              : null,
        ),
        child: Row(
          children: [
            Icon(
              Icons.image,
              size: 14,
              color: iconColor ?? AppColor.GREY_TEXT,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                  color: textColor ?? AppColor.GREY_TEXT, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 40,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
      child: Row(
        children: const [
          Text(
            'Doanh nghiệp',
            style: TextStyle(decoration: TextDecoration.underline),
          ),
          SizedBox(width: 8),
          Text('/'),
          SizedBox(width: 8),
          Text(
            'Cửa hàng',
            style: TextStyle(decoration: TextDecoration.underline),
          ),
          SizedBox(width: 8),
          Text('/'),
          SizedBox(width: 8),
          Text(
            'Chi tiết cửa hàng',
            style: TextStyle(decoration: TextDecoration.underline),
          ),
        ],
      ),
    );
  }
}
