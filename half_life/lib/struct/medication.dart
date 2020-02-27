//internal
import 'package:half_life/struct/data.dart';

//class
class AMedication{
  //NOTE: this is saved by the addExcercise function
  int id;

  String _name;
  String get name => _name;
  set name(String newName){
    _name = newName;
    Medications.updateFile();
  }
  
  int _setTarget;
  int get setTarget => _setTarget;
  set setTarget(int newSetTarget){
    _setTarget = newSetTarget;
    Medications.updateFile();
  }

  //temp start time
  DateTime _tempStartTime;
  DateTime get tempStartTime => _tempStartTime;
  set tempStartTime(DateTime newTempStartTime){
    DateTime newValue = newTempStartTime;
    _tempStartTime = newValue;
    Medications.updateFile();
  }

  //build
  AMedication(
    //basic data
    String name, 
    String url, 
    String note,

    //other
    int predictionID,
    int repTarget,
    Duration recoveryPeriod,
    int setTarget,

    //date time
    DateTime lastTimeStamp,
  ){
    //variables that have notifiers 
    //that are required to have atleast a default value
    _tempStartTime = nullDateTime;

    //required to pass variables
    _name = name;
    _setTarget = setTarget;

    //NOTE: the update to the file should only happen after everything else
    this.lastTimeStamp = lastTimeStamp;
  }

  //NOTE: from here we MUST set things directly to the private variables
  AMedication.fromJson(Map<String,dynamic> map){
    id = map["id"];
    _name = map["name"];
    _setTarget = map["setTarget"];
    _tempStartTime = _stringToDateTime(map["tempStartTime"]);
  }

  DateTime _stringToDateTime(String json){
    if(json == null || json == "null") return null;
    else return DateTime.parse(json);
  }

  Map<String, dynamic> toJson(){
    return {
      "id": id,
      "name": name,
      "setTarget": setTarget,
      "tempStartTime": _dateTimeToString(tempStartTime),
    };
  }

  static String _dateTimeToString(DateTime dt){
    if(dt == null) return null; //NOTE: legacy code
    else return dt?.toIso8601String() ?? null;
  }
}