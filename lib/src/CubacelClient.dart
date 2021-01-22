import 'dart:convert';

import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:selibrary/selibrary.dart';

const ETECSA_HOME_PAGE_URL = "http://www.etecsa.cu";

const MCP_LOGIN_URL = "https://mi.cubacel.net:8443/login/Login";

const MCP_WELCOME_LOGIN_ES_URL =
    "https://mi.cubacel.net:8443/login/jsp/welcome-login.jsp?language=es";

const MCP_FORGOT_URL =
    "https://mi.cubacel.net:8443/login/jsp/forgot-password.jsp";

const MCP_FORGOT_ACTION_URL =
    "https://mi.cubacel.net:8443/login/recovery/ForgotPassword";

const MCP_RESET_PASSWORD_URL =
    "https://mi.cubacel.net:8443/login/recovery/ResetPassword";

const MCP_SIGN_UP_URL = "https://mi.cubacel.net:8443/login/jsp/registerNew.jsp";

const MCP_SIGN_UP_ACTION_URL =
    "https://mi.cubacel.net:8443/login/NewUserRegistration";

const MCP_VERIFY_REGISTRATION_CODE_URL =
    "https://mi.cubacel.net:8443/login/VerifyRegistrationCode";

const MCP_REGISTER_PASSWORD_CREATION_URL =
    "https://mi.cubacel.net:8443/login/recovery/RegisterPasswordCreation";

const MCP_LOAN_ME_URL =
    "https://mi.cubacel.net:8443/AirConnector/rest/AirConnect/loanMe";

abstract class ICubacelClient {
  Document _currentPage;
  Document _homePage;
  Document _myAccountPage;
  Document _newsPage;
  Document _productsPage;
  String updated;

  Map<String, String> _urlsMCP = Map();

  Function saveData;

  Map<String, dynamic> get asJson {
    return {
      'currentPage': _currentPage?.outerHtml,
      'homePage': _homePage?.outerHtml,
      'myAccountPage': _myAccountPage?.outerHtml,
      // 'productsPage': _productsPage?.outerHtml,
      'updated': updated,
      'urlsMCP': _urlsMCP,
    };
  }

  void loadFromJson(Map<String, dynamic> data) {
    this._currentPage = parse(data['currentPage']);
    this._homePage = parse(data['homePage']);
    this._myAccountPage = parse(data['myAccountPage']);
    // this._productsPage = parse(data['productsPage']);
    this.updated = data['updated'];
    this._urlsMCP = Map.castFrom(data['urlsMCP']);
  }

  String get dateTimeNow {
    var now = DateTime.now();

    final hour =
        (now.hour % 12 == 0 ? 12 : now.hour % 12).toString().padLeft(2, '0');

    final min = now.minute.toString().padLeft(2, '0');

    var tt = 'AM';
    if (now.hour >= 12) {
      tt = 'PM';
    }

    final day = now.day.toString().padLeft(2, '0');
    final month = now.month.toString().padLeft(2, '0');
    final year = now.year;

    return '$day/$month/$year $hour:$min $tt';
  }

  Map<String, String> get urls => _urlsMCP;

  List<Element> get _myAccountDetailsBlock =>
      _myAccountPage.querySelectorAll('div[class="myaccount_details_block"]');

  List<Element> get _divsCol1a =>
      _myAccountPage.querySelectorAll('div[class="col1a"]');

  List<Element> get _divsCol2a =>
      _myAccountPage.querySelectorAll('div[class="col2a"]');

  String get _script => _myAccountPage.querySelectorAll('script').last.text;

  String get welcomeMessage => _homePage
      .querySelector('div[class="banner_bg_color mBottom20"]')
      .querySelector('h2')
      .text;

  String get userName {
    String username = welcomeMessage
        .replaceFirst('Bienvenido', '')
        .replaceFirst('a MiCubacel', '')
        .trim();

    return username;
  }

  String get phoneNumber {
    for (var div in _myAccountDetailsBlock) {
      if (div
          .querySelector('div[class="mad_row_header"]')
          .querySelector('div[class="col1"]')
          .text
          .startsWith('Mi Cuenta')) {
        return div
            .querySelector('div[class="mad_row_footer"]')
            .querySelector('div[class="col1"]')
            .querySelector('span[class="cvalue"]')
            .text;
      }
    }
    return '';
  }

  String get credit {
    for (var div in _myAccountDetailsBlock) {
      if (div
          .querySelector('div[class="mad_row_header"]')
          .querySelector('div[class="col1"]')
          .text
          .startsWith('Mi Cuenta')) {
        return div
            .querySelector('div[class="mad_row_header"]')
            .querySelector('div[class="col2"]')
            .querySelector('span[class="cvalue bold cuc-font"]')
            .text;
      }
    }
    return '';
  }

