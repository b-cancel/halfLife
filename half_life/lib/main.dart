//flutter
import 'package:flutter/material.dart';

//internal
import 'package:half_life/struct/doses.dart';
import 'package:half_life/doseBody.dart';

//widget
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Dose> doses = new List<Dose>();

    doses.add(
      Dose(
        100,
        DateTime(
          2020,
          2, //feb
          20, //20
          1, //1 am
        ),
      ),
    );

    doses.add(
      Dose(
        25,
        DateTime(
          2020,
          2,
          28,
          4,
        ),
      ),
    );

    doses.add(
      Dose(
        50,
        DateTime(
          2020,
          2, //feb
          21, //21
          1, //1 am
        ),
      ),
    );

    return MaterialApp(
      title: 'Half Life',
      home: DosesBody(
        halfLife: Duration(hours: 36),
        doses: doses,
      ),
    );
  }
}