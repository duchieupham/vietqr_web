import 'dart:io';
import 'dart:ui';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:flutter/material.dart';

class AmbientAvatarWidget extends StatelessWidget {
  final String imgId;
  final File? imageFile;
  final double size;
  static const double blurRadius = 25.0;
  static const double blurSigma = 20.0;

  const AmbientAvatarWidget({
    super.key,
    required this.imgId,
    required this.size,
    this.imageFile,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            width: size + blurRadius,
            height: size + blurRadius,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: (imageFile != null)
                    ? Image.file(imageFile!).image
                    : ImageUtils.instance.getImageNetworkCache(imgId),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
