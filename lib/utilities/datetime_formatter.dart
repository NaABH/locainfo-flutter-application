String dateTimeFormatter(DateTime postedDate) {
  final Duration difference = DateTime.now().difference(postedDate);

  if (difference.inDays > 365) {
    return '${(difference.inDays / 365).floor()} ${(difference.inDays / 365).floor() == 1 ? "year" : "years"} ago';
  } else if (difference.inDays > 30) {
    return '${(difference.inDays / 30).floor()} ${(difference.inDays / 30).floor() == 1 ? "month" : "months"} ago';
  } else if (difference.inDays > 7) {
    return '${(difference.inDays / 7).floor()} ${(difference.inDays / 7).floor() == 1 ? "week" : "weeks"} ago';
  } else if (difference.inDays > 0) {
    return '${difference.inDays} ${difference.inDays == 1 ? "day" : "days"} ago';
  } else if (difference.inHours > 0) {
    return '${difference.inHours} ${difference.inHours == 1 ? "hour" : "hours"} ago';
  } else if (difference.inMinutes > 0) {
    return '${difference.inMinutes} ${difference.inMinutes == 1 ? "minute" : "minutes"} ago';
  } else {
    return 'just now';
  }
}
