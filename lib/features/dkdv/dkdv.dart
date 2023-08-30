import 'package:flutter/material.dart';

import '../../commons/constants/configurations/theme.dart';

class DkDv extends StatelessWidget {
  const DkDv({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: DefaultThemeData(context: context).lightTheme,
      child: Scaffold(
        body: SizedBox(
            child: Column(
          children: [
            const SizedBox(
              height: 12,
            ),
            _buildLogo(),
            Expanded(
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 52, vertical: 12),
                children: [
                  const Align(
                    alignment: Alignment.center,
                    child: Text(
                      'ĐIỀU KHOẢN VÀ ĐIỀU KIỆN SỬ DỤNG DỊCH VỤ NHẬN BIẾN ĐỘNG SỐ DƯ',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  _buildContent(),
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
        _buildTemplate('ĐIỀU 1. PHẠM VI ÁP DỤNG ',
            child: const Text(
                '         Điều khoản, Điều kiện này quy định về việc sử dụng dịch vụ Nhận biến động số dư tài khoản XXX của khách hàng mở tại MBBank trên nền tảng của BLUECOM (“Điều khoản, Điều kiện”). ')),
        _buildTemplate('ĐIỀU 2. GIẢI THÍCH TỪ NGỮ',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                    '1.	“Ngân hàng/MBBank/NH”: Là Ngân hàng Thương mại Cổ phần Quân Đội. '),
                SizedBox(
                  height: 8,
                ),
                Text(
                    '2.	“Khách hàng”: Là khách hàng cá nhân mở TKTT tại MBBank, đăng ký dịch vụ Nhận/chia sẻ biến động số dư tài khoản của khách hàng trên nền tảng của Bluecom '),
                SizedBox(
                  height: 8,
                ),
                Text(
                    '3.	“Tài Khoản”/ “Tài Khoản Thanh Toán”: Là tài khoản thanh toán bằng đồng Việt Nam Đồng, do Khách hàng mở tại MBBank để phục vụ cho các giao dịch của Khách hàng được Ngân hàng chấp nhận.'),
                SizedBox(
                  height: 8,
                ),
                Text(
                    '4.	Dịch vụ Nhận biến động số dư: Là dịch vụ cho phép khách hàng thực hiện nhận và có thể chia sẻ biến động số dư trên tài khoản thanh toán của khách hàng thông qua nền tảng của Bluecom.'),
              ],
            )),
        _buildTemplate('ĐIỀU 3. ĐẶC ĐIỂM DỊCH VỤ NHẬN BIẾN ĐỘNG SỐ DƯ',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                    '1.	Khách hàng có thể nhận và chia sẻ cho nhiều người cùng lúc. Vấn đề bảo mật vẫn được đảm bảo, chủ tài khoản không cần lộ OPT hay bất cứ thông tin cá nhân nào khác.'),
                SizedBox(
                  height: 8,
                ),
                Text(
                    '2.	Thuận tiện theo dõi nguồn tiền ra/vào ngay trên nền tảng của Bluecom'),
                SizedBox(
                  height: 8,
                ),
                Text(
                    '3.	Biến động số dư được cập nhật ngay, đồng thời, trên tất cả các thiết bị được chia sẻ và thiết bị chủ, giúp người được chia sẻ nắm rõ biến động tài khoản khi khách hàng thanh toán.'),
                SizedBox(
                  height: 8,
                ),
                Text('4.	Phí dịch vụ: Miễn phí')
              ],
            )),
        _buildTemplate('ĐIỀU 4. QUYỀN LỢI VÀ TRÁCH NHIỆM CỦA KHÁCH HÀNG ',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('1.	Quyền của Khách hàng: '),
                Padding(
                  padding: const EdgeInsets.only(left: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                          'a)	Được hiển thị các thông tin về biến động số dư trên nền tảng Bluecom'),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                          'b)	Được đăng ký hoặc hủy Dịch vụ Nhận biến động số dư trên nền tảng Bluecom'),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                const Text('2.	Trách nhiệm của Khách hàng: '),
                Padding(
                  padding: const EdgeInsets.only(left: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                          'a)	Cho phép MB hiển thị thông tin biến động số dư của khách hàng trên nền tảng của Bluecom.'),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                          'b)	Giữ bí mật các thông tin cá nhân, mã Khách hàng/tên đăng nhập, mật mã truy cập Dịch vụ trên nền tảng Bluecom và MBBank, không cung cấp, tiết lộ cho bất kỳ bên thứ ba nào khác. '),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                          'c)	Đồng ý rằng bất cứ hành động thực hiện truy cập vào nền tảng của Bluecom, MBBank và/hoặc thực hiện giao dịch Tài khoản đăng nhập và Mật khẩu để thực hiện giao dịch đăng ký/hủy đăng ký Dịch vụ Nhận biến động số dư đều được xem là giao dịch do chính Khách hàng thực hiện và khách hàng hiểu rằng việc Chia sẻ thông tin biến động số dư có thể tiềm ẩn nhiều rủi ro lộ thông tin tài khoản.'),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                          'd)	Đồng ý với Biểu phí Dịch vụ Nhận biến động số dư khi sử dụng Dịch vụ (bao gồm việc MBBank thay đổi biểu phí này (nếu có)). '),
                    ],
                  ),
                ),
              ],
            )),
        _buildTemplate('ĐIỀU 5. QUYỀN VÀ TRÁCH NHIỆM CỦA MBBANK',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('1.	Quyền của MBBank: '),
                Padding(
                  padding: const EdgeInsets.only(left: 32, top: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                          'a)	Yêu cầu Khách hàng cung cấp thông tin và tài liệu cần thiết trong quá trình sử dụng Dịch vụ Nhận biến động số dư.'),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                          'b)	Từ chối thực hiện các yêu đăng ký dịch vụ Nhận biến động số dư của Khách hàng tại MBBank trong trường hợp đánh giá khách hàng vi phạm các Điều khoản, Điều kiện này và Khách hàng phải chịu hoàn toàn các thiệt hại do vi phạm này gây ra. '),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                const Text('2.	Trách nhiệm của MBBank: '),
                Padding(
                  padding: const EdgeInsets.only(left: 32, top: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                          'a)	Cung cấp dịch vụ đăng ký/hủy dịch vụ Nhận biến động số dư cho Khách hàng. '),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                          'b)	Giữ bí mật các thông tin liên quan đến Khách hàng theo quy định pháp luật. '),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                          'c)	Giải quyết và trả lời các khiếu nại của Khách hàng có liên quan đến việc sử dụng Dịch vụ Nhận biến động số dư của Khách hàng tại MBBank. '),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                          'd)	Không chịu trách nhiệm đối với các trường hợp do lỗi/quá tải/tấn công hệ thống ngoài tầm kiểm soát của Ngân hàng dẫn đến Khách hàng không nhận được/nhận được chậm các thông báo biến động số dư tài khoản thanh toán của Khách hàng. '),
                    ],
                  ),
                ),
              ],
            )),
        _buildTemplate('ĐIỀU 6. SỬA ĐỔI NỘI DUNG ĐIỀU KHOẢN, ĐIỀU KIỆN: ',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                    '1.	MBBank được quyền thay đổi nội dung Điều khoản, Điều kiện này, thay đổi đặc điểm sản phẩm Dịch vụ Nhận biến động số dư, thay đổi phí sử dụng Dịch vụ Nhận biến động số dư và MBBank có trách nhiệm thông báo đến Khách hàng trên website của MBBank hoặc bằng bất cứ hình thức nào do MBBank quy định từng thời kỳ và công khai đến Khách hàng. '),
                SizedBox(
                  height: 8,
                ),
                Text(
                    '2.	Những thay đổi này sẽ có hiệu lực vào ngày ghi trên Thông báo. Nếu Khách hàng tiếp tục giữ và sử dụng Dịch vụ Nhận biến động số dư thì xem như Khách hàng đã chấp nhận những thay đổi này. '),
              ],
            )),
        _buildTemplate('ĐIỀU 7. HIỆU LỰC CỦA ĐIỀU KHOẢN, ĐIỀU KIỆN ',
            child: const Text(
                '         Điều khoản, Điều kiện này có hiệu lực kể từ ngày Khách hàng đăng ký Dịch vụ Nhận biến động số dư với MBBank và được MBBank cung cấp dịch vụ và chỉ chấm dứt hiệu lực khi Khách hàng hủy sử dụng dịch vụ trên nền tảng Bluecom và được MBBank chấp thuận hoặc khi MBBank ngừng cung cấp dịch vụ cho Khách hàng theo Điều khoản, Điều kiện này.')),
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
            height: 8,
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
