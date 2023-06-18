import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/image_utils.dart';
import 'package:flutter/material.dart';

class SliverHeader extends StatelessWidget {
  final String heroId;
  final String coverImgId;
  final String imgId;
  final String businessName;

  const SliverHeader({
    Key? key,
    required this.heroId,
    required this.coverImgId,
    required this.imgId,
    required this.businessName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8), topRight: Radius.circular(8))),
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: [
          _buildImage(context),
          _buildGradient(),
          _buildTitle(context),
        ],
      ),
    );
  }

  Container _buildGradient() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(8), topRight: Radius.circular(8)),
        gradient: LinearGradient(
          colors: [
            DefaultTheme.BLACK.withOpacity(0.2),
            DefaultTheme.BLACK.withOpacity(0.7),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Container(
      alignment: Alignment.bottomLeft,
      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: (imgId.isNotEmpty)
                    ? ImageUtils.instance.getImageNetWork(imgId)
                    : Image.asset(
                        'assets/images/ic-avatar-business.png',
                        fit: BoxFit.cover,
                        width: 50,
                        height: 50,
                      ).image,
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.only(left: 10)),
          Text(
            businessName,
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
            style: const TextStyle(
              color: DefaultTheme.WHITE,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  _buildImage(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Hero(
      tag: heroId,
      child: Container(
        width: width,
        height: (width - 20) / 1.2,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(8), topRight: Radius.circular(8)),
          color: DefaultTheme.GREY_TEXT,
          image: (coverImgId.isNotEmpty)
              ? DecorationImage(
                  image: ImageUtils.instance.getImageNetWork(coverImgId),
                  fit: BoxFit.cover,
                )
              : null,
        ),
      ),
    );
  }
}
