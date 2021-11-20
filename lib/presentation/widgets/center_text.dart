import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watchnow/common/constants.dart';

class CenterText extends StatelessWidget {
  final String keyValue;
  final String text;
  final EdgeInsets? padding;

  CenterText({
    required this.keyValue,
    required this.text,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      key: Key(keyValue),
      child: Padding(
        padding: padding ?? EdgeInsets.zero,
        child: Text(
          text,
          style: subtitle,
        ),
      ),
    );
  }
}
