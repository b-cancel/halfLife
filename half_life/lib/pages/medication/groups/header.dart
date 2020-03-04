//flutter
import 'package:flutter/material.dart';

//internal
import 'package:half_life/shared/curvedCorner.dart';

//widget
class GroupHeader extends StatelessWidget {
  const GroupHeader({
    Key key,
    @required this.month,
    @required this.year,
  }) : super(key: key);

  final String month;
  final String year;

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = ThemeData.dark().primaryColorDark;

    //build
    return Stack(
      children: <Widget>[
        Container(
          color: backgroundColor,
          padding: new EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: 8,
          ),
          alignment: Alignment.bottomLeft,
          child: DefaultTextStyle(
            style: TextStyle(
              fontSize: 16,
              color: Colors.white, 
              fontWeight: FontWeight.bold,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  month,
                ),
                Text(
                  year,
                )
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Transform.translate(
              offset: Offset(0, 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  CurvedCorner(
                    isTop: true,
                    isLeft: true,
                    cornerColor: backgroundColor,
                  ),
                  CurvedCorner(
                    isTop: true,
                    isLeft: false,
                    cornerColor: backgroundColor,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}