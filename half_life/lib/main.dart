//flutter
import 'package:flutter/material.dart';
import 'package:flutter_villains/villain.dart';

//internal
import 'package:half_life/struct/doses.dart';
import 'package:half_life/doseBody.dart';

//widget
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Dose> doses = new List<Dose>();
    List<int> iDs = [4,21,6,2,5,1,9,23,85,293,0];

    doses.add(
      Dose(
        iDs[0],
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
        iDs[1],
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
        iDs[2],
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
        iDs[3],
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
        iDs[4],
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
        iDs[5],
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
        iDs[6],
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
        iDs[7],
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
        iDs[8],
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
        iDs[9],
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
        iDs[10],
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
      navigatorObservers: [
        VillainTransitionObserver(),
      ],
      theme: ThemeData.light().copyWith(
        accentColor: Color(0xFF64ffda),
      ),
      home: DosesBody(
        halfLife: Duration(hours: 36),
        doses: doses,
      ),
    );
  }
}