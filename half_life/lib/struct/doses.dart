class Dose{
  double value;
  DateTime timeStamp;

  int compareTo(Dose anotherDose){
    DateTime otherTimeStamp = anotherDose.timeStamp;
    if(timeStamp.difference(otherTimeStamp) == Duration.zero){
      return 0;
    }
    else{
      if(timeStamp.isBefore(otherTimeStamp)) return 1;
      else return -1;
    }
  }

  toString(){
    return value.toString() + " @ " + timeStamp.toString();
  }

  Dose(
    double value,
    DateTime timeStamp,
  ){
    this.value = value;
    this.timeStamp = timeStamp;
  }
}

/*
//one created for each pixel in the width
class DosePoint{
  int pointID;
  double dosage;

  DosePoint(
    int pointID,
    double dosage,
  ){
    this.pointID = pointID;
    this.dosage = dosage;
  }
}
*/