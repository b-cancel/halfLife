//flutter
import 'package:flutter/material.dart';

//internal
import 'package:half_life/struct/doses.dart';
import 'package:half_life/doseBody.dart';

//widget
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static Color softHeaderColor = Color(0xFF64ffda);

  @override
  Widget build(BuildContext context) {
    List<Dose> doses = new List<Dose>();

/*
    doses.add(
      Dose(
        0,
        DateTime(
          2020,
          1, //feb
          20, //20
          1, //1 am
        ),
      ),
    );
    */

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

/*
    doses.add(
      Dose(
        0,
        DateTime(
          2020,
          1, //feb
          24, //20
          6, //1 am
        ),
      ),
    );
    */

    doses.add(
      Dose(
        0,
        DateTime(
          2020,
          1, //feb
          24, //20
          22, //1 am
        ),
      ),
    );

    doses.add(
      Dose(
        0,
        DateTime(
          2020,
          1, //feb
          24, //20
          19, //1 am
        ),
      ),
    );

    doses.add(
      Dose(
        0,
        DateTime(
          2020,
          1, //feb
          24, //20
          16, //1 am
        ),
      ),
    );

    doses.add(
      Dose(
        0,
        DateTime(
          2020,
          1, //feb
          24, //20
          13, //1 am
        ),
      ),
    );

    doses.add(
      Dose(
        0,
        DateTime(
          2020,
          1, //feb
          24, //20
          10, //1 am
        ),
      ),
    );

    doses.add(
      Dose(
        0,
        DateTime(
          2020,
          1, //feb
          24, //20
          7, //1 am
        ),
      ),
    );


    doses.add(
      Dose(
        0,
        DateTime(
          2020,
          1, //feb
          24, //20
          4, //1 am
        ),
      ),
    );

    doses.add(
      Dose(
        0,
        DateTime(
          2020,
          1, //feb
          24, //20
          1, //1 am
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
      theme: ThemeData.light().copyWith(
        accentColor: softHeaderColor,
      ),
      home: DosesBody(
        halfLife: Duration(hours: 36),
        doses: doses,
      ),
    );
  }
}