class Transfer {
  final String _date;
  final String _import;
  final String _destinyAccount;

  Transfer({String date, String import, String destinityAccount})
      : _date = date,
        _import = import,
        _destinyAccount = destinityAccount;

  DateTime get date {
    // Separa la fecha de la hora
    final dateTime = _date.split(' ');
    final date = dateTime[0];
    final time = dateTime[1];

    // Separa el dia, mes y annio
    final dayMonthYear = date.split('/');
    final day = int.parse(dayMonthYear[0]);
    final month = int.parse(dayMonthYear[1]) - 1;
    final year = int.parse(dayMonthYear[2]);

    // Separa horas, minutos y segundos
    final hoursMinutesSeconds = time.split(':');
    final hours = int.parse(hoursMinutesSeconds[0]);
    final minutes = int.parse(hoursMinutesSeconds[1]);
    final seconds = int.parse(hoursMinutesSeconds[2]);

    return DateTime(year, month, day, hours, minutes, seconds);
  }

  double get import =>
      double.parse(_import.replaceAll('\$', '').replaceAll(',', '.'));

  String get destinityAccount => _destinyAccount;
}
