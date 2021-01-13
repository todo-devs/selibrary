import 'dart:io';

import 'package:html/dom.dart';
import 'package:selibrary/selibrary.dart';

const MCP_UNSUBSCRIBE_FAF_URL =
    'https://mi.cubacel.net:8443/AirConnector/rest/AirConnect/unSubscribeFAF';

class FamilyAndFriends {
  final Element _element;
  final String _fnfValue;

  FamilyAndFriends({Element element, String fnfValue})
      : _element = element,
        _fnfValue = fnfValue;

  String get title =>
      _element.querySelector('h1[class="page_title_heading mTop10"]').text;

  String get description =>
      _element.querySelector('div[class="col100"]').querySelector('div').text;

  String get subscriber =>
      _element.querySelector('#msisdnValue').attributes['value'];

  int get changesFree => int.parse(_element
      .querySelector('div[class="fnf_history_block"]')
      .querySelector('div[class="col70"]')
      .querySelectorAll('span[class="field_value"]')
      .last
      .text);

  bool get isSubscribe => _fnfValue == 'true';

  List<PhoneNumberFF> get phoneNumbers {
    final list = [];

    for (Element element
        in _element.querySelectorAll('div[class="product_inner_block"]')) {
      list.add(PhoneNumberFF(element: element, subscriber: subscriber));
    }
    return list;
  }

  void unsubscribe(List<Cookie> cookies) async {
    try {
      final dataMap = Map<String, String>();

      dataMap["subscriber"] = subscriber;

      await Net.connection(
        url: MCP_UNSUBSCRIBE_FAF_URL,
        dataMap: dataMap,
      );
    } catch (e) {
      throw CommunicationException("${e.message}");
    }
  }
}
