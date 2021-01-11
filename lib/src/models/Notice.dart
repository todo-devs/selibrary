import 'dart:html';

import 'package:html/dom.dart';
import 'package:selibrary/src/selibrary.dart';

class Notice {
  final Element _element;

  Notice({Element element}) : _element = element;

  String get title => _element.querySelector('a').attributes['title'];

  String get url => _element.querySelector('a').attributes['href'];

  Future<List<int>> get img async {
    return await Net.getImage(_element
        .querySelector('img[class="img-responsive"]')
        .attributes['src']);
  }
}
