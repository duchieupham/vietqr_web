import 'dart:convert';

import 'package:VietQR/commons/utils/currency_utils.dart';
import 'package:VietQR/commons/utils/log.dart';
import 'package:VietQR/models/qr_generated_dto.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:js' as js;
import 'dart:html' as html;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

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

  Future<void> saveImageToGallery(GlobalKey globalKey, String nameFile) async {
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
