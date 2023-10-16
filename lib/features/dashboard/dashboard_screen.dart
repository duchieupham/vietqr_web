import 'package:VietQR/commons/widgets/header/header_widget.dart';
import 'package:VietQR/features/home/home_screen.dart';
import 'package:VietQR/services/providers/menu_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  //list page
  late PageController _pageController;
  final List<Widget> _listScreens = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: 0,
      keepPage: true,
    );
    _listScreens.addAll(
      [
        const HomeScreen(key: PageStorageKey('HOME_PAGE')),
        Container(color: Colors.red),
        const SizedBox(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const HeaderWidget(),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Consumer<MenuProvider>(
                    builder: (context, provider, child) {
                      return PageView(
                        key: const PageStorageKey('PAGE_VIEW'),
                        physics: const AlwaysScrollableScrollPhysics(),
                        controller: _pageController,
                        onPageChanged: (index) async {},
                        children: _listScreens,
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
