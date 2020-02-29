import 'package:flutter/material.dart';

class ListTileDivider extends StatelessWidget {
  const ListTileDivider({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
      ),
      child: Container(
        height: 1,
        color: ThemeData.dark().scaffoldBackgroundColor,
      )
    );
  }
}