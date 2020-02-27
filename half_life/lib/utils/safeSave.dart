import 'dart:io';

//lets you write to the same file often 
//without having to worry about whether the previos write has finished
//NOTE: once writing finishes it will write the next NEWEST write
//all the rest will be disposed off
class SafeWrite{
  //keep track of the files current being written to
  static Set<File> _filesWeAreWritingTo = new Set<File>();

  //keep track of the newest waiting data
  static Map<File, String> _fileToNextDataToBeWritten  = new Map<File, String>();

  //NOTE: this assumes that the file atleast exists
  static write(File file, String data){
    //If the file is already being written to
    if(_filesWeAreWritingTo.contains(file)){
      //save our data for writing after it completes
      //NOTE: may have overwritten old waiting data
      _fileToNextDataToBeWritten[file] = data;
    }
    else _writeToFile(file, data);
  }

  //write to file is a seperate function so we can easily recurse
  static _writeToFile(file, data) async {
    //mark this file as being written into
    _filesWeAreWritingTo.add(file);

    //write into it
    await file.writeAsString(
      data,
      //overwrite the file if its already been written to and opens it only for writing
      mode: FileMode.writeOnly,
      //ensure data integrity but takes a bit longer
      flush: true,
    );

    //once finished check if something else was waiting
    if(_fileToNextDataToBeWritten.containsKey(file)){
      //grab data waiting
      String data = _fileToNextDataToBeWritten.remove(file);
      //NOTE: we keep the being written to flag on
      _writeToFile(file, data);
    }
    else{ //we finished writing to this file (for now)
      _filesWeAreWritingTo.remove(file);
    }
  }
}