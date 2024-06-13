import 'package:VietQR/commons/constants/configurations/app_image.dart';
import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:VietQR/commons/widgets/m_button_widget.dart';
import 'package:VietQR/features/merchant_manage/widgets/node_paint_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MerchantApiServiceScreen extends StatelessWidget {
  const MerchantApiServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _Screen();
  }
}

class _Screen extends StatefulWidget {
  const _Screen({super.key});

  @override
  State<_Screen> createState() => __ScreenState();
}

class __ScreenState extends State<_Screen> {
  String selectedType = 'individual';
  int merchantLength = 0;
  String? _selectedItem;
  final _horizontal = ScrollController();

  final List<Map<String, dynamic>> _dropdownItems = [
    {
      'value': 'Google Chat',
      'image': ImageUtils.instance.getImageNetWork(AppImages.logoGgChat)
    },
    {
      'value': 'Lark',
      'image': ImageUtils.instance.getImageNetWork(AppImages.logoLark)
    },
    {
      'value': 'Telegram',
      'image': ImageUtils.instance.getImageNetWork(AppImages.logoTelegram)
    },
  ];

  final TextEditingController _merchantController = TextEditingController();
  final TextEditingController _mstController = TextEditingController();
  final TextEditingController _businessController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _idConnectedController = TextEditingController();

