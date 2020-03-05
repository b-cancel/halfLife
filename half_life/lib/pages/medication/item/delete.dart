//flutter
import 'package:flutter/material.dart';

//internal
import 'package:half_life/pages/medication/item/options.dart';
import 'package:half_life/shared/playOnceGif.dart';

//widget
deleteDose(BuildContext context, double dose, DateTime timestamp) {
  showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
        contentPadding: EdgeInsets.all(0),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(12.0),
                  topRight: const Radius.circular(12.0),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: 36,
                  top: 24,
                ),
                child: Container(
                  height: 140,
                  child: PlayGifOnce(
                    assetName: "assets/delete.gif",
                    runTimeMS: 6120,
                    frameCount: 98,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 16.0,
              ),
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(
                  horizontal: 16,
                ),
                child: DefaultTextStyle(
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 26,
                    color: Colors.black,
                  ),
                  child: Text("Delete The Dose?"),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 24.0,
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  top: 8.0,
                  bottom: 16,
                ),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Stack(
                          children: <Widget>[
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  color:
                                      ThemeData.dark().scaffoldBackgroundColor,
                                  fontSize: 18,
                                ),
                                children: [
                                  TextSpan(
                                    text: "Of ",
                                  ),
                                  TextSpan(
                                    text: dose.round().toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                    ),
                                  ),
                                ],
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
                        Text(
                          "   taken on",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    WeekDayYear(
                      dateTime: timestamp,
                      showYear: true,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              "Cancel",
              style: TextStyle(
                color: ThemeData.dark().scaffoldBackgroundColor,
              ),
            ),
          ),
          RaisedButton(
            color: Colors.red,
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              "Delete",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      );
    },
  );
}
