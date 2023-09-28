import 'package:VietQR/commons/widgets/bottom_web.dart';
import 'package:VietQR/commons/widgets/header/header_widget.dart';
import 'package:flutter/material.dart';

import '../../commons/constants/configurations/theme.dart';

class Introduction extends StatelessWidget {
  const Introduction({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: DefaultThemeData(context: context).lightTheme,
      child: Scaffold(
        body: SizedBox(
            child: Column(
          children: [
            const HeaderWidget(
              isSubHeader: true,
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    child: _buildContent(),
                  ),
                  const BottomWeb()
                ],
              ),
            ),
          ],
        )),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTemplate('',
            child: const Text(
                '     “VietQR xin thông báo tính năng mới của chúng tôi: "Lưu danh bạ với VietQR." Chức năng này sẽ giúp bạn lưu trữ và chia sẻ danh bạ một cách hiệu quả hơn thông qua mã QR. Chúng tôi muốn bạn tham gia vào trải nghiệm này và chia sẻ cơ hội tuyệt vời này với bạn bè và người thân.')),
        _buildTemplate(
            'Tại sao nên sử dụng tính năng danh bạ với VietQR của chúng tôi?',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                    '    Lưu trữ tốt hơn: Bằng cách đồng bộ danh bạ của bạn với VietQR, bạn có thể lưu trữ thông tin liên hệ của mình một cách an toàn và tiện lợi. Không còn lo lắng về việc mất danh bạ hoặc hỏng điện thoại.'),
                SizedBox(
                  height: 12,
                ),
                Text(
                    '    Chia sẻ thuận lợi: Với tính năng mã QR, bạn có thể chia sẻ thông tin liên hệ của mình một cách dễ dàng hơn bao giờ hết. Không cần phải nhập tay thông tin hoặc gửi tin nhắn văn bản, chỉ cần quét mã QR và mọi thông tin sẽ tự động được đưa vào danh bạ của người nhận.'),
                SizedBox(
                  height: 12,
                ),
                Text(
                    '    Quản lý danh bạ dễ dàng: Bạn có thể quản lý danh bạ của mình một cách tiện lợi bằng cách sử dụng ứng dụng VietQR. Thêm, sửa đổi hoặc xóa thông tin liên hệ chỉ cần vài cú chạm.'),
                SizedBox(
                  height: 12,
                ),
                Text(
                    '    Bảo mật: Chúng tôi cam kết bảo vệ thông tin cá nhân của bạn. Dữ liệu danh bạ của bạn sẽ được mã hóa và bảo mật tuyệt đối.'),
                SizedBox(
                  height: 12,
                ),
                Text(
                    '    Chúng tôi muốn bạn cùng chia sẻ cơ hội tuyệt vời này với bạn bè và người thân. Hãy cho phép chúng tôi truy cập vào danh bạ của bạn và chia sẻ thông tin qua mã QR để tận hưởng tất cả các lợi ích mà tính năng này mang lại.'),
                SizedBox(
                  height: 12,
                ),
                Text(
                    '     Hãy cùng tham gia và làm cho việc quản lý danh bạ trở nên dễ dàng và tiện lợi hơn bao giờ hết. Cảm ơn bạn đã ủng hộ VietQR!”'),
                SizedBox(
                  height: 80,
                ),
              ],
            )),
      ],
    );
  }

  Widget _buildTemplate(String title, {required Widget child}) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 16,
          ),
          child
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Expanded(child: Image.asset('assets/images/logo-mb.png')),
          const Spacer(
            flex: 3,
          ),
          Expanded(child: Image.asset('assets/images/logo-vietqr-vn.png'))
        ],
      ),
    );
  }
}
