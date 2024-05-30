import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/time_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ClockWidget extends StatelessWidget {
  const ClockWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Stream.periodic(const Duration(seconds: 1)),
      builder: (context, snapshot) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              DateFormat('HH:mm:ss').format(DateTime.now()),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 2,
            ),
            Row(
              children: [
                Text(
                  '${TimeUtils.instance.getCurrentDateInWeek(DateTime.now())},',
                  style: const TextStyle(
                      fontSize: 10,
                      color: AppColor.GREY_TEXT,
                      fontWeight: FontWeight.w400),
                ),
                Text(
                  // DateFormat('MM-dd-yyyy').format(DateTime.now()),
                  TimeUtils.instance.getCurentDate(),
                  style:
                      const TextStyle(fontSize: 10, color: AppColor.GREY_TEXT),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
