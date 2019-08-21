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
      return "월";
    case DateTime.tuesday:
      return "화";
    case DateTime.wednesday:
      return "수";
    case DateTime.thursday:
      return "목";
    case DateTime.friday:
      return "금";
    case DateTime.saturday:
      return "토";
    case DateTime.sunday:
      return "일";
    default:
      return "Err";
  }
}
