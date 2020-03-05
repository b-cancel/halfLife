class Dose{
  int id;
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
    return id.toString() + ": " + value.toString() + " @ " + timeStamp.toString();
  }

  Dose(
    int id,
    double value,
    DateTime timeStamp,
  ){
    this.id = id;
    this.value = value;
    this.timeStamp = timeStamp;
  }
}