class DurationFormat{
  static List<String> _indexToShort = [
    "y","m","w","d","h","m","s","milli","micro"
  ];

  static List<String> _indexToMedium = [
    "yr", "mth", "wk", "day", "hr", 
    "min", "sec", "millisec", "microsec",
  ];

  static List<String> _indexToLong = [
    "year", "month", "week", "day", "hour", 
    "minute", "second", "millisecond", "microsecond"
  ];

  static Map<int,String> weekDayToString = {
    1: "Monday",
    2: "Tuesday",
    3: "Wednesday",
    4: "Thursday",
    5: "Friday",
    6: "Saturday",
    7: "Sunday",
  };

  static String format(Duration timeSince, {
    bool showYears: true, //365 days
    bool showMonths: true, //30 days
    bool showWeeks: true, //7 days
    bool showDays: true, //24 hrs
    bool showHours: true, //60 minutes
    bool showMinutes: true, //60 seconds
    bool showSeconds: true, //1000 milliseconds
    bool showMilliseconds: false,
    bool showMicroseconds: false,
    //long or short?
    int len: 0,
    bool spaceBetween: false,
  }){
    if(timeSince > Duration.zero){
      //setup vars
      int years = 0;
      int months = 0;
      int weeks = 0;
      int days = 0;
      int hours = 0;
      int minutes = 0;
      int seconds = 0;
      int milliseconds = 0;
      int microseconds = 0;

      //digest it given the variables
      if(showYears && timeSince.inDays > 0){
        years = timeSince.inDays ~/ 365;
        timeSince = timeSince - Duration(days: (365 * years));
      }

      if(showMonths && timeSince.inDays > 0){
        months = timeSince.inDays ~/ 30;
        timeSince = timeSince - Duration(days: (30 * months));
      }

      if(showWeeks && timeSince.inDays > 0){
        weeks = timeSince.inDays ~/ 7;
        timeSince = timeSince - Duration(days: (7 * weeks));
      }

      if(showDays && timeSince.inDays > 0){
        days = timeSince.inDays;
        timeSince = timeSince - Duration(days: days);
      }

      if(showHours && timeSince.inHours > 0){
        hours = timeSince.inHours;
        timeSince = timeSince - Duration(hours: hours);
      }

      if(showMinutes && timeSince.inMinutes > 0){
        minutes = timeSince.inMinutes;
        timeSince = timeSince - Duration(minutes: minutes);
      }

      if(showSeconds && timeSince.inSeconds > 0){
        seconds = timeSince.inSeconds;
        timeSince = timeSince - Duration(seconds: seconds);
      }

      if(showMilliseconds && timeSince.inMilliseconds > 0){
        milliseconds = timeSince.inMilliseconds;
        timeSince = timeSince - Duration(milliseconds: milliseconds);
      }

      if(showMilliseconds && timeSince.inMicroseconds > 0){
        microseconds = timeSince.inMicroseconds;
      }

      //create string
      String output = "";
      List<int> times = [
        years, 
        months, 
        weeks, 
        days, 
        hours, 
        minutes, 
        seconds, 
        milliseconds, 
        microseconds,
      ];
      
      //loop through and generate
      for(int i = 0; i < times.length; i++){
        int value = times[i];
        if(value != 0){
          //return descrip
          String description;
          if(len == 0) description = _indexToShort[i];
          else if(len == 1) description = _indexToMedium[i];
          else description = _indexToLong[i];
          

          //add s and space
          description += (value > 1) ? "s" : "";
          description = ((spaceBetween) ? " " : "") + description;

          //output
          output += (times[i].toString() + description);
          output += (spaceBetween) ? " and " : " ";
        }
      }
      if(output != "" && spaceBetween){
        output = output.substring(0, output.length - 5);
      }

      //return stuffs
      if(output == "") return "Today";
      else return output;
    }
    else return "Archived";
  }
}