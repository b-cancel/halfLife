//dart
import 'dart:convert';
import 'dart:io';

//flutter
import 'package:flutter/material.dart';

//medication data
class Medications{
  static int nextID;
  static File _excerciseFile;

  //main struct we are maintaining (id -> excercise)
  //NOTE: we could use hashset but its slower than a map for deletion 
  //and accessing specific items
  static Map<int, AnExcercise> _excercises; 
  //NOTE: value notifier here is required since 
  //we listen to order to determine whether we need to update the list
  //NOTE: silly mistake but we need a list, hash set doesn't maintain order
  //TODO: look into perhaps using "LinkedHashSet"
  static ValueNotifier<List<int>> excercisesOrder;

  //lets us control add and removing from the list with more precision
  static Map<int,AnExcercise> getExcercises(){
    return _excercises;
  }

  //we need to make sure that our structure only ever has more than what storage has
  static excercisesInit() async{
    if(_excerciseFile == null){
      //get what the file reference should be
      _excerciseFile = await StringJson.nameToFileReference("excercises");

      //get access to the file
      bool exists = await _excerciseFile.exists();

      //read in file data
      String fileData;
      if(exists == false){
        await _excerciseFile.create();
        //NOTE: don't use safeSave here because 
        //1. we need this to complete before continuing
        //2. we know this file hasn't been written to before 
        //  - since this is its init function
        await _excerciseFile.writeAsString("[]");
      }

      //read in our data
      fileData = await _excerciseFile.readAsString();
      _excercises = Map<int,AnExcercise>();

      //print("-----start");
      //StringPrint.printWrapped(fileData);
      //print("-----end");

      //grab the contacts
      int maxID = 0;
      List<dynamic> map = json.decode(fileData);
      //print("---items: " + map.length.toString());
      for(int i = 0; i < map.length; i++){
        AnExcercise thisExcercise = AnExcercise.fromJson(map[i]);
        maxID = (thisExcercise.id > maxID) ? thisExcercise.id : maxID; 
        await addExcercise(
          thisExcercise, 
          updateOrderAndFile: false, //we update the order at the end
        );
      }
      nextID = (maxID + 1);
      updateOrder();
    }
  }

  //when we are adding all the excercises in on init
  //we dont care to update order until the end
  //and we dont care to update the file since the info came from the file
  static addExcercise(AnExcercise theExcercise, {
    bool updateOrderAndFile: true, 
  })async{
    //give it an ID (IF needed)
    if(theExcercise.id == null){
      theExcercise.id = nextID;
      nextID += 1;
    }

    //print("Adding: " + theExcercise.id.toString() + "---------------");

    //add to excercises
    _excercises[theExcercise.id] = theExcercise;

    //NOTE: since inprogress items are to be viewed above new items
    //we do have to update order
    if(updateOrderAndFile){
      updateOrder();
      updateFile();
    }
  }

  static deleteExcercise(int id){
    if(_excercises.containsKey(id)){
      _excercises.remove(id);

      //update file
      updateOrder();
      updateFile();
    }
    else print("EXCERCISE DOESN'T EXIST");
  }

  //TODO: there is a better way to do this
  static updateOrder(){
    //modify to then sort
    Map<DateTime, int> dateTimeToID = new Map<DateTime, int>();
    List<int> keys = _excercises.keys.toList();
    for(int i = 0; i < keys.length; i++){
      int keyIsID = keys[i];
      AnExcercise excercise = _excercises[keyIsID];
      dateTimeToID[excercise.lastTimeStamp] = keyIsID;
    }

    //sort
    List<DateTime> dates = dateTimeToID.keys.toList();
    Function compare = (DateTime a, DateTime b) => b.compareTo(a);
    dates.sort(compare);
    //NOTE: dates are now sorted

    //initialize the structure we use if needed
    if(excercisesOrder == null){
      excercisesOrder = new ValueNotifier(new List<int>());
    }

    //find the place the new id in its position
    bool allMatch = dates.length == (excercisesOrder?.value ?? 0);
    List<int> newOrder = new List<int>();
    for(int i = 0; i < dates.length; i++){
      DateTime thisDate = dates[i];
      int thisID = dateTimeToID[thisDate];
  
      //check if order matches
      //if it does we save ourselves an extra reload
      allMatch = (allMatch && thisID == excercisesOrder.value[i]);

      //add this id in case not everything matches
      newOrder.add(thisID);
    }

    //official update
    if(allMatch == false) excercisesOrder.value = newOrder;
  }

  //should never have to update from anywhere else
  static updateFile() async {
    String newFileData = _excercisesToString();
    //print("-----------to be written");
    //StringPrint.printWrapped(newFileData);
    //print("--------will write now");
    SafeWrite.write(_excerciseFile, newFileData);
  }

  static String _excercisesToString(){
    List<AnExcercise> excercises = _excercises.values.toList();
    String string = "[";
    //print("------------updating: " + excercises.length.toString());
    for(int i = 0; i < excercises.length; i++){
      String str = json.encode(excercises[i].toJson());
      string += str;
      if(i < (excercises.length - 1)) string += ",";
    }
    string += "]";
    return string;
  }
}