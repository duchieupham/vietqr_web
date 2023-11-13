import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/widgets/textfield_widget.dart';
import 'package:VietQR/features/vhitek/provider/active_vhitek_provider.dart';
import 'package:VietQR/layouts/border_layout.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ActiveVhitek extends StatelessWidget {
  final String mid;
  const ActiveVhitek({super.key, this.mid = ''});

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    ;
    if (mid.isNotEmpty) {
      controller = TextEditingController(text: mid);
    }

    return Consumer<ActiveVhitekProvider>(builder: (context, provider, child) {
      return ListView(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        children: [
          const SizedBox(
            height: 32,
          ),
          const Align(
            alignment: Alignment.center,
            child: Text(
              'Kích hoạt máy bán hàng',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          const Text(
            'Mã vạch máy*',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 6,
          ),
          const Text(
            'Mã vạch máy bán hàng được quét từ mã QR',
            style: TextStyle(fontSize: 12),
          ),
          const SizedBox(
            height: 8,
          ),
          BorderLayout(
            height: 50,
            isError: false,
            borderColor: AppColor.WHITE,
            bgColor: AppColor.WHITE,
            child: TextFieldWidget(
                isObscureText: false,
                autoFocus: true,
                hintText: 'Mã vạch máy',
                fontSize: 12,
                maxLength: 50,
                controller: mid.isNotEmpty
                    ? controller
                    : TextEditingController(text: provider.mid),
                inputType: TextInputType.text,
                keyboardAction: TextInputAction.next,
                onChange: (value) {
                  provider.changeMid(value.toString());
                },
                onSubmitted: (value) {}),
          ),
          const SizedBox(
            height: 16,
          ),
          const Text(
            'Địa chỉ/Mã định danh máy*',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 6,
          ),
          const Text(
            'Khách hàng tự nhập Địa chỉ/Mã định danh máy để phân biệt các máy',
            style: TextStyle(fontSize: 12),
          ),
          const SizedBox(
            height: 8,
          ),
          BorderLayout(
            height: 50,
            isError: false,
            borderColor: AppColor.WHITE,
            bgColor: AppColor.WHITE,
            child: TextFieldWidget(
                isObscureText: false,
                autoFocus: true,
                hintText: 'Mã định danh máy bán hàng',
                fontSize: 12,
                maxLength: 50,
                controller: TextEditingController(text: provider.midAddress),
                inputType: TextInputType.text,
                keyboardAction: TextInputAction.next,
                onChange: (value) {
                  provider.changeMidAddress(value.toString());
                },
                onSubmitted: (value) {}),
          ),
          const SizedBox(
            height: 16,
          ),
          const Text(
            'Email*',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 6,
          ),
          const Text(
            'Nhập Email của bạn để kích hoạt máy bán hàng',
            style: TextStyle(fontSize: 12),
          ),
          const SizedBox(
            height: 8,
          ),
          BorderLayout(
            height: 50,
            isError: false,
            borderColor: AppColor.WHITE,
            bgColor: AppColor.WHITE,
            child: TextFieldWidget(
                isObscureText: false,
                autoFocus: true,
                hintText: 'youremail@gmail.com',
                fontSize: 12,
                maxLength: 50,
                controller: TextEditingController(text: provider.email),
                inputType: TextInputType.text,
                keyboardAction: TextInputAction.next,
                onChange: (value) {
                  provider.changeEmail(value.toString());
                },
                onSubmitted: (value) {}),
          ),
        ],
      );
    });
  }
}