  String get expire {
    for (var div in _myAccountDetailsBlock) {
      if (div
          .querySelector('div[class="mad_row_header"]')
          .querySelector('div[class="col1"]')
          .text
          .startsWith('Mi Cuenta')) {
        return div
            .querySelector('div[class="mad_row_footer"]')
            .querySelector('div[class="col2"]')
            .querySelector('span[class="cvalue"]')
            .text;
      }
    }
    return '';
  }

  String get creditBonus {
    for (var div in _myAccountDetailsBlock) {
      if (div
              .querySelector('div[class="mad_row_header"]')
              .querySelectorAll('div[class="col1"]')
              .isNotEmpty &&
          div
              .querySelector('div[class="mad_row_header"]')
              .querySelector('div[class="col1"]')
              .text
              .startsWith('Bono')) {
        return div
            .querySelector('div[class="mad_row_header"]')
            .querySelector('div[class="col2"]')
            .querySelector('span[class="cvalue bold cuc-font"]')
            .text;
      }
    }
    return '';
  }

  String get expireBonus {
    for (var div in _myAccountDetailsBlock) {
      if (div
              .querySelector('div[class="mad_row_header"]')
              .querySelectorAll('div[class="col1"]')
              .isNotEmpty &&
          div
              .querySelector('div[class="mad_row_header"]')
              .querySelector('div[class="col1"]')
              .text
              .startsWith('Bono')) {
        return div
            .querySelector('div[class="mad_row_footer"]')
            .querySelector('div[class="col2"]')
            .querySelector('span[class="cvalue"]')
            .text;
      }
    }
    return '';
  }

  String get date {
    for (var div in _divsCol1a) {
      if (div.text.startsWith('Fecha del Adelanto: ')) {
        return div.querySelector('span[class="cvalue bold"]').text;
      }
    }
    return '';
  }

  String get payableBalance {
    for (var div in _divsCol2a) {
      if (div.text.startsWith('Saldo pendiente por pagar: ')) {
        return div.querySelector('span[class="cvalue bold cuc-font"]').text;
      }
    }
    return '';
  }

  bool get isActiveBonusServices {
    int indexOf;
    var substring = '';
    String onOff;

    var indexOf2 = _script.indexOf("'false'; prop=");

    if (indexOf2 != -1) {
      substring = _script.substring(indexOf2);
    }

    indexOf2 = substring.indexOf("prop=");

    if (indexOf2 != -1) {
      substring = substring.substring(indexOf2);
      indexOf = substring.indexOf(";");

      if (indexOf != -1) {
        onOff = substring.substring(0, indexOf);
        onOff = onOff.split("=")[1].replaceAll("'", "");
        return onOff == "true";
      }
    }
    return false;
  }

  List<Product> get products {
    final List<Product> list = [];
    for (Element element
        in _productsPage.querySelectorAll('div[class="product_inner_block"]')) {
      list.add(Product(element: element));
    }
    return list;
  }

  List<Notice> get news {
    List<Notice> list = [];

    list.add(Notice(
        element: _newsPage
            .querySelector('div[class="carousel-inner"]')
            .querySelector("div[class=\"item active\"]")));

    for (var notice in _newsPage
        .querySelector('div[class="carousel-inner"]')
        .querySelectorAll('div[class="item"]')) {
      list.add(Notice(element: notice));
    }

    return list;
  }

  // FamilyAndFriends get familyAndFriends {
  //   return FamilyAndFriends(
  //       element: _myAccountPage
  //           .querySelector('div[id="familyAndFriends"]')
  //           .querySelector('div[class="settings_block"]'),
  //       fnfValue: _myAccountPage
  //           .querySelector('div[id="fnfBlock"]')
  //           .querySelector('input[id="fnfBlockValue"]')
  //           .attributes['value']);
  // }

  List<ETECSAPackage> get buys {
    final List<ETECSAPackage> buys = [];

    for (var element in _myAccountPage
        .querySelectorAll('div[class="mad_accordion_container"]')) {
      for (var jElement
          in element.querySelectorAll('div [id="multiAccordion1"]')) {
        jElement
            .querySelectorAll('h3[class="ac_block_title"]')
            .asMap()
            .forEach((count, title) {
          final ePackage = ETECSAPackage(
            element: jElement.querySelectorAll('div[class="ac_block"]')[count],
            bonusPackage: true,
          );
          ePackage.title = title.text;
          buys.add(ePackage);
        });
      }
      for (var jElement
          in element.querySelectorAll('div [id="multiAccordion"]')) {
        jElement
            .querySelectorAll('h3[class="ac_block_title"]')
            .asMap()
            .forEach((count, title) {
          final ePackage = ETECSAPackage(
            element: jElement.querySelectorAll('div[class="ac_block"]')[count],
            bonusPackage: false,
          );
          ePackage.title = title.text;
          buys.add(ePackage);
        });
      }
    }
    return buys;
  }

