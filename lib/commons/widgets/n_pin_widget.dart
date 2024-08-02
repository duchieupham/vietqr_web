import 'package:VietQR/commons/constants/configurations/theme.dart';
import 'package:VietQR/services/providers/pin_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class NPinWidget extends StatelessWidget {
  final double width;
  final double pinSize;
  final int pinLength;
  final FocusNode focusNode;
  final Function(String) onDone;
  final Alignment? alignment;
  final TextEditingController pinController;

  const NPinWidget({
    super.key,
    required this.width,
    required this.pinSize,
    required this.pinLength,
    required this.focusNode,
    required this.onDone,
    this.alignment,
    required this.pinController,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment ?? Alignment.center,
      child: Container(
        width: width,
        height: pinSize + 5,
        child: Stack(
          children: [
            Consumer<PinProvider>(
              builder: ((context, value, child) {
                return ListView.builder(
                  itemCount: pinLength,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: ((context, index) {
                    // Determine the color based on whether the pin has been entered
                    final bool isFilled = index < value.pinLength;
                    final Color pinColor =
                        isFilled ? Colors.blue : Colors.grey.withOpacity(0.5);

                    return UnconstrainedBox(
                      child: Container(
                        width: pinSize,
                        height: pinSize,
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(pinSize),
                          color: pinColor,
                          border: Border.all(
                            width: 2,
                            color: pinColor,
                          ),
                        ),
                      ),
                    );
                  }),
                );
              }),
            ),
            Positioned.fill(
              child: TextField(
                controller: pinController,
                focusNode: focusNode,
                obscureText: true,
                maxLength: pinLength,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                showCursor: false,
                decoration: const InputDecoration(
                  counterStyle: TextStyle(
                    height: 0,
                  ),
                  counterText: '',
                  border: InputBorder.none,
                ),
                style: const TextStyle(color: AppColor.TRANSPARENT),
                keyboardType: TextInputType.number,
                onChanged: ((text) {
                  Provider.of<PinProvider>(context, listen: false)
                      .updatePinLength(text.length);
                  if (text.length == pinLength) {
                    focusNode.unfocus();
                    Provider.of<PinProvider>(context, listen: false).reset();
                    onDone(text);
                  }
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
