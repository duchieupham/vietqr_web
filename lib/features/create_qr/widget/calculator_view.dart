import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/commons/utils/string_utils.dart';
import 'package:VietQR/commons/widgets/button_widget.dart';
import 'package:VietQR/features/create_qr/widget/custom_button.dart';
import 'package:VietQR/features/create_qr/widget/history_view.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class CalculatorScreen extends StatefulWidget {
  final Function(String) onSubmit;
  const CalculatorScreen({Key? key, required this.onSubmit}) : super(key: key);

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final List<CalculatorModel> buttons = [
    CalculatorModel(text: 'AC', value: 'AC'),
    CalculatorModel(
        text: 'DEL', icon: Icons.backspace_outlined, value: 'backspace'),
    CalculatorModel(text: '%', value: '%'),
    CalculatorModel(text: '÷', value: '/'),
    CalculatorModel(text: '7', value: '7'),
    CalculatorModel(text: '8', value: '8'),
    CalculatorModel(text: '9', value: '9'),
    CalculatorModel(text: 'x', icon: Icons.close, value: 'x'),
    CalculatorModel(text: '4', value: '4'),
    CalculatorModel(text: '5', value: '5'),
    CalculatorModel(text: '6', value: '6'),
    CalculatorModel(text: '-', value: '-'),
    CalculatorModel(text: '1', value: '1'),
    CalculatorModel(text: '2', value: '2'),
    CalculatorModel(text: '3', value: '3'),
    CalculatorModel(text: '+', value: '+'),
    CalculatorModel(text: '0', value: '0'),
    CalculatorModel(text: '000', value: '000'),
    CalculatorModel(text: '.', value: '.'),
    CalculatorModel(text: '=', value: '='),
  ];

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColor.TRANSPARENT,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: AppColor.WHITE,
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 12,
            ),
            Row(
              children: [
                const Spacer(),
                const SizedBox(
                  width: 28,
                ),
                const Text(
                  'Máy tính',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 26,
                    height: 26,
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Theme.of(context).canvasColor.withOpacity(0.3),
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      size: 15,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: HistoryView(
                      history: history,
                      output: output,
                      isEquals: isEquals,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ButtonWidget(
                      borderRadius: 8,
                      height: 40,
                      text: 'Tạo QR',
                      function: () {
                        widget.onSubmit(output);
                        Navigator.of(context).pop();
                      },
                      textColor: AppColor.WHITE,
                      bgColor: AppColor.BLUE_TEXT,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(16),
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: buttons.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 1.6,
                    crossAxisCount: 4,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemBuilder: (context, index) {
                    switch (index) {
                      /// CLEAR BTN
                      case 0:
                        return CustomButton(
                          buttonTapped: clearInputAndOutput,
                          color: AppColor.BLUE_TEXT.withOpacity(0.2),
                          textColor: AppColor.BLACK,
                          text: buttons[index].text,
                          style: const TextStyle(
                              color: AppColor.BLACK,
                              fontSize: 24,
                              fontWeight: FontWeight.w500),
                          isIcon: isOperator(buttons[index].text),
                          icon: buttons[index].icon,
                          iconColor: AppColor.BLACK,
                          showBorder: false,
                        );

                      /// DELETE BTN
                      case 1:
                        return CustomButton(
                          buttonTapped: deleteBtnAction,
                          color: AppColor.BLUE_TEXT.withOpacity(0.2),
                          textColor: AppColor.BLACK,
                          text: buttons[index].text,
                          style: const TextStyle(
                              color: AppColor.BLACK,
                              fontSize: 24,
                              fontWeight: FontWeight.w500),
                          isIcon: isOperator(buttons[index].text),
                          icon: buttons[index].icon,
                          iconColor: AppColor.BLACK,
                          showBorder: false,
                        );

                      /// %
                      case 2:
                        return CustomButton(
                          buttonTapped: onPT,
                          color: AppColor.BLUE_TEXT.withOpacity(0.2),
                          textColor: AppColor.BLACK,
                          text: buttons[index].text,
                          style: const TextStyle(
                              color: AppColor.BLACK,
                              fontSize: 24,
                              fontWeight: FontWeight.w500),
                          isIcon: isOperator(buttons[index].text),
                          icon: buttons[index].icon,
                          iconColor: AppColor.BLACK,
                          showBorder: false,
                        );
                      case 3:
                      case 7:
                      case 11:
                      case 15:
                        return CustomButton(
                          buttonTapped: () {
                            onBtnTapped(buttons, index, isMath: true);
                          },
                          color: math == buttons[index].value
                              ? AppColor.BLUE_TEXT.withOpacity(0.6)
                              : AppColor.BLUE_TEXT,
                          textColor: AppColor.WHITE,
                          text: buttons[index].text,
                          isIcon: isOperator(buttons[index].text),
                          icon: buttons[index].icon,
                          showBorder: false,
                        );

                      /// = BTN
                      case 19:
                        return CustomButton(
                          buttonTapped: _submit,
                          color: AppColor.BLUE_TEXT,
                          textColor: AppColor.WHITE,
                          text: buttons[index].text,
                          isIcon: isOperator(buttons[index].text),
                          icon: buttons[index].icon,
                        );

                      default:
                        return CustomButton(
                          buttonTapped: () {
                            onBtnTapped(buttons, index);
                          },
                          color: AppColor.WHITE,
                          textColor: AppColor.BLUE_TEXT,
                          text: buttons[index].text,
                          isIcon: isOperator(buttons[index].text),
                          icon: buttons[index].icon,
                        );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool isOperator(String y) {
    if (y == "DEL" || y == "x") {
      return true;
    }
    return false;
  }

  var inputBefore = "";
  var inputAfter = "";
  var output = "0";
  double userOutput = 0;
  var math = "";
  bool isEquals = false;

  List<String> history = [];

  /// Clear Button Pressed Func
  clearInputAndOutput() {
    inputBefore = "";
    inputAfter = "";
    output = "0";
    userOutput = 0;
    math = "";
    setState(() {});
  }

  onPT() {
    if (math.isNotEmpty) {
      clearInputAndOutput();
    }

    inputAfter = output;

    if (inputAfter.length == 0) {
      return null;
    }

    if (math.isEmpty) {
      String userInputFC = (double.parse(inputAfter.trim()) / 100).toString();
      output = userInputFC;
      math = '%';
    }

    setState(() {});
  }

  /// Delete Button Pressed Func
  deleteBtnAction() {
    if (inputAfter.isNotEmpty) {
      inputAfter = inputAfter.substring(0, output.length - 1);
      output = inputAfter;
      setState(() {});
    }
  }

  /// on Number Button Tapped
  onBtnTapped(List<CalculatorModel> buttons, int index, {bool isMath = false}) {
    if (isMath) {
      math = buttons[index].value;
      inputBefore = output;
      inputAfter = "";
    } else {
      if (buttons[index].value == '.') {
        if (math == '%') {
          math = '';
          inputAfter = '0';
        }
        isEquals = true;
      } else {
        isEquals = false;
      }
      inputAfter += buttons[index].value;
      output = inputAfter;
    }
    setState(() {});
  }

  _submit() {
    try {
      if (inputAfter.length == 0 || double.parse(inputAfter) == 0) {
        inputAfter = "";
        setState(() {});
        return null;
      }
      String userInputFC = inputBefore + math + inputAfter;

      Parser p = Parser();
      Expression exp = p.parse(userInputFC.replaceAll("x", "*"));
      ContextModel cm = ContextModel();
      if (mounted) {
        setState(() {
          userOutput = exp.evaluate(EvaluationType.REAL, cm);
          output = userOutput.toStringAsFixed(6).toString();
          if (inputBefore.contains('.')) {
            List<String> listTextBefore = textDelete(inputBefore);
            List<String> listText = textDelete(inputAfter);
            if (listText.last.isNotEmpty) {
              userInputFC = StringUtils.formatMoney(listTextBefore.first) +
                  ',${listTextBefore.last}' +
                  ' $math ' +
                  StringUtils.formatMoney(listText.first) +
                  ',${listText.last}';
            } else {
              userInputFC = StringUtils.formatMoney(listTextBefore.first) +
                  ',${listTextBefore.last}' +
                  ' $math ' +
                  StringUtils.formatMoney(listText.first);
            }
          } else {
            List<String> listText = textDelete(inputAfter);
            if (listText.last.isNotEmpty) {
              userInputFC = StringUtils.formatMoney(inputBefore) +
                  ' $math ' +
                  StringUtils.formatMoney(listText.first) +
                  ',${listText.last}';
            } else {
              userInputFC = StringUtils.formatMoney(inputBefore) +
                  ' $math ' +
                  StringUtils.formatMoney(listText.first);
            }
          }

          if (history.length < 2) {
            history.add(userInputFC);
          } else {
            history.removeAt(0);
            history.add(userInputFC);
          }

          math = "";
          inputAfter = "";
          inputBefore = "";
          isEquals = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  List<String> textDelete(String text) {
    if (text.contains('.')) {
      List<String> texts = text.split('.');

      List<String> textLast = texts.last.split('');
      List<String> data = textLast;

      int length = textLast.length;
      for (int i = length - 1; i >= 0;) {
        int value = int.parse(textLast[i].trim());
        if (value == 0) {
          data.removeAt(i);
          i--;
        } else {
          break;
        }
      }
      return [texts.first, data.join('')];
    }
    return [text, ''];
  }
}

class CalculatorModel {
  final String text;
  final IconData? icon;
  final String value;

  CalculatorModel({
    required this.text,
    required this.value,
    this.icon,
  });
}
