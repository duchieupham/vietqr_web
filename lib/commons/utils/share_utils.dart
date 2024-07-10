import 'dart:html' as html;
import 'dart:js' as js;
import 'dart:ui' as ui;

import 'package:VietQR/commons/utils/currency_utils.dart';
import 'package:VietQR/commons/utils/log.dart';
import 'package:VietQR/commons/utils/string_utils.dart';
import 'package:VietQR/models/invoice_fee_dto.dart';
import 'package:VietQR/models/qr_generated_dto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_downloader_web/image_downloader_web.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:intl/intl.dart';

class ShareUtils {
  const ShareUtils._privateConsrtructor();

  static const ShareUtils _instance = ShareUtils._privateConsrtructor();

  static ShareUtils get instance => _instance;

  String getTextSharing(QRGeneratedDTO dto) {
    String result = '';
    String prefix =
        '${dto.bankAccount}\n${dto.userBankName}\n${dto.bankCode} - ${dto.bankName}';
    String suffix = '';
    if (dto.amount.isNotEmpty && dto.amount != '0') {
      suffix =
          '\n${CurrencyUtils.instance.getCurrencyFormatted(dto.amount)} VND\n';
      if (dto.content.isNotEmpty) {
        suffix += dto.content;
      }
    }
    result = prefix + suffix;
    return result;
  }

  String getTextSharingCopy(InvoiceFeeDTO dto) {
    String formattedDateTimePaid = dto.timePaid.toString().isNotEmpty
        ? DateFormat('yyyy-MM-dd HH:mm:ss')
            .format(DateTime.fromMillisecondsSinceEpoch(dto.timePaid! * 1000))
        : '-';
    String result = '';
    String vso = '';
    String amount = '';
    String timePaid = '';
    String midName = '';
    String invoiceName = '';
    String userName = '';
    String bankAccount = '';
    String invoiceNumber = '';
    if (dto.vso!.isNotEmpty) {
      vso = '\nMã đại lý: ${dto.vso}';
    }
    if (dto.invoiceNumber!.isNotEmpty) {
      invoiceNumber = '\nMã hoá đơn: ${dto.invoiceNumber}';
    }
    if (dto.totalAmount != 0) {
      amount =
          '\nTổng tiền: ${StringUtils.formatNumberWithOutVND(dto.totalAmount.toString())}';
    }
    if (dto.timePaid != 0) {
      timePaid = '\nThời gian thanh toán: $formattedDateTimePaid';
    }
    if (dto.midName!.isNotEmpty) {
      midName = '\nĐại lý: ${dto.midName}';
    }
    if (dto.invoiceName!.isNotEmpty) {
      invoiceName = '\nHoá đơn: ${dto.invoiceName}';
    }
    if (dto.userBankName!.isNotEmpty) {
      userName = '\nChủ TK: ${dto.userBankName}';
    }
    if (dto.bankAccount!.isNotEmpty && dto.bankShortName!.isNotEmpty) {
      bankAccount = '\nTK ngân hàng: ${dto.bankAccount} - ${dto.bankShortName}';
    }

    result =
        '$invoiceName $amount $invoiceNumber $midName $vso $bankAccount $userName $timePaid\nBy VIETQR.VN';

    return result;
  }

  String getTextCoppy(QRGeneratedDTO dto) {
    String result = '';
    if (dto.type == 4) {
      String bankAccount = '';
      String name = '';
      String email = '';
      if (dto.userBankName.isNotEmpty) {
        name = '${dto.userBankName}';
      }
      if (dto.bankAccount.isNotEmpty) {
        bankAccount = '\nSĐT: ${dto.bankAccount}';
      }
      if (dto.email.isNotEmpty) {
        email = '\nEmail: ${dto.email}';
      }

      result = '$name $bankAccount $email\nBy VietQR VN';
    } else {
      String prefix =
          '${dto.bankAccount}\n${dto.userBankName}\n${dto.bankCode}${dto.bankName.isNotEmpty ? ' - ${dto.bankName}' : ''}';
      String suffix = '';
      if (dto.amount.isNotEmpty && dto.amount != '0') {
        suffix =
            '\n${CurrencyUtils.instance.getCurrencyFormatted(dto.amount)} VND\n';
        if (dto.content.isNotEmpty) {
          suffix += dto.content;
        }
      }
      result = '$prefix$suffix\nBy VietQR VN';
    }

    return result;
  }

  Future<bool> shareImage(
      {required GlobalKey key, required String textSharing}) async {
    bool result = false;
    // try {
    //   RenderRepaintBoundary boundary =
    //   key.currentContext!.findRenderObject() as RenderRepaintBoundary;
    //   ui.Image image = await boundary.toImage();
    //   ByteData? byteData =
    //   await (image.toByteData(format: ui.ImageByteFormat.png));
    //   if (byteData != null) {
    //     Directory tempDir = await getTemporaryDirectory();
    //     String tempPath = tempDir.path;
    //     final pngBytes = byteData.buffer.asUint8List();
    //     File('$tempPath/imgshare.png').writeAsBytesSync(pngBytes);
    //     XFile xFile = XFile('$tempPath/imgshare.png');
    //     List<XFile> files = [xFile];
    //     await Share.shareXFiles(files, text: textSharing).then((value) async {
    //       File file = File('$tempPath/imgshare.png');
    //       await file.delete();
    //       result = true;
    //     });
    //   }
    // } catch (e) {
    //   if (kDebugMode) {
    //     print('Error at saveWidgetToImage - ShareUtils: $e');
    //   }
    //   LOG.error(e.toString());
    // }
    return result;
  }

  Future<void> saveImageToGallery(
      GlobalKey globalKey, String bankAccount) async {
    try {
      RenderRepaintBoundary boundary =
          globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 5.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();
      await WebImageDownloader.downloadImageFromUInt8List(
          uInt8List: pngBytes, name: 'VietQr-$bankAccount');
    } catch (e) {
      LOG.error(e.toString());
    }
  }

  // Future<void> saveImageToGallery(
  //     GlobalKey globalKey, String bankAccount) async {
  //   try {
  //     RenderRepaintBoundary boundary =
  //         globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
  //     ui.Image image = await boundary.toImage(pixelRatio: 5.0);
  //     ByteData? byteData =
  //         await image.toByteData(format: ui.ImageByteFormat.png);
  //     Uint8List pngBytes = byteData!.buffer.asUint8List();
  // await WebImageDownloader.downloadImageFromUInt8List(
  //     uInt8List: pngBytes, name: 'VietQr-$bankAccount');
  //     // await ImageGallerySaver.saveImage(
  //     //   pngBytes,
  //     //   quality: 100,
  //     // );
  //   } catch (e) {
  //     LOG.error(e.toString());
  //   }
  // }

  Future<void> getImageFromWidget(GlobalKey globalKey, String nameFile) async {
    try {
      RenderRepaintBoundary boundary =
          globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage();
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      List<int> dataImage = pngBytes;

      js.context.callMethod("saveAs", [
        html.Blob([dataImage]),
        '$nameFile.png'
      ]);
    } catch (e) {
      LOG.error(e.toString());
    }
  }
}
