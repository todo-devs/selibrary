import 'dart:convert';
import 'dart:io';

import 'package:html/dom.dart';
import 'package:selibrary/selibrary.dart';

const MCP_PHONE_NUMBER_FF_ADD_URL =
    'https://mi.cubacel.net:8443/AirConnector/rest/AirConnect/addFAFNumber';
const MCP_PHONE_NUMBER_FF_CHANGE_URL =
    'https://mi.cubacel.net:8443/AirConnector/rest/AirConnect/changeFAFNumber';
const MCP_PHONE_NUMBER_FF_DELETE_URL =
    'https://mi.cubacel.net:8443/AirConnector/rest/AirConnect/deleteFAFNumber';

class PhoneNumberFF {
  final Element _element;
  final String _subscriber;

  PhoneNumberFF({
    Element element,
    String subscriber,
  })  : _element = element,
        _subscriber = subscriber;

  final Map<String, String> status = Map();

  String get title => _element.querySelector('h4').text;

  String get phoneNumber =>
      _element.querySelector('input[type="tel"]').attributes['value'];

  String get textAdd => _element.querySelector('a[id="btn-add-ph1"]').text;

  String get textChange =>
      _element.querySelector('a[id="btn-change-ph1"]').text;

  String get textDelete =>
      _element.querySelector('a[id="btn-delete-ph1"]').text;

  void add(String phoneNumber, List<Cookie> cookies) async {
    try {
      final dataMap = Map<String, String>();

      dataMap["numberToAdd"] = phoneNumber;
      dataMap["subscriber"] = _subscriber;
      dataMap["format"] = "jsonp";

      final response = await Net.connection(
        url: MCP_PHONE_NUMBER_FF_ADD_URL,
        dataMap: dataMap,
      );

      final jsonObject = json.decode(response.data);

      final responseCode = jsonObject["responseCode"];

      status["code"] = responseCode as String;
      status["responseMessage"] = jsonObject["responseMessage"] as String;

      if ((responseCode as String) == "124") {
        throw OperationException("$responseCode: Debajo del balance mínimo.");
      }
    } catch (e) {
      throw CommunicationException("${e.message}");
    }
  }

  void change(String phoneNumber, List<Cookie> cookies) async {
    try {
      final dataMap = Map<String, String>();

      dataMap["numberToAdd"] = phoneNumber;
      dataMap["numberToDelete"] = this.phoneNumber;
      dataMap["subscriber"] = _subscriber;
      dataMap["format"] = "jsonp";

      final response = await Net.connection(
        url: MCP_PHONE_NUMBER_FF_CHANGE_URL,
        dataMap: dataMap,
      );
      final jsonObject = json.decode(response.data);

      final responseCode = jsonObject["responseCode"];

      status["code"] = responseCode as String;
      status["responseMessage"] = jsonObject["responseMessage"] as String;

      if ((responseCode as String) == "124") {
        throw OperationException("$responseCode: Debajo del balance mínimo.");
      }
    } catch (e) {
      throw CommunicationException("${e.message}");
    }
  }

  void delete(List<Cookie> cookies) async {
    try {
      final dataMap = Map<String, String>();

      dataMap["numberToDelete"] = phoneNumber;
      dataMap["subscriber"] = _subscriber;
      dataMap["format"] = "jsonp";

      final response = await Net.connection(
        url: MCP_PHONE_NUMBER_FF_CHANGE_URL,
        dataMap: dataMap,
      );
      final jsonObject = json.decode(response.data);

      final responseCode = jsonObject["responseCode"];

      status["code"] = responseCode as String;
      status["responseMessage"] = jsonObject["responseMessage"] as String;

      if ((responseCode as String) == "124") {
        throw OperationException("$responseCode: Debajo del balance mínimo.");
      }
    } catch (e) {
      throw CommunicationException("${e.message}");
    }
  }
}
