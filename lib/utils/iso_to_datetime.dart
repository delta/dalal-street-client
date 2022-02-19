// ignore: non_constant_identifier_names
String ISOtoDateTime(String createdAt) {
  DateTime createdAtTime = DateTime.parse(createdAt);
  DateTime currentTime = DateTime.now();
  Duration diff = currentTime.difference(createdAtTime);
  int hourDifference = diff.inHours - (diff.inDays * 24);
  if (diff.inDays == 0) {
    if (diff.inHours == 0) {
      return (diff.inMinutes.toString() + ' minutes ago');
    } else if (diff.inHours == 1) {
      return (diff.inHours.toString() + ' hour ago');
    } else {
      return (diff.inHours.toString() + ' hours ago');
    }
  } else {
    return (diff.inDays.toString() +
        ' days' +
        '  ' +
        hourDifference.toString() +
        '  '
            'hours ago');
  }
}
