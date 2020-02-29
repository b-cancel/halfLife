class DateTimeFormat{
  static Map<int,String> weekDayToString = {
    1: "Monday",
    2: "Tuesday",
    3: "Wednesday",
    4: "Thursday",
    5: "Friday",
    6: "Saturday",
    7: "Sunday",
  };

  static Map<int,String> monthToString = {
    1: "January",
    2: "February",
    3: "March",
    4: "April",
    5: "May",
    6: "June",
    7: "July",
    8: "August",
    9: "September",
    10: "October",
    11: "November",
    12: "December",
  };

  static String daySuffix(int day){
    if(day == 1 || day == 21 || day == 31) return "st";
    else if(day == 2 || day == 22 || day == 32) return "nd";
    else if (day == 3 || day == 23 || day == 33) return "rd";
    else return "th";
  }
  
  //monday the 1st of december 2020
  static String format(DateTime dateTime){
    String weekStr = weekDayToString[dateTime.weekday];
    String dayStr = dateTime.day.toString();
    dayStr += daySuffix(dateTime.day);
    String monthStr = monthToString[dateTime.month];
    return weekStr + " the " + dayStr + " of " + monthStr;
  }
}