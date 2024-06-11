import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.BLUE_BGR,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
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
