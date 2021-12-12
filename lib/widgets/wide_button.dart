import 'package:flutter/material.dart';

class WideButton extends StatelessWidget {
  final String buttonText;
  final Function onPressed;
  final bool disabled;

  const WideButton(
      {Key? key,
      required this.buttonText,
      required this.onPressed,
      this.disabled = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: ElevatedButton(
        style: ButtonStyle(
          fixedSize:
              MaterialStateProperty.all<Size>(const Size.fromWidth(1000)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
        child: Text(buttonText, style: const TextStyle(fontSize: 17),),
        onPressed: disabled ? null : () => onPressed(),
      ),
    );
  }
}
