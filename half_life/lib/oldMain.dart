/*
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:half_life/struct/doses.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime now;
  Duration halfLife = Duration(hours: 36);
  List<Dose> doses = new List<Dose>();
  int maxActiveDose = 40;

  @override
  void initState() {
    now = DateTime.now();

    doses.add(Dose(100, DateTime(
      2020,
      2, //feb
      20, //20
      1 //1 am
    )));

    doses.add(Dose(50, DateTime(
      2020,
      2, //feb
      21, //21
      1 //1 am
    )));

    doses.add(Dose(25, DateTime(
      2020,
      2,
      28,
      4,
    )));

    super.initState();
  }

  double sliderValue = 1;
  int dosesBeingConsidered;
  DateTime firstDose;
  Duration elapsedTime;
  DateTime lastDateTime;

  calcActiveDose(){
    firstDose = doses[0].timeStamp;
    Duration timeSinceFirst = DateTime.now().difference(firstDose);
    elapsedTime = Duration(
      microseconds: (timeSinceFirst.inMicroseconds * sliderValue).round(),
    );
    lastDateTime = firstDose.add(elapsedTime);
    
    //loop through doses to calculate 
    //how much we have left of each after the selected time
    double totalDose = 0;
    dosesBeingConsidered = 0;
    for(int i = 0; i < doses.length; i++){
      bool doseBefore = doses[i].timeStamp.isBefore(lastDateTime);
      bool doseAt = doses[i].timeStamp.difference(lastDateTime) == Duration.zero;
      if(doseBefore || doseAt){
        dosesBeingConsidered++;

        int dose = doses[i].value;
        DateTime timeTaken = doses[i].timeStamp;
        Duration timeSinceTaken = lastDateTime.difference(timeTaken);

        //allways use duration in microseconds
        double decayConstant = math.log(2) / halfLife.inMicroseconds;
        double exponent = -decayConstant * timeSinceTaken.inMicroseconds;
        double dosageLeft = dose * math.pow(math.e, exponent);

        totalDose += dosageLeft;
      }
      //ELSE: we don't count it
    }

    return totalDose;
  }

  @override
  Widget build(BuildContext context) {
    double activeDose = calcActiveDose();
    double maxDose = maxActiveDose - activeDose;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Your first dose was on: " + firstDose.toString()),
            Text("and after: " + elapsedTime.toString()),
            Text("on: " + lastDateTime.toString()),
            Text("you had only taken: " + dosesBeingConsidered.toString() + " doses"),
            Text("and your active dose was: " + activeDose.toString()),
            Text("Max Active Dose: " + maxActiveDose.toString()),
            Text("Max Dose To Take To Stay Below Max Active Dose"),
            Text(maxDose.toString()),
            Slider(
              min: 0,
              max: 1,
              value: sliderValue, 
              onChanged: (double newValue) {
                setState(() {
                  sliderValue = newValue;
                });
              },
            ),
          ],
        )
      ),
    );
  }
}

*/