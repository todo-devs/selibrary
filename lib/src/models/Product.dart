import 'dart:io';

import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:selibrary/selibrary.dart';

class Product {
  final Element _element;

  Product({Element element}) : _element = element;

  String get title => _element.querySelector('h4').text;

  String get description => _element
      .querySelector(
          'div[class="offerPresentationProductDescription_msdp product_desc"]')
      .querySelector('span')
      .text;

  double get price => double.parse(_element
      .querySelector(
          'div[class="offerPresentationProductDescription_msdp product_desc"]')
      .querySelector('span[class="bold"]')
      .text);

  String get urlBuyAction => _element
      .querySelector(
          'div[class="offerPresentationProductBuyAction_msdp ptype"]')
      .querySelector(
          'a[class="offerPresentationProductBuyLink_msdp button_style link_button"]')
      .attributes['href'];

  String get urlLongDescriptionAction => _element
      .querySelector(
          'div[class="offerPresentationProductBuyAction_msdp ptype"]')
      .querySelector('a[class="offerPresentationProductBuyLink_msdp"]')
      .attributes['href'];

  static void buy(String urlBuyAction, List<Cookie> cookies) async {
    try {
      var response = await Net.connection(url: MCP_BASE_URL + urlBuyAction);
      var page = parse(response.data);

      final urlBuy = page
          .querySelector(
              'a[class="offerPresentationProductBuyLink_msdp button_style link_button"]')
          .attributes['href'];

      response = await Net.connection(url: MCP_BASE_URL + urlBuy);
      page = parse(response.data);

      final purchaseDetail = page
          .querySelector('div[class="products_purchase_details_block"]')
          .querySelectorAll('p')
          .last
          .text;

      if (purchaseDetail.startsWith("Ha ocurrido un error.")) {
        throw OperationException(purchaseDetail);
      }
    } catch (e) {
      throw CommunicationException("${e.message}");
    }
  }
}
