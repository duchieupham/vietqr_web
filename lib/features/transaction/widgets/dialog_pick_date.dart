import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/widgets/button_widget.dart';
import 'package:flutter/material.dart';

class DialogPickDate extends StatefulWidget {
  final DateTime dateTime;

  const DialogPickDate({super.key, required this.dateTime});

  @override
  State<DialogPickDate> createState() => _DialogPickDateState();
}

class _DialogPickDateState extends State<DialogPickDate> {
  List<int> listMonth = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
  List<int> listYear = [];

  int _monthSelect = 0;
  int _year = 0;

  DateTime get _now => DateTime.now();

  @override
  void initState() {
    super.initState();
    _monthSelect = widget.dateTime.month;
    _year = widget.dateTime.year;
    for (int i = 0; i < 5; i++) {
      int yearNow = _now.year;
      listYear.add(yearNow - i);
    }
    updateState();
  }

  DateTime convertStringToDate() {
    DateTime dateTime = DateTime(_year, _monthSelect);

    return dateTime;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        width: 330,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              color: Colors.lightBlue,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('$_monthSelect - $_year',
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.white)),
                        DropdownButton<int>(
                          value: _year,
                          elevation: 16,
                          onChanged: (int? value) {
                            _year = value!;
                            updateState();
                          },
                          dropdownColor: AppColor.GREY_TEXT,
                          items:
                              listYear.map<DropdownMenuItem<int>>((int value) {
                            return DropdownMenuItem<int>(
                              value: value,
                              child: Text(
                                '$value',
                                style: const TextStyle(
                                    fontSize: 22,
                                    color: AppColor.WHITE,
                                    fontWeight: FontWeight.bold),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      if (_year >= _now.year) {
                        return;
                      }
                      _year++;
                      updateState();
                    },
                    color: Colors.white,
                    icon: const Icon(Icons.keyboard_arrow_up_outlined),
                    constraints: const BoxConstraints(),
                    padding:
                        const EdgeInsets.only(right: 12, left: 12, top: 16),
                  ),
                  IconButton(
                    onPressed: () {
                      _year--;
                      updateState();
                    },
                    color: Colors.white,
                    icon: const Icon(Icons.keyboard_arrow_down_outlined),
                    constraints: const BoxConstraints(),
                    padding:
                        const EdgeInsets.only(right: 12, left: 12, top: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Container(
              height: 160,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: GridView.builder(
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 20,
                  childAspectRatio: 2,
                ),
                itemCount: listMonth.length,
                itemBuilder: (context, index) {
                  var data = listMonth[index];
                  return GestureDetector(
                    onTap: () async {
                      _monthSelect = data;
                      updateState();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: data == _monthSelect
                              ? Colors.lightBlue
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(5)),
                      alignment: Alignment.center,
                      child: Text(
                        'Tháng $data',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: data == _monthSelect
                                ? Colors.white
                                : AppColor.textBlack),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ButtonWidget(
                  text: 'Đóng',
                  textColor: Colors.black,
                  bgColor: AppColor.BANK_CARD_COLOR_2,
                  width: 80,
                  function: () {
                    Navigator.of(context).pop();
                  },
                  borderRadius: 5,
                  height: 34,
                ),
                const SizedBox(width: 12),
                ButtonWidget(
                  text: 'Xác nhận',
                  textColor: Colors.white,
                  bgColor: AppColor.BLUE_DARK,
                  width: 80,
                  function: () {
                    DateTime date = convertStringToDate();
                    Navigator.of(context).pop(date);
                  },
                  borderRadius: 5,
                  height: 34,
                ),
                const SizedBox(width: 16),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void updateState() {
    setState(() {});
  }
}
