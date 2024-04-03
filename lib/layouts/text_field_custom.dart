import 'dart:math';

import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/enums/textfield_type.dart';
import 'package:VietQR/commons/mixin/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MTextFieldCustom extends StatefulWidget {
  final String hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChange;
  final VoidCallback? onEditingComplete;
  final ValueChanged<Object>? onSubmitted;
  final TextInputAction? keyboardAction;
  final TextInputType inputType;
  final bool isObscureText;
  final double? fontSize;
  final TextfieldType? textFieldType;
  final String? title;
  final String? unTitle;
  final bool? autoFocus;
  final bool? enable;
  final FocusNode? focusNode;
  final int? maxLines;
  final int? maxLength;
  final TextAlign? textAlign;
  final Function(PointerDownEvent)? onTapOutside;
  final bool isShowToast;
  final TextStyle? styles;
  final TextStyle? errorStyle;
  final Function(String? error)? showToast;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatter;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Widget? child;
  final String? value;
  final bool showBorder;

  //Border textfield
  final bool isRequired;
  final Color? fillColor;
  final Color? hintColor;
  final EdgeInsetsGeometry? contentPadding;
  final InputDecoration? decoration;

  const MTextFieldCustom({
    Key? key,
    required this.hintText,
    this.controller,
    this.fillColor,
    required this.keyboardAction,
    required this.onChange,
    required this.inputType,
    required this.isObscureText,
    this.fontSize,
    this.textFieldType,
    this.title,
    this.unTitle,
    this.styles,
    this.autoFocus,
    this.focusNode,
    this.maxLines,
    this.onEditingComplete,
    this.onSubmitted,
    this.maxLength,
    this.textAlign,
    this.onTapOutside,
    this.enable,
    this.isShowToast = false,
    this.errorStyle,
    this.showToast,
    this.validator,
    this.inputFormatter,
    this.prefixIcon,
    this.suffixIcon,
    this.isRequired = false,
    this.value,
    this.hintColor,
    this.child,
    this.contentPadding,
    this.showBorder = false,
    this.decoration,
  }) : super(key: key);

  @override
  State<MTextFieldCustom> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<MTextFieldCustom> {
  String? _msgError;
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
  void didUpdateWidget(covariant MTextFieldCustom oldWidget) {
    if (widget.controller == null && widget.value != _controller.text) {
      if (widget.value != null) {
        _updateTextValueToController(widget.value!);
      } else {
        _controller.clear();
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    Widget textFiledTypeLabel = TextFormField(
      obscureText: widget.isObscureText,
      controller: _editingController,
      onChanged: widget.onChange,
      textAlign:
          (widget.textAlign != null) ? widget.textAlign! : TextAlign.left,
      onEditingComplete: widget.onEditingComplete,
      inputFormatters: widget.inputFormatter,
      onTapOutside: widget.onTapOutside,
      maxLength: widget.maxLength,
      enabled: widget.enable,
      autofocus: widget.autoFocus ?? false,
      focusNode: widget.focusNode,
      keyboardType: widget.inputType,
      style: widget.styles,
      maxLines: (widget.maxLines == null) ? 1 : widget.maxLines,
      textInputAction: widget.keyboardAction,
      decoration: widget.decoration ??
          InputDecoration(
            hintText: widget.hintText,
            counterText: '',
            constraints: const BoxConstraints(minHeight: 40, maxHeight: 40),
            counter: const SizedBox(),
            border: InputBorder.none,
            hintStyle: TextStyle(
              fontSize: (widget.fontSize != null) ? widget.fontSize : 14,
              color: widget.hintColor ?? AppColor.GREY_TEXT,
            ),
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.suffixIcon,
            contentPadding: widget.contentPadding ??
                const EdgeInsets.symmetric(horizontal: 16),
            fillColor: widget.fillColor ?? AppColor.WHITE,
            filled: true,
          ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.textFieldType != null &&
            widget.textFieldType == TextfieldType.LABEL) ...[
          Row(
            children: [
              SizedBox(
                child: Text(
                  widget.title ?? '',
                  style: TextStyle(
                    fontSize: (widget.fontSize != null) ? widget.fontSize : 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              if (widget.isRequired)
                Text(
                  '*',
                  style: TextStyle(
                    fontSize: (widget.fontSize != null) ? widget.fontSize : 14,
                    fontWeight: FontWeight.bold,
                    color: AppColor.RED_EC1010,
                  ),
                ),
            ],
          ),
          if (widget.unTitle != null) ...[
            const SizedBox(height: 4),
            Text(
              widget.unTitle ?? '',
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w400,
                height: 1.4,
              ),
            ),
          ],
          const SizedBox(height: 8),
        ],
        Container(
          alignment: Alignment.centerLeft,
          height: 40,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: widget.showBorder
                          ? Border.all(
                              color: AppColor.GREY_LIGHT.withOpacity(0.5))
                          : null),
                  child: widget.child ?? textFiledTypeLabel),
              if (_msgError != null && !widget.isShowToast)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    _msgError!,
                    maxLines: 2,
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                    style: widget.errorStyle ?? Styles.errorStyle(fontSize: 12),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  bool checkValidate() {
    if (widget.validator != null) {
      setState(() {
        _msgError = widget.validator!(_editingController.text);
        if (widget.isShowToast && _msgError != null) {
          widget.showToast!(_msgError);
        }
      });
    }
    return _msgError == null;
  }

  void resetValid() {
    setState(() {
      _msgError = null;
    });
  }

  void onTap() {
    if (_msgError != null) {
      setState(() {
        _msgError = null;
      });
    }
  }

  void showError(String? value) {
    setState(() {
      _msgError = value;
    });
  }

  TextEditingController get _editingController =>
      widget.controller ?? _controller;

  String get text => _editingController.text;
}
