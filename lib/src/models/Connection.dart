class Connection {
  final String _sessionInit;
  final String _sessionEnd;
  final String _upload;
  final String _download;
  final String _cost;

  Connection({
    String sessionInit,
    String sessionEnd,
    String upload,
    String donwload,
    String cost,
  })  : _sessionInit = sessionInit,
        _sessionEnd = sessionEnd,
        _upload = upload,
        _download = donwload,
        _cost = cost;

  double get cost =>
      double.parse(_cost.replaceAll('\$', '').replaceAll(',', '.'));

  DateTime get sessionEnd {
    final dateTime = _sessionEnd.split(' ');
    final string2 = dateTime[0];
    final string3 = dateTime[1];
    final dayMonthYear = string2.split('/');
    final day = int.parse(dayMonthYear[0]);
    final month = -1 + int.parse(dayMonthYear[1]);
    final year = int.parse(dayMonthYear[2]);
    final hoursMinutesSeconds = string3.split(':');
    final hours = int.parse(hoursMinutesSeconds[0]);
    final minutes = int.parse(hoursMinutesSeconds[1]);
    final seconds = int.parse(hoursMinutesSeconds[2]);

    return DateTime(year, month, day, hours, minutes, seconds);
  }

  DateTime get sessionInit {
    final dateTime = _sessionInit.split(' ');
    final string2 = dateTime[0];
    final string3 = dateTime[1];
    final dayMonthYear = string2.split('/');
    final day = int.parse(dayMonthYear[0]);
    final month = -1 + int.parse(dayMonthYear[1]);
    final year = int.parse(dayMonthYear[2]);
    final hoursMinutesSeconds = string3.split(':');
    final hours = int.parse(hoursMinutesSeconds[0]);
    final minutes = int.parse(hoursMinutesSeconds[1]);
    final seconds = int.parse(hoursMinutesSeconds[2]);

    return DateTime(year, month, day, hours, minutes, seconds);
  }

  Duration get time => sessionEnd.difference(sessionInit);

  String get download => _download;

  String get upload => _upload;
}
