import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/enums/textfield_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldWidget extends StatelessWidget {
  final double? width;
  final String hintText;
  final TextEditingController controller;
  final ValueChanged<Object>? onChange;
  final VoidCallback? onEdittingComplete;
  final ValueChanged<Object>? onSubmitted;
  final TextInputAction? keyboardAction;
  final TextInputType inputType;
  final bool isObscureText;
  final double? fontSize;
  final TextfieldType? textfieldType;
  final String? title;
  final double? titleWidth;
  final bool? autoFocus;
  final bool? enable;
  final FocusNode? focusNode;
  final int? maxLines;
  final int? maxLength;
  final bool readOnly;
  final TextAlign? textAlign;
  final bool required;
  final Function(PointerDownEvent)? onTapOutside;
  final EdgeInsets contentPadding;
  final TextStyle? textStyle;
  final List<TextInputFormatter>? inputFormatter;
  const TextFieldWidget(
      {Key? key,
      this.width,
      required this.hintText,
      required this.controller,
      required this.keyboardAction,
      required this.onChange,
      required this.inputType,
      required this.isObscureText,
      this.fontSize,
      this.textfieldType,
      this.title,
      this.titleWidth,
      this.autoFocus,
      this.focusNode,
      this.maxLines,
      this.onEdittingComplete,
      this.onSubmitted,
      this.maxLength,
      this.enable,
      this.textAlign,
      this.onTapOutside,
      this.readOnly = false,
      this.contentPadding = const EdgeInsets.symmetric(horizontal: 10),
      this.textStyle,
      this.required = false,
      this.inputFormatter})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (textfieldType != null && textfieldType == TextfieldType.LABEL)
        ? Container(
            width: width,
            height: 50,
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                SizedBox(
                  width: (titleWidth != null) ? titleWidth : 80,
                  child: Row(
                    children: [
                      Text(
                        title ?? '',
                        style: TextStyle(
                          fontSize: (fontSize != null) ? fontSize : 16,
                        ),
                      ),
                      if (required)
                        const Text(
                          '*',
                          style: TextStyle(
                              fontSize: 16, color: AppColor.RED_TEXT),
                        )
                    ],
                  ),
                ),
                Flexible(
                  child: TextField(
                    obscureText: isObscureText,
                    controller: controller,
                    onChanged: onChange,
                    style: textStyle,
                    textAlign:
                        (textAlign != null) ? textAlign! : TextAlign.left,
                    onEditingComplete: onEdittingComplete,
                    onTapOutside: onTapOutside,
                    onSubmitted: onSubmitted,
                    maxLength: maxLength,
                    autofocus: (autoFocus != null) ? autoFocus! : false,
                    focusNode: focusNode,
                    enabled: enable,
                    readOnly: readOnly,
                    keyboardType: inputType,
                    maxLines: (maxLines == null) ? 1 : maxLines,
                    textInputAction: keyboardAction,
                    inputFormatters: inputFormatter,
                    decoration: InputDecoration(
                      hintText: hintText,
                      counterText: '',
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        fontSize: (fontSize != null) ? fontSize : 16,
                        color: (title != null)
                            ? AppColor.GREY_TEXT
                            : Theme.of(context).hintColor,
                      ),
                      contentPadding: contentPadding,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ))
        : Container(
            width: width,
            height: 60,
            alignment: Alignment.center,
            child: TextField(
              obscureText: isObscureText,
              controller: controller,
              textAlign: (textAlign != null) ? textAlign! : TextAlign.left,
              onChanged: onChange,
              onSubmitted: onSubmitted,
              style: textStyle,
              onEditingComplete: onEdittingComplete,
              keyboardType: inputType,
              maxLines: 1,
              maxLength: maxLength,
              textInputAction: keyboardAction,
              enabled: enable,
              readOnly: readOnly,
              autofocus: false,
              focusNode: focusNode,
              onTapOutside: onTapOutside,
              inputFormatters: inputFormatter,
              decoration: InputDecoration(
                hintText: hintText,
                counterText: '',
                border: InputBorder.none,
                hintStyle: TextStyle(
                  fontSize: (fontSize != null) ? fontSize : 16,
                  color: AppColor.GREY_TEXT,
                ),
                contentPadding: contentPadding,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
              ),
            ),
          );
  }
}
