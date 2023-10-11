import 'package:flutter/cupertino.dart';

class HomeFrame extends StatelessWidget {
  final Widget home;
  final Widget listBank;
  final Widget infoAccount;

  const HomeFrame(
      {super.key,
      required this.home,
      required this.listBank,
      required this.infoAccount});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 1000) {
      return ListView(
        children: [
          home,
          const SizedBox(height: 24),
          listBank,
          const SizedBox(height: 24),
          infoAccount,
        ],
      );
    }
    return Row(
      children: [
        const SizedBox(width: 16),
        Expanded(child: home),
        const SizedBox(width: 30),
        Expanded(child: listBank),
        const SizedBox(width: 30),
        Expanded(child: infoAccount),
        const SizedBox(width: 16),
      ],
    );
  }
}
