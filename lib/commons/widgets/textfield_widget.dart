import 'dart:math';

import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/enums/textfield_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldWidget extends StatefulWidget {
  final double? width;
  final String hintText;
  final TextEditingController? controller;
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
  final String? value;
  final Function(PointerDownEvent)? onTapOutside;
  final EdgeInsets contentPadding;
  final TextStyle? textStyle;
  final List<TextInputFormatter>? inputFormatter;
  final Color? fillColor;
  final Widget? prefixIcon;
  final double height;
  const TextFieldWidget(
      {Key? key,
      this.width,
      required this.hintText,
      this.controller,
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
      this.value,
      this.inputFormatter,
      this.height = 50,
      this.prefixIcon,
      this.fillColor})
      : super(key: key);

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.controller == null && widget.value != null) {
      _updateTextValueToController(widget.value!);
    }
  }

  _updateTextValueToController(String value) {
    final diffChar = value.length - _controller.text.length;
    final currentPointerPosition = max(_controller.selection.start, 0);
    var newPointerPosition = currentPointerPosition + diffChar;
    newPointerPosition = newPointerPosition > 0 ? newPointerPosition : 0;
    _controller.text = widget.value!;
    _controller.selection = TextSelection.collapsed(offset: newPointerPosition);
  }

  @override
  void didUpdateWidget(covariant TextFieldWidget oldWidget) {
    if (widget.controller == null && widget.value != _controller.text) {
      if (widget.value != null) {
        _updateTextValueToController(widget.value!);
      } else {
        _controller.clear();
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  TextEditingController get _editingController =>
      widget.controller ?? _controller;
  @override
  Widget build(BuildContext context) {
    return (widget.textfieldType != null &&
            widget.textfieldType == TextfieldType.LABEL)
        ? Container(
            width: widget.width,
            height: widget.height,
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                SizedBox(
                  width: (widget.titleWidth != null) ? widget.titleWidth : 80,
                  child: Row(
                    children: [
                      Text(
                        widget.title ?? '',
                        style: TextStyle(
                          fontSize:
                              (widget.fontSize != null) ? widget.fontSize : 16,
                        ),
                      ),
                      if (widget.required)
                        const Text(
                          '*',
                          style:
                              TextStyle(fontSize: 16, color: AppColor.RED_TEXT),
                        )
                    ],
                  ),
                ),
                Flexible(
                  child: TextField(
                    obscureText: widget.isObscureText,
                    controller: _editingController,
                    onChanged: widget.onChange,
                    style: widget.textStyle,
                    textAlign: (widget.textAlign != null)
                        ? widget.textAlign!
                        : TextAlign.left,
                    onEditingComplete: widget.onEdittingComplete,
                    onTapOutside: widget.onTapOutside,
                    onSubmitted: widget.onSubmitted,
                    maxLength: widget.maxLength,
                    autofocus:
                        (widget.autoFocus != null) ? widget.autoFocus! : false,
                    focusNode: widget.focusNode,
                    enabled: widget.enable,
                    readOnly: widget.readOnly,
                    keyboardType: widget.inputType,
                    maxLines: (widget.maxLines == null) ? 1 : widget.maxLines,
                    textInputAction: widget.keyboardAction,
                    inputFormatters: widget.inputFormatter,
                    decoration: InputDecoration(
                      fillColor: widget.fillColor,
                      hintText: widget.hintText,
                      icon: widget.prefixIcon,
                      counterText: '',
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        fontSize:
                            (widget.fontSize != null) ? widget.fontSize : 16,
                        color: (widget.title != null)
                            ? AppColor.GREY_TEXT
                            : Theme.of(context).hintColor,
                      ),
                      contentPadding: widget.contentPadding,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ))
        : Container(
            width: widget.width,
            height: widget.height,
            alignment: Alignment.center,
            child: TextField(
              obscureText: widget.isObscureText,
              controller: _editingController,
              textAlign: (widget.textAlign != null)
                  ? widget.textAlign!
                  : TextAlign.left,
              onChanged: widget.onChange,
              onSubmitted: widget.onSubmitted,
              style: widget.textStyle,
              onEditingComplete: widget.onEdittingComplete,
              keyboardType: widget.inputType,
              maxLines: 1,
              maxLength: widget.maxLength,
              textInputAction: widget.keyboardAction,
              enabled: widget.enable,
              readOnly: widget.readOnly,
              autofocus: false,
              focusNode: widget.focusNode,
              onTapOutside: widget.onTapOutside,
              inputFormatters: widget.inputFormatter,
              decoration: InputDecoration(
                hintText: widget.hintText,
                icon: widget.prefixIcon,
                counterText: '',
                border: InputBorder.none,
                hintStyle: TextStyle(
                  fontSize: (widget.fontSize != null) ? widget.fontSize : 16,
                  color: AppColor.GREY_TEXT,
                ),
                contentPadding: widget.contentPadding,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
              ),
            ),
          );
  }
}
