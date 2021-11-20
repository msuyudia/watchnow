import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:watchnow/common/constants.dart';

class SubHeading extends StatelessWidget {
  final String keyValue;
  final String title;
  final Function() onTap;

  SubHeading(this.keyValue, this.title, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: heading6,
        ),
        InkWell(
          key: Key(keyValue),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [Text('See More'), Icon(Icons.arrow_forward_ios)],
            ),
          ),
        ),
      ],
    );
  }
}
