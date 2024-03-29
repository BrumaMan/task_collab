// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  Button(
      {super.key,
      this.variant = "filled",
      this.color,
      required this.onPressed,
      this.child,
      this.minWidth,
      this.padding});

  String variant;
  Color? color;
  void Function()? onPressed;
  Widget? child;
  double? minWidth;
  EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: padding ?? EdgeInsets.all(0.0),
        child: variant == "filled"
            ? ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                        color ?? Theme.of(context).primaryColor),
                    minimumSize:
                        MaterialStatePropertyAll(Size(minWidth ?? 100.0, 45.0)),
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0)))),
                onPressed: onPressed,
                child: child,
              )
            : OutlinedButton(
                onPressed: onPressed,
                child: child,
                style: ButtonStyle(
                    minimumSize:
                        MaterialStatePropertyAll(Size(minWidth ?? 100.0, 45.0)),
                    side: MaterialStatePropertyAll(
                        BorderSide(color: color ?? Colors.white)),
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0)))),
              ));
  }
}
