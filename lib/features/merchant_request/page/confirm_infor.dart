import 'dart:html' as html;

import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/features/merchant_request/provider/merchant_request_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConfirmInfo extends StatelessWidget {
  const ConfirmInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<MerchantRequestProvider>(
        builder: (context, provider, child) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 120),
        child: SingleChildScrollView(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildInfoConnect(provider),
              ),
              const SizedBox(
                width: 80,
              ),
              Expanded(child: _buildAuthCustomer(provider))
            ],
          ),
        ),
      );
    });
  }

  Widget _buildInfoConnect(MerchantRequestProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Xác nhận thông tin kết nối',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 16,
        ),
        _buildItemInfo('Tên đại lý', provider.merchant),
        _buildItemInfo('URL', provider.getUrl()),
        _buildItemInfo('URL Path', provider.suffixConnect),
        _buildItemInfo('Địa chỉ KH', provider.address),
        _buildItemInfo('TK ngân hàng',
            '${provider.bankAccountDTO.bankCode} - ${provider.bankAccountDTO.bankAccount}'),
        _buildItemInfo('Username KH', provider.username),
        _buildItemInfo('Password KH', provider.password),
        _buildItemInfo('Username hệ thống', provider.systemUsername),
        _buildItemInfo('Password hệ thống', provider.systemPassword),
      ],
    );
  }

  Widget _buildAuthCustomer(MerchantRequestProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: AppColor.BLUE_TEXT.withOpacity(0.2)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Lưu ý',
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColor.BLUE_TEXT),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  '- Sau khi tạo yêu cầu kết nối, khách hàng liên hệ với bộ phận hỗ trợ của VietQR VN để xác nhận và duyệ yêu cầu.',
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '- Sau được duyệt yêu cầu, khách hàng có thể thực hiện việc test kết nối, nhận biến động số dư trên môi trường Test của mình.',
                  style: TextStyle(fontSize: 12),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  '- Quá trình test hoàn tất, bên VietQR VN sẽ nghiệm thu kết quả và tiến hành Golive cho khách hàng.',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            )),
        const SizedBox(
          height: 20,
        ),
        _buildDocument(),
        const SizedBox(
          height: 40,
        ),
      ],
    );
  }

  Widget _buildDocument() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Tài liệu kết nối',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 4,
        ),
        Container(
          height: 50,
          color: AppColor.BLUE_TEXT.withOpacity(0.3),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: AppColor.BLACK_BUTTON.withOpacity(0.2))),
                  child: const Text(
                    'Tên tài liệu',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Container(
                width: 110,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    border: Border.all(
                        color: AppColor.BLACK_BUTTON.withOpacity(0.2))),
                child: const Text(
                  'Ngày cập nhật',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                width: 80,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    border: Border.all(
                        color: AppColor.BLACK_BUTTON.withOpacity(0.2))),
                child: const Text(
                  'Truy cập',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 50,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: AppColor.WHITE,
                      border: Border.all(
                          color: AppColor.BLACK_BUTTON.withOpacity(0.2))),
                  child: InkWell(
                    onTap: () {
                      html.window.open(
                          'https://docs.google.com/document/d/17wA-LMJuAwxgr-K5APRAW1X51hvDIrnM/edit?fbclid=IwAR05F0k7xpOJi4mAyuJ4ALSrtSOmPfJkh43An3-hJi5hgwyqfts1TkmhP9s#heading=h.uspmij5vwsf8',
                          'new tab');
                    },
                    child: const Text(
                      'Tài liệu kết nối API VietQR VN - Nhận biến động số dư',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: AppColor.BLUE_TEXT,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                ),
              ),
              Container(
                width: 110,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: AppColor.WHITE,
                    border: Border.all(
                        color: AppColor.BLACK_BUTTON.withOpacity(0.2))),
                child: const Text(
                  '24/10/2023',
                ),
              ),
              Container(
                width: 80,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: AppColor.WHITE,
                    border: Border.all(
                        color: AppColor.BLACK_BUTTON.withOpacity(0.2))),
                child: InkWell(
                  onTap: () {
                    html.window.open(
                        'https://docs.google.com/document/d/17wA-LMJuAwxgr-K5APRAW1X51hvDIrnM/edit?fbclid=IwAR05F0k7xpOJi4mAyuJ4ALSrtSOmPfJkh43An3-hJi5hgwyqfts1TkmhP9s#heading=h.uspmij5vwsf8',
                        'new tab');
                  },
                  child: const Text(
                    'Truy cập',
                    style: TextStyle(
                        color: AppColor.BLUE_TEXT,
                        decoration: TextDecoration.underline),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildItemInfo(String title, String value) {
    return Container(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
          color: AppColor.WHITE, borderRadius: BorderRadius.circular(5)),
      child: Row(
        children: [
          SizedBox(width: 160, child: Text(title)),
          Expanded(child: Text(value))
        ],
      ),
    );
  }
}
