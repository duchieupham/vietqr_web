import 'package:VietQR/commons/constants/configurations/numeral.dart';
import 'package:VietQR/commons/utils/time_utils.dart';
import 'package:VietQR/features/merchant/states/merchant_state.dart';
import 'package:VietQR/models/synthesis_report_dto.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../commons/constants/configurations/theme.dart';

class LineChart extends StatelessWidget {
  final List<SynthesisReportDTO> listData;
  final int maxValueAmount;
  final MerchantState state;
  final int typeDate;
  const LineChart(
      {Key? key,
      required this.listData,
      required this.maxValueAmount,
      required this.state,
      this.typeDate = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int conversionRate = 1000;

    String currencyUnit = 'k';
    if (maxValueAmount > Numeral.MILLION) {
      currencyUnit = 'tr';
      conversionRate = Numeral.MILLION;
    }
    if (maxValueAmount > Numeral.BILLION) {
      currencyUnit = 'tỷ';
      conversionRate = Numeral.BILLION;
    }
    if (state is MerchantLoadingListState) {
      return const UnconstrainedBox(
        child: SizedBox(
          width: 40,
          height: 40,
          child: CircularProgressIndicator(
            color: AppColor.BLUE_TEXT,
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      height: 500,
      padding: const EdgeInsets.only(top: 12, left: 8, right: 20),
      margin: const EdgeInsets.only(left: 16),
      decoration: BoxDecoration(
          color: AppColor.WHITE, borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Số tiền\n(VND)',
            style: TextStyle(fontSize: 10),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16, right: 12),
                        child: SfCartesianChart(
                          enableAxisAnimation: true,
                          primaryXAxis: CategoryAxis(
                            isInversed: false,
                            majorGridLines: const MajorGridLines(width: 0),
                            axisLine: const AxisLine(width: 0),
                          ),
                          primaryYAxis: NumericAxis(
                            labelFormat: '{value}$currencyUnit',
                            labelAlignment: LabelAlignment.center,
                          ),
                          series: <ChartSeries<SynthesisReportDTO, String>>[
                            LineSeries<SynthesisReportDTO, String>(
                                dataSource: listData,
                                xValueMapper: (SynthesisReportDTO dto, _) {
                                  if (typeDate == 1) {
                                    return TimeUtils.instance
                                        .formatDate(dto.time);
                                  } else {
                                    return TimeUtils.instance
                                        .formatMonthYear(dto.time);
                                  }
                                },
                                color: AppColor.GREEN,
                                yValueMapper: (SynthesisReportDTO dto, _) =>
                                    dto.totalCredit / conversionRate,
                                markerSettings: const MarkerSettings(
                                  isVisible: true,
                                  height: 6,
                                  width: 6,
                                )),
                            LineSeries<SynthesisReportDTO, String>(
                                dataSource: listData,
                                xValueMapper: (SynthesisReportDTO dto, _) {
                                  if (typeDate == 1) {
                                    return TimeUtils.instance
                                        .formatDate(dto.time);
                                  } else {
                                    return TimeUtils.instance
                                        .formatMonthYear(dto.time);
                                  }
                                },
                                color: AppColor.RED_TEXT,
                                markerSettings: const MarkerSettings(
                                  isVisible: true,
                                  height: 6,
                                  width: 6,
                                ),
                                yValueMapper: (SynthesisReportDTO dto, _) =>
                                    dto.totalDebit / conversionRate)
                          ],
                        ),
                      ),
                      const Positioned(
                          bottom: 8,
                          right: 0,
                          child: Text(
                            'Thời gian\n(Tháng)',
                            style: TextStyle(fontSize: 10),
                          ))
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Align(
              alignment: Alignment.center,
              child: Text(
                'Biểu đồ thống kê giao dịch',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              )),
          Align(
              alignment: Alignment.center,
              child: Text(
                'Năm ${DateTime.now().year}',
                style: const TextStyle(fontSize: 12),
              )),
          const SizedBox(
            height: 12,
          ),
          Row(
            children: [
              const SizedBox(
                width: 16,
              ),
              Container(
                height: 10,
                width: 20,
                color: AppColor.GREEN,
              ),
              const SizedBox(
                width: 8,
              ),
              const Text(
                'Nhận tiền đến',
                style: TextStyle(fontSize: 11),
              ),
              const SizedBox(
                width: 24,
              ),
              Container(
                height: 10,
                width: 20,
                color: AppColor.RED_TEXT,
              ),
              const SizedBox(
                width: 8,
              ),
              const Text(
                'Chuyển tiền đi',
                style: TextStyle(fontSize: 11),
              ),
            ],
          ),
          const SizedBox(
            height: 12,
          )
        ],
      ),
    );
  }
}