  final List<String> labels = [
    "Giới thiệu",
    "Khai báo TT kinh doanh",
    "Khai báo TT kết nối dịch vụ",
    "Kết nối dịch vụ",
    "Nghiệm thu",
    "Golive"
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColor.BLUE_BGR,
      bottomNavigationBar: _bottom(),
      body: Container(
        width: width,
        height: height,
        decoration: const BoxDecoration(
            color: AppColor.WHITE,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _headerWidget(),
            const Divider(
              color: AppColor.GREY_DADADA,
            ),
            Expanded(
              child: Scrollbar(
                controller: _horizontal,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: _horizontal,
                  child: SizedBox(
                    child: SingleChildScrollView(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 280,
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            color: AppColor.RED_TEXT.withOpacity(0.2),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 300,
                                      child: CustomPaint(
                                        painter: NodePainter(6),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: labels
                                              .map((label) => Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 40),
                                                    child: Text(label),
                                                  ))
                                              .toList(),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          _buildStep3(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottom() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 90,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColor.GREY_DADADA),
        ),
        color: AppColor.WHITE,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          MButtonWidget(
            title: 'Trở về',
            isEnable: true,
            margin: EdgeInsets.zero,
            width: 150,
            colorDisableBgr: AppColor.GREY_BUTTON,
            colorDisableText: AppColor.BLACK,
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
            child: MButtonWidget(
              title: 'Tiếp theo',
              isEnable: true,
              margin: EdgeInsets.zero,
              width: 150,
              colorDisableBgr: AppColor.GREY_BUTTON,
              colorDisableText: AppColor.BLACK,
              height: 50,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep3() {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 410,
            color: AppColor.GREY_DADADA,
            child: const Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Column(),
            ),
          ),
          Container(
            width: 410,
            color: AppColor.RED_CALENDAR.withOpacity(0.3),
          )
        ],
      ),
    );
  }

  Widget _buildStep2() {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 370,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    'Thông tin kinh doanh',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 350,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tên đại lý* ($merchantLength/10 ký tự)',
                          style: const TextStyle(fontSize: 15),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: 350,
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColor.GREY_DADADA),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: TextField(
                            onChanged: (value) {
                              setState(() {
                                merchantLength = value.length;
                              });
                            },
                            maxLength: 10,
                            maxLengthEnforcement: MaxLengthEnforcement.enforced,
                            controller: _merchantController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Nhập tên đại lý",
                              hintStyle: TextStyle(color: AppColor.GREY_TEXT),
                              contentPadding: EdgeInsets.only(bottom: 8),
                              counterText: "",
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Không khoảng trắng, không dấu tiếng Việt.\nKhông chứa ký tự đặc biệt.',
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('Loại hình doanh nghiệp*',
                      style: TextStyle(fontSize: 15)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Checkbox(
                        shape: const CircleBorder(),
                        value: selectedType == 'individual',
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              selectedType = 'individual';
                            }
                          });
                        },
                      ),
                      const Text('Cá nhân'),
                      const SizedBox(width: 30),
                      Checkbox(
                        shape: const CircleBorder(),
                        value: selectedType == 'business',
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              selectedType = 'business';
                            }
                          });
                        },
                      ),
                      const Text('Doanh nghiệp'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 350,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'MST/CCCD/ĐKKD*',
                          style: TextStyle(fontSize: 15),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: 350,
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColor.GREY_DADADA),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: TextField(
                            maxLengthEnforcement: MaxLengthEnforcement.enforced,
                            controller: _mstController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Nhập mã số thuế/ Căn cước công dân",
                              hintStyle: TextStyle(color: AppColor.GREY_TEXT),
                              contentPadding: EdgeInsets.only(bottom: 8),
                              counterText: "",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 350,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Ngành nghề kinh doanh*',
                          style: TextStyle(fontSize: 15),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: 350,
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColor.GREY_DADADA),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: TextField(
                            maxLengthEnforcement: MaxLengthEnforcement.enforced,
                            controller: _businessController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Nhập ngành nghề kinh doanh",
                              hintStyle: TextStyle(color: AppColor.GREY_TEXT),
                              contentPadding: EdgeInsets.only(bottom: 8),
                              counterText: "",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 350,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Địa chỉ đăng ký kinh doanh*',
                          style: TextStyle(fontSize: 15),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: 350,
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColor.GREY_DADADA),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: TextField(
                            maxLengthEnforcement: MaxLengthEnforcement.enforced,
                            controller: _addressController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Nhập địa chỉ kinh doanh",
                              hintStyle: TextStyle(color: AppColor.GREY_TEXT),
                              contentPadding: EdgeInsets.only(bottom: 8),
                              counterText: "",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
          Container(
            width: 370,
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 55),
                  SizedBox(
                    width: 350,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Email liên hệ*',
                          style: TextStyle(fontSize: 15),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: 350,
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColor.GREY_DADADA),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: TextField(
                            maxLengthEnforcement: MaxLengthEnforcement.enforced,
                            controller: _emailController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Nhập email tại đây",
                              hintStyle: TextStyle(color: AppColor.GREY_TEXT),
                              contentPadding: EdgeInsets.only(bottom: 8),
                              counterText: "",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Nền tảng kết nối',
                    style: TextStyle(fontSize: 15),
                  ),
                  const Text(
                    'Chọn nền tảng kết nối mà VietQR VN hỗ trợ để nhận các \nthông tin lỗi kết nối và thông tin bảo trì hệ thống.',
                    style: TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: 350,
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColor.GREY_DADADA),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        hint: const Text(
                          "Chọn nền tảng kết nối",
                          style: TextStyle(color: AppColor.GREY_TEXT),
                        ),
                        value: _selectedItem,
                        isExpanded: true,
                        icon: const Icon(
                          Icons.keyboard_arrow_down,
                          color: AppColor.GREY_TEXT,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedItem = newValue;
                          });
                        },
                        items: _dropdownItems.map<DropdownMenuItem<String>>(
                            (Map<String, dynamic> item) {
                          return DropdownMenuItem<String>(
                            value: item['value'],
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: item['image'],
                                        fit: BoxFit.fitWidth),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(item['value']),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (_selectedItem != null)
                    SizedBox(
                      width: 350,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _selectedItem == 'Telegram' ? 'Chat ID' : 'Webhook',
                            style: const TextStyle(fontSize: 15),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: 350,
                            height: 40,
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColor.GREY_DADADA),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: TextField(
                              maxLengthEnforcement:
                                  MaxLengthEnforcement.enforced,
                              controller: _idConnectedController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: _selectedItem == 'Telegram'
                                    ? 'Nhập Chat ID tại đây'
                                    : 'Nhập Webhook tại đây',
                                hintStyle:
                                    const TextStyle(color: AppColor.GREY_TEXT),
                                contentPadding:
                                    const EdgeInsets.only(bottom: 8),
                                counterText: "",
                              ),
                            ),
                          ),
                          Visibility(
                            visible: true,
                            child: Text(
                              _selectedItem == 'Telegram'
                                  ? 'Thông tin Chat ID không hợp lệ.'
                                  : 'Thông tin Webhook không hợp lệ.',
                              style: const TextStyle(
                                  color: AppColor.RED_TEXT, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep1() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Giới thiệu dịch vụ kết nối API Service\nthanh toán bằng mã VietQR',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            Text(
              'Mô tả ở đây.',
              style: TextStyle(fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }

  Widget _headerWidget() {
    return Container(
      padding: const EdgeInsets.fromLTRB(30, 15, 30, 10),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Tích hợp và kết nối",
            style: TextStyle(fontSize: 15),
          ),
          Text(
            "   /   ",
            style: TextStyle(fontSize: 15),
          ),
          Text(
            "Kết nối API Service",
            style: TextStyle(
              fontSize: 15,
            ),
          )
        ],
      ),
    );
  }
}
