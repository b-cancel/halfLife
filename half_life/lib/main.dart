//flutter
import 'package:flutter/material.dart';

//plugin
import 'package:flutter_villains/villain.dart';
import 'package:bot_toast/bot_toast.dart';

//internal
import 'package:half_life/pages/medication/page.dart';
import 'package:half_life/struct/medication.dart';
import 'package:half_life/struct/doses.dart';

//widget
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //the doses "read in" from the file from the medicine class
    List<Dose> doses = new List<Dose>();
    
    //manually adding all the doses with obvious IDs
    int startID = 0;

    //first dose 100 mg
    doses.add(
      Dose(
        startID,
        100,
        DateTime(
          2020,
          2, //feb
          20, //20
          1, //1 am
        ),
      ),
    );
    startID++;

    //2nd dose adjusted
    //didn't let me sleep
    doses.add(
      Dose(
        startID,
        50,
        DateTime(
          2020,
          2, //feb
          21, //21
          1, //1 am
        ),
      ),
    );
    startID++;

    //dose after hiatus
    //made me really sleep at around 1pm
    doses.add(
      Dose(
        startID,
        25,
        DateTime(
          2020,
          3, //month
          1, //day
          1, //time
        ),
      ),
    );
    startID++;

    //lower to 12mg dose
    //since still with headaches
    doses.add(
      Dose(
        startID,
        12,
        DateTime(
          2020,
          3, //month
          1, //day
          23, //time
        ),
      ),
    );
    startID++;

    //trying to stay at lower dose
    doses.add(
      Dose(
        startID,
        12,
        DateTime(
          2020,
          3, //month
          3, //day
          8, //time
        ),
      ),
    );
    startID++;

    //dose too low
    //crippled with anxiety
    doses.add(
      Dose(
        startID,
        25,
        DateTime(
          2020,
          3, //month
          4, //day
          3, //time
        ),
      ),
    );
    startID++;
    
    //construct the medicine
    //so we can then pass it as if we had read it in
    //and if doing so would let us update things as needed
    AMedication medication = AMedication(
      "Fluvoxamine", 
      doses.last.timeStamp, 
      //between 36 and 60 hours
      Duration(hours: 48),
      //NOTE: lowest and highest are by defualt null
      //we imply null to be 0 for the sake of processing everything
      //but we do that later
      //we don't manually set it to 0
      //this is because for the highest value
      //the upper limit will always be
      //the highest value until the user actually sets it
    );
    medication.doses = doses;

    //build
    return BotToastInit(
      child: MaterialApp(
        title: 'Half Life',
        navigatorObservers: [
          VillainTransitionObserver(),
          BotToastNavigatorObserver(),
        ],
        theme: ThemeData.light().copyWith(
          accentColor: Color(0xFF64ffda),
          textSelectionColor: ThemeData.dark().cardColor,
          //NOTE: you can only set this once aparently
          textSelectionHandleColor: Colors.white,
        ),
        home: AMedicationPage(
          medication: medication,
        ),
      ),
    );
  }
}