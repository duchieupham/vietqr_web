import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:flutter/material.dart';

class StepProgressView extends StatelessWidget {
  final List<String> _titles;
  final int _curStep;
  final Color? _activeColor;
  final double _height;
  final Color _inactiveColor = AppColor.BLUE_TEXT.withOpacity(0.6);
  final double lineWidth = 3.0;

  StepProgressView(
      {Key? key,
      @required int? curStep,
      @required double? height,
      List<String>? titles,
      @required Color? color})
      : _titles = titles!,
        _height = height!,
        _curStep = curStep!,
        _activeColor = color,
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: _height,
        child: Row(
          children: <Widget>[
            Column(
              children: _iconViews(),
            ),
            const SizedBox(
              width: 16,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _titleViews(),
            ),
          ],
        ));
  }

  List<Widget> _iconViews() {
    var list = <Widget>[];
    _titles.asMap().forEach((i, icon) {
      var circleColor =
          (i == 0 || _curStep > i + 1) ? _activeColor : _inactiveColor;
      var lineColor = _curStep > i + 1 ? _activeColor : _inactiveColor;
      var iconColor =
          (i == 0 || _curStep > i + 1) ? _activeColor : _inactiveColor;

      list.add(
        SizedBox(
          // width: 20.0,
          // height: 20.0,
          // padding: EdgeInsets.all(0),

          child: Icon(
            iconColor == _activeColor ? Icons.circle : Icons.circle_outlined,
            color: iconColor,
            size: 18.0,
          ),
        ),
      );

      //line between icons
      if (i != _titles.length - 1) {
        list.add(
          Expanded(
            child: Container(
              height: lineWidth,
              // color: lineColor,
              // child: Icon(
              //   Icons.circle,
              //   color: iconColor,
              //   size: 8.0,
              // ),
              child: VerticalDivider(
                color: iconColor,
              ),
            ),
          ),
        );
      }
    });

    return list;
  }

  List<Widget> _titleViews() {
    var list = <Widget>[];
    _titles.asMap().forEach((i, text) {
      var iconColor =
          (i == 0 || _curStep > i + 1) ? _activeColor : _inactiveColor;
      list.add(Text(
        text,
        textAlign: TextAlign.left,
        style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight:
                iconColor == _activeColor ? FontWeight.bold : FontWeight.w400,
            fontSize: 14,
            fontStyle: FontStyle.normal,
            color: AppColor.BLACK),
      ));
    });
    return list;
  }
}
