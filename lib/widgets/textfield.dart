// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class TextField2 extends StatefulWidget {
  TextField2(
      {super.key,
      this.controller,
      this.obscureText = false,
      this.hintText,
      this.errorText,
      this.helperText,
      this.readOnly = false,
      this.padding,
      this.onChanged,
      this.onEditingComplete,
      this.onSubmitted,
      this.withBorder = true});

  TextEditingController? controller;
  bool obscureText;
  String? hintText;
  String? errorText;
  String? helperText;
  bool readOnly;
  EdgeInsets? padding;
  void Function(String)? onChanged;
  void Function()? onEditingComplete;
  void Function(String)? onSubmitted;
  bool withBorder;

  @override
  State<TextField2> createState() => _TextField2State();
}

class _TextField2State extends State<TextField2> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding ?? const EdgeInsets.all(0.0),
      child: TextField(
        controller: widget.controller,
        obscureText: widget.obscureText,
        onChanged: widget.onChanged,
        onEditingComplete: widget.onEditingComplete,
        onSubmitted: widget.onSubmitted,
        readOnly: widget.readOnly,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 8.0),
            hintText: widget.hintText,
            errorText: widget.errorText,
            helperText: widget.helperText,
            border: widget.withBorder
                ? OutlineInputBorder(gapPadding: 1.0)
                : InputBorder.none),
      ),
    );
  }
}
