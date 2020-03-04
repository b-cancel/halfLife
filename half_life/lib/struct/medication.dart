import 'package:half_life/struct/doses.dart';

class AMedication{
  int id;

  //medication name
  String _name;
  String get name => _name;
  set name(String newName){
    _name = newName;
    print("updatefile");
    //Medications.updateFile();
  }

  //last dose
  DateTime _lastDoseDateTime;
  DateTime get lastDoseDateTime => _lastDoseDateTime;
  set lastDoseDateTime(DateTime newLastDoseDateTime){
    _lastDoseDateTime = newLastDoseDateTime;
    print("updatefile");
    //Medications.updateFile();
  }
  
  //half life
  Duration _halfLife;
  Duration get halfLife => _halfLife;
  set halfLife(Duration newHalfLife){
    _halfLife = newHalfLife;
    print("updatefile");
    //Medications.updateFile();
  }

  List<Dose> doses;

  //highest dose
  int _lowestDose;
  int get lowestDose => _lowestDose;
  set lowestDose(int newLowestDose){
    _lowestDose = newLowestDose;
    print("updatefile");
    //Medications.updateFile();
  }

  //highest dose
  int _highestDose;
  int get highestDose => _highestDose;
  set highestDose(int newHighestDose){
    _highestDose = newHighestDose;
    print("updatefile");
    //Medications.updateFile();
  }

  //build
  AMedication(
    String name, 
    DateTime lastDoseDateTime, 
    Duration halfLife,
  ){
    _name = name;
    _lastDoseDateTime = lastDoseDateTime;
    _halfLife = halfLife;
  }

  //NOTE: from here we MUST set things directly to the private variables
  AMedication.fromJson(Map<String,dynamic> map){
    id = map["id"];
    _name = map["name"];
    _halfLife = map["halfLife"];
    _lastDoseDateTime = _stringToDateTime(map["lastDoseDateTime"]);
  }

  DateTime _stringToDateTime(String json){
    if(json == null || json == "null") return null;
    else return DateTime.parse(json);
  }

  Map<String, dynamic> toJson(){
    return {
      "id": id,
      "name": name,
      "halfLife": halfLife,
      "lastDoseDateTime": _dateTimeToString(lastDoseDateTime),
    };
  }

  static String _dateTimeToString(DateTime dt){
    if(dt == null) return null; //NOTE: legacy code
    else return dt?.toIso8601String() ?? null;
  }
}