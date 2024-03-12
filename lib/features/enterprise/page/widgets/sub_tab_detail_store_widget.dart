import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:flutter/material.dart';

class SubTabDetailStoreWidget extends StatefulWidget {
  final Function(int) onSelectTab;
  final int tab;

  const SubTabDetailStoreWidget(
      {super.key, required this.onSelectTab, required this.tab});

  @override
  State<SubTabDetailStoreWidget> createState() =>
      _SubTabDetailStoreWidgetState();
}

class _SubTabDetailStoreWidgetState extends State<SubTabDetailStoreWidget> {
  int tab = 0;

  final List<DataType> listTab = [
    DataType(title: 'Thông tin', type: 0),
    DataType(title: 'Nhân viên', type: 1),
    DataType(title: 'Giao dịch', type: 2),
  ];

  @override
  void initState() {
    super.initState();
    setState(() {
      tab = widget.tab;
    });
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: const Text(
              'Chi tiết cửa hàng',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 60),
          Container(
            height: 36,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.black, width: 0.5),
            ),
            child: Row(
              children: List.generate(
                listTab.length,
                (index) => GestureDetector(
                  onTap: () {
                    widget.onSelectTab(index);
                    setState(() {
                      tab = index;
                    });
                  },
                  child: Container(
                    width: 80,
                    height: 36,
                    decoration: BoxDecoration(
                      borderRadius: (index == 0)
                          ? const BorderRadius.horizontal(
                              left: Radius.circular(8))
                          : (index == 2)
                              ? const BorderRadius.horizontal(
                                  right: Radius.circular(8))
                              : null,
                      color: tab == index
                          ? AppColor.BLUE_TEXT.withOpacity(0.2)
                          : null,
                      border: border(index),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      listTab[index].title,
                      style: TextStyle(
                          color: tab == index
                              ? AppColor.BLUE_TEXT
                              : AppColor.BLACK),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  BoxBorder? border(index) {
    return (index == 1)
        ? const Border(
            left: BorderSide(width: 0.5, color: AppColor.GREY_TEXT),
            right: BorderSide(width: 0.5, color: AppColor.GREY_TEXT),
          )
        : null;
  }
}

class DataType {
  final String title;
  final int type;

  DataType({required this.title, required this.type});
}
