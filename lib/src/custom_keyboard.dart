import 'package:custom_pin_screen/src/src.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Custom keyboard
class CustomKeyBoard extends StatefulWidget {
  /// Theme for the widget. Read more [PinTheme]
  final PinTheme pinTheme;

  /// special key to be displayed on the widget. Default is '.'
  final Widget? specialKey;

  /// on changed function to be called when the amount is changed.
  final Function(String) onChanged;

  /// on competed function to be called when the pin code is complete.
  final Function(String)? onCompleted;

  /// function to be called when special keys are pressed.
  final Function()? specialKeyOnTap;

  /// maximum length of the amount.
  final int maxLength;

  final TextEditingController controller;

  final TextStyle? keysTextStyle;

  const CustomKeyBoard(
      {Key? key,
      required this.maxLength,
      this.pinTheme = const PinTheme.defaults(),
      this.specialKey,
      required this.onChanged,
      this.specialKeyOnTap,
      this.onCompleted,
      required this.controller,
      this.keysTextStyle = const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
      )})
      : assert(maxLength > 0),
        super(key: key);
  @override
  _CustomKeyBoardState createState() => _CustomKeyBoardState();
}

class _CustomKeyBoardState extends State<CustomKeyBoard> {
  Widget buildNumberButton({int? number, Widget? icon, Function()? onPressed}) {
    getChild() {
      if (icon != null) {
        return icon;
      } else {
        return Text(
          number?.toString() ?? "",
          style: widget.keysTextStyle?.copyWith(
            color: widget.pinTheme.keysColor,
          ),
        );
      }
    }

    return Expanded(
        child: CupertinoButton(
            key: icon?.key ?? Key("btn$number"),
            onPressed: onPressed,
            child: getChild()));
  }

  Widget buildNumberRow(List<int> numbers) {
    List<Widget> buttonList = numbers
        .map((buttonNumber) => buildNumberButton(
              number: buttonNumber,
              onPressed: () {
                if (widget.controller.text.length < widget.maxLength) {
                  setState(() {
                    widget.controller.text =
                        widget.controller.text + buttonNumber.toString();
                  });
                }
                widget.onChanged(widget.controller.text);
                if (widget.controller.text.length >= widget.maxLength &&
                    widget.onCompleted != null) {
                  widget.onCompleted!(widget.controller.text);
                }
              },
            ))
        .toList();
    return Expanded(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: buttonList,
    ));
  }

  Widget buildSpecialRow() {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          buildNumberButton(
            icon: widget.specialKey ??
                Icon(
                  Icons.circle,
                  key: const Key('specialKey'),
                  color: widget.pinTheme.keysColor,
                  size: 7,
                ),
            onPressed: widget.specialKeyOnTap ??
                () {
                  if (widget.controller.text.length < widget.maxLength) {
                    if (!widget.controller.text.contains(".")) {
                      setState(() {
                        widget.controller.text = widget.controller.text + ".";
                      });
                    }
                  }
                  widget.onChanged(widget.controller.text);
                  if (widget.controller.text.length >= widget.maxLength &&
                      widget.onCompleted != null) {
                    widget.onCompleted!(widget.controller.text);
                  }
                },
          ),
          buildNumberButton(
            number: 0,
            onPressed: () {
              if (widget.controller.text.length < widget.maxLength) {
                setState(() {
                  widget.controller.text =
                      widget.controller.text + 0.toString();
                });
              }
              widget.onChanged(widget.controller.text);
              if (widget.controller.text.length >= widget.maxLength &&
                  widget.onCompleted != null) {
                widget.onCompleted!(widget.controller.text);
              }
            },
          ),
          buildNumberButton(
              icon: Icon(
                Icons.backspace,
                key: const Key('backspace'),
                color: widget.pinTheme.keysColor,
              ),
              onPressed: () {
                if (widget.controller.text.isNotEmpty) {
                  setState(() {
                    widget.controller.text = widget.controller.text
                        .substring(0, widget.controller.text.length - 1);
                  });
                }
                widget.onChanged(widget.controller.text);
              }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            buildNumberRow([1, 2, 3]),
            buildNumberRow([4, 5, 6]),
            buildNumberRow([7, 8, 9]),
            buildSpecialRow(),
          ],
        ),
      ),
    );
  }
}
