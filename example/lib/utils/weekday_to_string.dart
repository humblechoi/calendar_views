String weekdayToString(int weekday) {
  switch (weekday) {
    case DateTime.monday:
      return "월요일";
    case DateTime.tuesday:
      return "화요일";
    case DateTime.wednesday:
      return "수요일";
    case DateTime.thursday:
      return "목요일";
    case DateTime.friday:
      return "Friday";
    case DateTime.saturday:
      return "금요일";
    case DateTime.sunday:
      return "토요일";
    default:
      return "Error";
  }
}

String weekdayToAbbreviatedString(int weekday) {
  switch (weekday) {
    case DateTime.monday:
      return "MON";
    case DateTime.tuesday:
      return "TUE";
    case DateTime.wednesday:
      return "WED";
    case DateTime.thursday:
      return "THU";
    case DateTime.friday:
      return "FRI";
    case DateTime.saturday:
      return "SAT";
    case DateTime.sunday:
      return "SUN";
    default:
      return "Err";
  }
}