  Future<void> loadHomePage() async {
    try {
      var response = await Net.connection(
        url: MCP_BASE_URL + '/',
      );

      _currentPage = parse(response.data);

      var urlSpanish = '';

      final List<Element> urls =
          _currentPage.querySelectorAll('a[class="link_msdp langChange"]');

      for (var url in urls) {
        if (url.attributes['id'] == 'spanishLanguage') {
          urlSpanish = url.attributes["href"];
        }
      }

      if (_urlsMCP.isNotEmpty) _urlsMCP.clear();

      _urlsMCP['home'] = MCP_BASE_URL + urlSpanish;

      response = await Net.connection(
        url: MCP_BASE_URL + urlSpanish,
      );

      _currentPage = parse(response.data);
      _homePage = parse(response.data);

      final div = _currentPage.querySelector(
          'div[class="collapse navbar-collapse navbar-main-collapse"]');

      final lis = div.querySelectorAll('li');

      for (var li in lis) {
        switch (li.text.trim()) {
          case 'Ofertas':
            _urlsMCP['offers'] =
                MCP_BASE_URL + li.querySelector('a')?.attributes['href'];
            break;
          case 'Productos':
            _urlsMCP['products'] =
                MCP_BASE_URL + li.querySelector('a')?.attributes['href'];
            break;
          case 'Mi Cuenta':
            _urlsMCP['myAccount'] =
                MCP_BASE_URL + li.querySelector('a')?.attributes['href'];
            break;
          case 'Soporte':
            _urlsMCP['support'] =
                MCP_BASE_URL + li.querySelector("a")?.attributes['href'];

            break;
        }
      }
    } catch (e) {
      throw CommunicationException("LOAD HOME: ${e.message}");
    }
  }

  Future<void> login(String phoneNumber, String password) async {
    try {
      await Net.connection(url: MCP_WELCOME_LOGIN_ES_URL);

      final formData = {
        'language': 'es_ES',
        'username': phoneNumber,
        'password': password,
        'uword': 'amount'
      };

      var response = await Net.connection(
        url: MCP_LOGIN_URL,
        dataMap: formData,
        method: 'POST',
      );

      _currentPage = parse(response.data);

      if (_currentPage.querySelector('div[class="body_wrapper error_page"]') !=
          null) {
        final msg = _currentPage
            .querySelector('div[class="body_wrapper error_page"]')
            .querySelector('div[class="welcome_login error_Block"]')
            .querySelector('div[class="container"]')
            .querySelector('b')
            .text;

        throw LoginException(msg);
      } else {
        await loadHomePage();
      }
    } on CommunicationException catch (e) {
      throw CommunicationException("LOGIN: ${e.message}");
    }
  }

  Future<void> loadMyAccount() async {
    try {
      final response = await Net.connection(
        url: _urlsMCP['myAccount'],
      );

      _myAccountPage = parse(response.data);

      // _urlsMCP['changeBonusServices'] = MCP_BASE_URL +
      //     _myAccountPage
      //         .querySelector('form[id="toogle-internet"]')
      //         .attributes['action'];

      updated = dateTimeNow;
    } on CommunicationException catch (e) {
      throw CommunicationException("LOAD ACCOUNT: ${e.message}");
    }
  }

  Future<void> loadNews() async {
    try {
      final response = await Net.connection(url: ETECSA_HOME_PAGE_URL);
      _newsPage = parse(response.data);
    } on CommunicationException catch (e) {
      throw CommunicationException("LOAD NEWS: ${e.message}");
    }
  }

  void changeBonusServices(bool isActiveBonusServices, String urlAction) {
    final dataMap = Map<String, String>();
    if (isActiveBonusServices) {
      dataMap['onoffswitchctm'] = 'off';
    } else {
      dataMap['onoffswitch'] = 'on';
      dataMap['onoffswitchctm'] = 'on';
    }
    try {
      Net.connection(
        url: urlAction,
        dataMap: dataMap,
        method: 'POST',
      );
    } catch (e) {
      throw CommunicationException("${e.message}");
    }
  }

  Future<void> loadProducts() async {
    try {
      final response = await Net.connection(
        url: _urlsMCP['products'],
      );
      _productsPage = parse(response.data);
    } catch (e) {
      throw CommunicationException("LOAD PRODUCTS: ${e.message}");
    }
  }

