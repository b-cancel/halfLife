import 'package:flutter/material.dart';

class HalfLifeIcon extends StatelessWidget {
  const HalfLifeIcon({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(12.0, 4),
      child: DefaultTextStyle(
        style: TextStyle(
          color: ThemeData.dark().scaffoldBackgroundColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
        child: Stack(
          children: <Widget>[
            Transform.translate(
              offset: Offset(-12, -4),
              child: Text(
                "t",
                style: TextStyle(
                  fontSize: 26,
                ),
              ),
            ),
            Transform.translate(
              offset: Offset(0, 6),
              child: Stack(
                children: [
                  Transform.translate(
                    offset: Offset(0, 0),
                    child: Text(
                      "1",
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(0, 0),
                    child: Text("_"),
                  ),
                  Transform.translate(
                    offset: Offset(0, 12),
                    child: Text("2"),
                  ),
                ]
              ),
            )
          ],
        ),
      ),
    );
  }
}