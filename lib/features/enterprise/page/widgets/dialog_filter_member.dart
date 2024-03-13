import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:flutter/material.dart';

class DialogFilterView extends StatefulWidget {
  final int type;

  const DialogFilterView({super.key, required this.type});

  @override
  State<DialogFilterView> createState() => _DialogFilterViewState();
}

class _DialogFilterViewState extends State<DialogFilterView> {
  int type = 0;

  @override
  void initState() {
    super.initState();
    type = widget.type;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context, type),
      child: Material(
        color: AppColor.TRANSPARENT,
        child: Center(
          child: Container(
            width: 300,
            height: 200,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            margin: const EdgeInsets.symmetric(horizontal: 60),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Tìm kiếm theo',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 15),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context, type),
                      child: const Icon(Icons.close),
                    )
                  ],
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => _onSelect(0),
                  child: SizedBox(
                    height: 60,
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text('Số điện thoại'),
                        ),
                        Radio<int>(
                          value: type,
                          groupValue: 0,
                          activeColor: AppColor.BLUE_TEXT,
                          onChanged: (value) {
                            _onSelect(0);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 1,
                  color: Colors.grey.withOpacity(0.6),
                ),
                GestureDetector(
                  onTap: () => _onSelect(1),
                  child: SizedBox(
                    height: 60,
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text('Họ tên'),
                        ),
                        Radio<int>(
                          value: type,
                          groupValue: 1,
                          activeColor: AppColor.BLUE_TEXT,
                          onChanged: (value) {
                            _onSelect(1);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _onSelect(int value) {
    setState(() {
      type = value;
    });
  }
}
