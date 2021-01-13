import 'package:html/dom.dart';

class ETECSAPackage {
  final Element _element;
  final bool _bonusPackage;

  Element _expireDateBlock;
  Element _expireDateBlockRed;
  Element _expireDateBlockOrange;

  String _mTitle;

  ETECSAPackage({
    Element element,
    bool bonusPackage,
  })  : _element = element,
        _bonusPackage = bonusPackage {
    _expireDateBlock =
        _element.querySelector('div[class="expires_date_block"]');

    _expireDateBlockRed =
        element.querySelector('div[class="expires_date_block red_bg"]');

    _expireDateBlockOrange =
        element.querySelector('div[class="expires_date_block orange_bg"]');
  }

  bool get isStatusRed =>
      (_expireDateBlock == null && _expireDateBlockOrange == null);

  bool get isStatusOrange =>
      (_expireDateBlock == null && _expireDateBlockRed == null);

  String get packageId => _element
      .querySelector('div[class="charts_data"]')
      .querySelectorAll('div')[0]
      .attributes['id'];

  bool get isBonusPackage => _bonusPackage;

  String get title => _mTitle;
  set title(String value) {
    _mTitle = value;
  }

  String get description =>
      _element.querySelector('div[class="features_block"]').text;

  String get dataInfo => _element
      .querySelector('div[class="charts_data"]')
      .querySelector('div[id="$packageId"]')
      .attributes['data-info'];

  double get restData => double.parse(_element
      .querySelector('div[class="charts_data"]')
      .querySelector('div[id="$packageId"]')
      .attributes['data-text']);

  int get percent => int.parse(_element
      .querySelector('div[class="charts_data"]')
      .querySelector('div[id="$packageId"]')
      .attributes['data-percent']);

  int get expireInDate {
    if (isStatusRed)
      return int.parse(
          _expireDateBlockRed.querySelector('div[class="expires_date"]').text);

    if (isStatusOrange)
      return int.parse(_expireDateBlockOrange
          .querySelector('div[class="expires_date"]')
          .text);

    return int.parse(
        _expireDateBlock.querySelector('div[class="expires_date"]').text);
  }

  String get expireInHours {
    if (isStatusRed)
      return _expireDateBlockRed
          .querySelector('div[class="expires_hours"]')
          .text;

    if (isStatusOrange)
      return _expireDateBlockOrange
          .querySelector('div[class="expires_hours"]')
          .text;

    return _expireDateBlock.querySelector('div[class="expires_hours"]').text;
  }

  String get expireDate => _element
      .querySelector('div[class="expiry_date_right"]')
      .querySelector('span[class="date_value"]')
      .text
      .trim();
}
