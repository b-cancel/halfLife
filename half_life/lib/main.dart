//dart
import 'dart:math' as math;

//flutter
import 'package:flutter/material.dart';

//plugins
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:half_life/headerChart.dart';

//internal
import 'package:half_life/struct/doses.dart';
import 'package:half_life/utils/goldenRatio.dart';

//widget
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Half Life',
      home: MyHomePage(),
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
    
    //grab heights and all
    double statusBarHeight = MediaQuery.of(context).padding.top;
    double bottomBarHeight = 36;
    List<double> bigSmall = measurementToGoldenRatioBS(MediaQuery.of(context).size.height);

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Color(0xFFA8E6CF),
            //the top title (is basically the bottom AppBar)
            //NOTE: leading to left of title
            //NOTE: title in middle
            //NOTE: action to right of title

            //don't show extra top padding
            primary: false,
            //only show shadow if content below
            forceElevated: false,
            //snapping is annoying and disorienting
            //but the opposite is ugly
            snap: false,
            //on se we can always add a dose and change the medication settings
            pinned: true,
            //might make it open in annoying times (so we turn it off)
            floating: false, 
            //tool bar
            bottom: PreferredSize(
              preferredSize: Size(
                MediaQuery.of(context).size.width, 
                bottomBarHeight,
              ),
              child: Material(
                color: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.settings), 
                      onPressed: (){
                        print("change active dose");
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.add), 
                      onPressed: (){
                        print("add dose");
                      },
                    ),
                  ]
                ),
              ),
            ),
            //most of the screen
            expandedHeight: bigSmall[0],
            //the graph
            flexibleSpace: FlexibleSpaceBar(
              //scaling title
              centerTitle: true,
              title: Text(
                "Doses",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
              titlePadding: EdgeInsets.only(
                bottom: 12,
              ),
              
              //pin, pins on bottom
              //parallax keeps the background centered within flexible space
              collapseMode: CollapseMode.parallax,
              //TODO: check if this is working at all
              stretchModes: [
                StretchMode.blurBackground,
                StretchMode.fadeTitle,
                StretchMode.zoomBackground,
              ],
              //the background with the graph and active dose
              background: Stack(
                children: <Widget>[
                  Container(
                    height: bigSmall[0],
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(
                      top: statusBarHeight,
                      bottom: bottomBarHeight,
                    ),
                    child: HeaderChart(
                      doses: doses,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Flexible(
                        flex: smallNumber,
                        child: Container(),
                      ),
                      Text(
                        "AD",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      Flexible(
                        flex: largeNumber,
                        child: Container(),
                      ),
                    ],
                  )
                ],
              ),
              
            ),
            
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                  Container(
                    color: Colors.red,
                    height: 48,
                    width: MediaQuery.of(context).size.width,
                  ),
                  Container(
                    color: Colors.blue,
                    height: 48,
                    width: MediaQuery.of(context).size.width,
                  ),
                  Container(
                    color: Colors.red,
                    height: 48,
                    width: MediaQuery.of(context).size.width,
                  ),
                  Container(
                    color: Colors.blue,
                    height: 48,
                    width: MediaQuery.of(context).size.width,
                  ),
                  Container(
                    color: Colors.red,
                    height: 48,
                    width: MediaQuery.of(context).size.width,
                  ),
                  Container(
                    color: Colors.blue,
                    height: 48,
                    width: MediaQuery.of(context).size.width,
                  ),
                  Container(
                    color: Colors.red,
                    height: 48,
                    width: MediaQuery.of(context).size.width,
                  ),
                  Container(
                    color: Colors.blue,
                    height: 48,
                    width: MediaQuery.of(context).size.width,
                  ),
                  Container(
                    color: Colors.red,
                    height: 48,
                    width: MediaQuery.of(context).size.width,
                  ),
                  Container(
                    color: Colors.blue,
                    height: 48,
                    width: MediaQuery.of(context).size.width,
                  ),
                  Container(
                    color: Colors.blue,
                    height: 48,
                    width: MediaQuery.of(context).size.width,
                  ),
                  Container(
                    color: Colors.red,
                    height: 48,
                    width: MediaQuery.of(context).size.width,
                  ),
                  Container(
                    color: Colors.blue,
                    height: 48,
                    width: MediaQuery.of(context).size.width,
                  ),
                  Container(
                    color: Colors.red,
                    height: 48,
                    width: MediaQuery.of(context).size.width,
                  ),
                  Container(
                    color: Colors.blue,
                    height: 48,
                    width: MediaQuery.of(context).size.width,
                  ),
                  Container(
                    color: Colors.blue,
                    height: 48,
                    width: MediaQuery.of(context).size.width,
                  ),
                  Container(
                    color: Colors.red,
                    height: 48,
                    width: MediaQuery.of(context).size.width,
                  ),
                  Container(
                    color: Colors.blue,
                    height: 48,
                    width: MediaQuery.of(context).size.width,
                  ),
                  Container(
                    color: Colors.red,
                    height: 48,
                    width: MediaQuery.of(context).size.width,
                  ),
                  Container(
                    color: Colors.blue,
                    height: 48,
                    width: MediaQuery.of(context).size.width,
                  ),
              ]
            ),
          ),
          SliverFillRemaining(
            hasScrollBody: false, //it should be as small as possible
            fillOverscroll: false, //only if above is false
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Icon(FontAwesomeIcons.prescriptionBottle),
              ),
            )
          )
        ],
      ),
      /*
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
      */
    );
  }
}
