// import 'dart:convert';
// import 'dart:typed_data';

import 'package:VietQR/commons/constants/configurations/app_image.dart';
import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/currency_utils.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
// import 'package:VietQR/commons/utils/log.dart';
import 'package:VietQR/commons/utils/time_utils.dart';
import 'package:VietQR/commons/utils/transaction_utils.dart';
import 'package:VietQR/commons/widgets/button_icon_widget.dart';
import 'package:VietQR/commons/widgets/divider_widget.dart';
import 'package:VietQR/models/notification_transaction_success_dto.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
// import 'package:audioplayers/audioplayers.dart';

class TransactionSuccessWidget extends StatefulWidget {
  final NotificationTransactionSuccessDTO dto;

  const TransactionSuccessWidget({
    super.key,
    required this.dto,
  });

  @override
  State<StatefulWidget> createState() => _TransactionSuccessWidget();
}

class _TransactionSuccessWidget extends State<TransactionSuccessWidget> {
  //animation
  // final AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    // print('---audiolink: ${widget.dto.audioLink}');
    // if (widget.dto.audioLink.isNotEmpty) {
    //   Future.delayed(const Duration(milliseconds: 0), () async {
    //     await playMusicFromUrl(widget.dto.audioLink);
    //     // await playMusicFromUrl(
    //     //     'https://cdn.jsdelivr.net/gh/duchieupham/vietqr_sound@main/prefix_transaction.mp3');
    //     // await Future.delayed(const Duration(milliseconds: 2000), () async {

    //     // });
    //   });
    // }
  }
  // Future<void> playMusicFromUrl(String url) async {
  //   try {
  //     await audioPlayer.play(UrlSource(url));
  //   } catch (e) {
  //     LOG.error('playMusicFromUrl: ${e.toString()}');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Padding(padding: EdgeInsets.only(left: 20)),
        SizedBox(
          width: 430,
          height: 600,
          child: Column(
            children: [
              const Padding(padding: EdgeInsets.only(top: 50)),
              Text(
                (widget.dto.transType.trim() == 'C')
                    ? 'Giao dịch thành công'
                    : 'Biến động số dư',
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 10)),
              Text(
                '${TransactionUtils.instance.getTransType(widget.dto.transType)} ${CurrencyUtils.instance.getCurrencyFormatted(widget.dto.amount)} VND',
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: (widget.dto.transType.trim() == 'C')
                      ? AppColor.NEON
                      : AppColor.RED_CALENDAR,
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 50)),
              _buildElement(
                  width: 450,
                  title: TransactionUtils.instance
                      .getPrefixBankAccount(widget.dto.transType),
                  description: widget.dto.bankAccount),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: DividerWidget(width: 450),
              ),
              _buildElement(
                  width: 450,
                  title: 'Ngân hàng',
                  description:
                      '${widget.dto.bankCode} - ${widget.dto.bankName}'),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: DividerWidget(width: 450),
              ),
              _buildElement(
                width: 450,
                title: 'Thời gian',
                description: TimeUtils.instance
                    .formatDateFromInt(widget.dto.time, false),
              ),
              if (widget.dto.businessName.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: DividerWidget(width: 450),
                ),
                _buildElement(
                  width: 450,
                  title: 'Công ty',
                  description: widget.dto.businessName,
                ),
              ],
              if (widget.dto.branchName.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: DividerWidget(width: 450),
                ),
                _buildElement(
                  width: 450,
                  title: 'Chi nhánh',
                  description: widget.dto.branchName,
                ),
              ],
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: DividerWidget(width: 450),
              ),
              _buildElement(
                width: 450,
                title: 'Nội dung',
                description: widget.dto.content,
                maxLines: 3,
              ),
              const Spacer(),
              Row(
                children: [
                  ButtonIconWidget(
                    width: 200,
                    height: 40,
                    icon: Icons.home_rounded,
                    title: 'Trang chủ',
                    function: () {
                      if (widget.dto.transType == 'C') {
                        Future.delayed(const Duration(milliseconds: 500), () {
                          Navigator.pop(context);
                          context.go('/');
                        });
                      } else {
                        Navigator.pop(context);
                        context.go('/');
                      }
                    },
                    bgColor: Theme.of(context).canvasColor,
                    textColor: AppColor.BLUE_TEXT,
                  ),
                  const Padding(padding: EdgeInsets.only(left: 10)),
                  ButtonIconWidget(
                    width: 200,
                    height: 40,
                    icon: Icons.add_rounded,
                    title: 'Giao dịch mới',
                    function: () {
                      Navigator.pop(context);
                    },
                    bgColor: AppColor.BLUE_TEXT,
                    textColor: AppColor.WHITE,
                  ),
                ],
              ),
              const Padding(padding: EdgeInsets.only(bottom: 20)),
            ],
          ),
        ),
        const Padding(padding: EdgeInsets.only(left: 10)),
        Container(
          width: 340,
          height: 600,
          decoration:const BoxDecoration(
            borderRadius:
                 BorderRadius.horizontal(right: Radius.circular(15)),
            gradient: LinearGradient(
              colors: [
                AppColor.WHITE,
                AppColor.BLUE_LIGHT,
              ],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            ),
          ),
          child: Column(
            children: [
              const Padding(padding: EdgeInsets.only(top: 10)),
              UnconstrainedBox(
                child: SizedBox(
                  width: 340,
                  height: 25,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: InkWell(
                      onTap: () {
                        if (widget.dto.transType == 'C') {
                          Future.delayed(const Duration(milliseconds: 500), () {
                            Navigator.pop(context);
                          });
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      child: Container(
                        width: 25,
                        height: 25,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(right: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Theme.of(context).cardColor.withOpacity(0.3),
                        ),
                        child: Icon(
                          Icons.close_rounded,
                          size: 15,
                          color: Theme.of(context).cardColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              UnconstrainedBox(
                child: (widget.dto.transType == 'C')
                    ? SizedBox(
                        width: 300,
                        height: 150,
                        child: Image(
                            image: ImageUtils.instance.getImageNetWork(
                                AppImages.iconTransactionSuccess)),
                      )
                    : const SizedBox(),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildElement({
    required double width,
    required String title,
    required String description,
    int? maxLines,
  }) {
    return SizedBox(
      width: width,
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
          ),
          Expanded(
            child: Text(
              description,
              textAlign: TextAlign.right,
              maxLines: (maxLines != null) ? maxLines : 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
          )
        ],
      ),
    );
  }
}
