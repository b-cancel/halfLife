//flutter
import 'package:flutter/material.dart';

//widget
class PillSubtitle extends StatelessWidget {
  const PillSubtitle({
    Key key,
    @required this.activeDoseAfter,
    @required this.dose,
  }) : super(key: key);

  final double activeDoseAfter;
  final double dose;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          (activeDoseAfter - dose).round().toString(),
        ),
        Icon(
          Icons.arrow_right,
        ),
        ClipRRect(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          child: Container(
            height: 20,
            child: Row(
              children: [
                Container(
                  width: 16,
                  color: ThemeData.dark().primaryColorLight,
                ),
                Container(
                  color: Theme.of(context).accentColor,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(
                    horizontal: 8,
                  ),
                  child: Container(
                    padding: EdgeInsets.only(
                      right: 10,
                    ),
                    child: DefaultTextStyle(
                      style: TextStyle(
                        color: ThemeData.dark().scaffoldBackgroundColor,
                      ),
                      child: Stack(
                        children: [
                          Text(
                            dose.round().toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Transform.translate(
                              offset: Offset(8, 2),
                              child: Text(
                                "u",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 16,
                  color: ThemeData.dark().scaffoldBackgroundColor,
                ),
              ],
            ),
          ),
        ),
        Icon(
          Icons.arrow_right,
        ),
        Text(
          activeDoseAfter.round().toString(),
        ),
      ],
    );
  }
}
