export 'Exceptions.dart';
export 'Constants.dart';

import 'package:html/dom.dart';

import 'package:html/parser.dart';

int creditToInt(String credit) {
  return int.parse(credit
      .replaceAll('\$', '')
      .replaceAll(' CUC', '')
      .replaceAll(' CUP', '')
      .replaceAll(',', ''));
}

List<Element> getOperationList(Element tableConnectionList) {
  final operations = tableConnectionList.querySelectorAll('tr');
  operations.removeAt(0);
  return operations;
}

String buildYearMonth(int year, int month) {
  if (month <= 9) {
    return "$year-0$month";
  } else {
    return "$year-$month";
  }
}

String findError(Document page, String _type) {
  final err = page.querySelectorAll('script').last;
  final txt = err.text.replaceAll("toastr.error('", '').replaceAll("');", '');
  final error =
      parse(txt).querySelectorAll('li').map((e) => e.text).toList().last;

  return error;
}

Map<String, String> getSessionParameters(Document page) {
  final inputs = page.querySelectorAll('input');

  final data = Map<String, String>();

  final entries =
      inputs.map((e) => MapEntry(e.attributes['name'], e.attributes['value']));

  data.addEntries(entries);

  return data;
}
