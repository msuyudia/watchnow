
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final String? keyValue;
  final EdgeInsets? padding;

  LoadingWidget({this.keyValue, this.padding});

  @override
  Widget build(BuildContext context) {
    return Center(
      key: Key(keyValue ?? 'loading'),
      child: Padding(
        padding: padding ?? EdgeInsets.zero,
        child: CircularProgressIndicator(),
      ),
    );
  }

}