  Future<void> resetPassword(String phoneNumber) async {
    try {
      await Net.connection(
        url: MCP_WELCOME_LOGIN_ES_URL,
      );

      await Net.connection(
        url: MCP_FORGOT_URL,
      );

      final dataMap = Map<String, String>();

      dataMap['mobileNumber'] = phoneNumber;
      dataMap['uword'] = 'step';

      await Net.connection(
        url: MCP_FORGOT_ACTION_URL,
        dataMap: dataMap,
        method: 'POST',
      );
    } catch (e) {
      throw CommunicationException("${e.message}");
    }
  }

  Future<void> completeResetPassword(String code, String newPassword) async {
    try {
      final dataMap = Map<String, String>();

      dataMap['oneTimecode'] = code;
      dataMap['newPassword'] = newPassword;
      dataMap['cnewPassword'] = newPassword;
      dataMap['uword'] = 'step';

      final response = await Net.connection(
        url: MCP_RESET_PASSWORD_URL,
        dataMap: dataMap,
        method: 'POST',
      );

      _currentPage = parse(response.data);

      if (_currentPage.querySelector('div[class="body_wrapper error_page"]') !=
          null) {
        final msg = _currentPage
            .querySelector('div[class="body_wrapper error_page"]')
            .querySelector('div[class="welcome_login error_Block"]')
            .querySelector('div[class=\"container\"]')
            .querySelector('b')
            .text;
        throw OperationException(msg);
      }
    } catch (e) {
      throw CommunicationException("${e.message}");
    }
  }

  Future<void> signUp(String phoneNumber, String firstName, String lastName,
      String email) async {
    try {
      await Net.connection(url: MCP_WELCOME_LOGIN_ES_URL);

      await Net.connection(
        url: MCP_SIGN_UP_URL,
      );

      final dataMap = Map<String, String>();
      dataMap['msisdn'] = phoneNumber;
      dataMap['firstname'] = firstName;
      dataMap['lastname'] = lastName;
      dataMap['email'] = email;
      dataMap['uword'] = 'step';
      dataMap['agree'] = 'on';

      await Net.connection(
        url: MCP_SIGN_UP_ACTION_URL,
        dataMap: dataMap,
        method: 'POST',
      );
    } catch (e) {
      throw CommunicationException("${e.message}");
    }
  }

  Future<void> verifyCode(String code) async {
    final dataMap = Map<String, String>();

    dataMap['username'] = code;
    dataMap['uword'] = 'step';

    final response = await Net.connection(
      url: MCP_VERIFY_REGISTRATION_CODE_URL,
      dataMap: dataMap,
      method: 'POST',
    );
    _currentPage = parse(response.data);

    if (_currentPage.querySelector('div[class="body_wrapper error_page"]') !=
        null) {
      try {
        final msg = _currentPage
            .querySelector('div[class="body_wrapper error_page"]')
            .querySelector("div[class=\"welcome_login error_Block\"]")
            .querySelector("div[class=\"container\"]")
            .querySelector("b")
            .text;
        throw OperationException(msg);
      } catch (e) {
        final msg = _currentPage
            .querySelector("div[class=\"body_wrapper error_page\"]")
            .querySelector("div[class=\"welcome_login error_Block\"]")
            .querySelector("div[class=\"container\"]")
            .text;
        throw OperationException(msg);
      }
    }
  }

  Future<void> completeSignUp(String password) async {
    try {
      final dataMap = Map<String, String>();

      dataMap['newPassword'] = password;
      dataMap['cnewPassword'] = password;
      dataMap['uword'] = 'step';

      final response = await Net.connection(
        url: MCP_REGISTER_PASSWORD_CREATION_URL,
        dataMap: dataMap,
        method: 'POST',
      );
      _currentPage = parse(response.data);

      if (_currentPage
              .querySelector("div[class=\"body_wrapper error_page\"]") !=
          null) {
        try {
          final msg = _currentPage
              .querySelector("div[class=\"body_wrapper error_page\"]")
              .querySelector("div[class=\"welcome_login error_Block\"]")
              .querySelector("div[class=\"container\"]")
              .querySelector("b")
              .text;

          throw OperationException(msg);
        } catch (e) {
          final msg = _currentPage
              .querySelector("div[class=\"body_wrapper error_page\"]")
              .querySelector("div[class=\"welcome_login error_Block\"]")
              .querySelector("div[class=\"container\"]")
              .text;
          throw OperationException(msg);
        }
      }
    } catch (e) {
      throw CommunicationException("${e.message}");
    }
  }

  Future<void> loanMe(String mount, String subscriber) async {
    final dataMap = Map<String, String>();

    dataMap['subscriber'] = subscriber;
    dataMap['transactionAmount'] = mount;

    final response = await Net.connection(
      url: MCP_LOAN_ME_URL,
      dataMap: dataMap,
    );
    final data = json.decode(response.data);
    final responseCode = data['responseCode'];

    if (responseCode as String != "200")
      throw OperationException("${responseCode}: Usted no aplica!");
  }
}
