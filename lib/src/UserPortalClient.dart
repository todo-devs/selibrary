import 'dart:io';

import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:selibrary/selibrary.dart';

const UP_LOGIN_URL = "https://www.portal.nauta.cu/user/login/es-es";

const UP_LOGOUT_URL = "https://www.portal.nauta.cu/user/logout";

const UP_CAPTCHA_URL = "https://www.portal.nauta.cu/captcha/?";

const UP_USER_INFO_URL = "https://www.portal.nauta.cu/useraaa/user_info";

const UP_RECHARGE_URL = "https://www.portal.nauta.cu/useraaa/recharge_account";

const UP_TRANSFER_URL = "https://www.portal.nauta.cu/useraaa/transfer_balance";

const UP_CHANGE_PASSWORD_URL =
    "https://www.portal.nauta.cu/useraaa/change_password";

const UP_CHANGE_EMAIL_PASSWORD_URL =
    "https://www.portal.nauta.cu/email/change_password";

const UP_SERVICE_DETAIL_URL =
    "https://www.portal.nauta.cu/useraaa/service_detail";

const UP_SERVICE_DETAIL_LIST_URL =
    "https://www.portal.nauta.cu/useraaa/service_detail_list/";

const UP_SERVICE_DETAIL_SUMMARY =
    "https://www.portal.nauta.cu/useraaa/service_detail_summary";

const UP_RECHARGE_DETAIL_URL =
    "https://www.portal.nauta.cu/useraaa/recharge_detail/";

const UP_RECHARGE_DETAIL_LIST_URL =
    "https://www.portal.nauta.cu/useraaa/recharge_detail_list/";

const UP_RECHARGE_DETAIL_SUMMARY =
    "https://www.portal.nauta.cu/useraaa/recharge_detail_summary/";

const UP_TRANSFER_DETAIL_URL =
    "https://www.portal.nauta.cu/useraaa/transfer_detail/";

const UP_TRANSFER_DETAIL_LIST_URL =
    "https://www.portal.nauta.cu/useraaa/transfer_detail_list/";

const UP_TRANSFER_DETAIL_SUMMARY_URL =
    "https://www.portal.nauta.cu/useraaa/transfer_detail_summary/";

abstract class IUserPortalClient {
  String _csrf;
  Document _page;
  Document _homePage;
  List<int> _captchaImg;

  List<int> get captchaImg => _captchaImg;

  List<Element> get _m6 =>
      _homePage.querySelector('div.card-panel').querySelectorAll('div.m6');

  String get user {
    for (var element in _m6) {
      if (element.querySelector('h5').text.trim() == "Usuario")
        return element.querySelector('p').text;
    }

    return null;
  }

  String get blockDate {
    for (var element in _m6) {
      if (element.querySelector("h5").text.trim() == "Fecha de bloqueo") {
        return element.querySelector("p").text;
      }
    }
    return null;
  }

  String get delDate {
    for (var element in _m6) {
      if (element.querySelector("h5").text.trim() == "Fecha de eliminación") {
        return element.querySelector("p").text;
      }
    }
    return null;
  }

  String get accountType {
    for (var element in _m6) {
      if (element.querySelector("h5").text.trim() == "Tipo de cuenta") {
        return element.querySelector("p").text;
      }
    }
    return null;
  }

  String get serviceType {
    for (var element in _m6) {
      if (element.querySelector("h5").text.trim() == "Tipo de servicio") {
        return element.querySelector("p").text;
      }
    }
    return null;
  }

  String get credit {
    for (var element in _m6) {
      if (element.querySelector("h5").text.trim() == "Saldo disponible") {
        return element.querySelector("p").text;
      }
    }
    return null;
  }

  String get mailAccount {
    for (var element in _m6) {
      if (element.querySelector("h5").text.trim() == "Cuenta de correo") {
        return element.querySelector("p").text;
      }
    }
    return null;
  }

  String get time {
    for (var element in _m6) {
      if (element.querySelector("h5").text.trim() ==
          "Tiempo disponible de la cuenta") {
        return element.querySelector("p").text;
      }
    }
    return null;
  }

  _getCSRF() {
    final input = _page.querySelector('input[name="csrf"]');
    _csrf = input.attributes['value'];
  }

  Future<void> _getCaptcha() async {
    try {
      _captchaImg = await Net.getImage(UP_CAPTCHA_URL);
    } on CommunicationException catch (e) {
      throw CommunicationException('getCaptcha: ${e.message}');
    }
  }

  Future<File> saveCaptcha({String filePath: 'captcha.png'}) async {
    var file = File(filePath);
    return await file.writeAsBytes(_captchaImg);
  }

  Future<void> preLogin() async {
    try {
      final response = await Net.connection(url: UP_LOGIN_URL);
      _page = parse(response.data);
      _getCSRF();
      await _getCaptcha();
    } on CommunicationException catch (e) {
      throw CommunicationException('preLogin: ${e.message}');
    }
  }

  Future<void> login(
    String username,
    String password,
    String captchaCode,
  ) async {
    var formData = {
      'btn_submit': '',
      'captcha': captchaCode,
      'csrf': _csrf,
      'login_user': username,
      'password_user': password
    };

    try {
      final response = await Net.connection(
        url: UP_LOGIN_URL,
        dataMap: formData,
        method: 'POST',
        formData: true,
      );

      _homePage = parse(response.data);

      final error = findError(_homePage);

      if (error != null) {
        throw LoginException('LOGIN: $error');
      }
    } on CommunicationException catch (e) {
      throw CommunicationException('login: ${e.message}');
    }
  }

  Future<void> recharge(String rechargeCode) async {
    rechargeCode = rechargeCode.replaceAll(' ', '');
    if (rechargeCode.length != 12 && rechargeCode.length != 16) {
      throw CodeException("El codigo debe tener 12 o 16 digitos");
    }
    try {
      var response = await Net.connection(url: UP_RECHARGE_URL);
      _page = parse(response.data);
      _getCSRF();

      final dataMap = Map<String, String>();
      dataMap["csrf"] = _csrf;
      dataMap["recharge_code"] = rechargeCode;
      dataMap["btn_submit"] = '';
      response = await Net.connection(
        url: UP_RECHARGE_URL,
        dataMap: dataMap,
        formData: true,
        method: 'POST',
      );
      _page = parse(response.data);

      final error = findError(_page);

      if (error != null) {
        throw OperationException(error);
      }
    } on IException catch (e) {
      throw CommunicationException("RECHARGE: ${e.message}");
    }
  }

  Future<void> transfer(
      String mountToTransfer, String password, String accountToTransfer) async {
    try {
      var response = await Net.connection(url: UP_TRANSFER_URL);
      _page = parse(response.data);
      _getCSRF();

      final dataMap = Map<String, String>();
      dataMap["csrf"] = _csrf;
      dataMap["transfer"] = mountToTransfer;
      dataMap["password_user"] = password;
      dataMap["id_cuenta"] = accountToTransfer;
      dataMap["action"] = "checkdata";

      if (credit != null && creditToInt(credit) == 0) {
        // set error
        throw OperationException(
            "Usted no tiene saldo en la cuenta. Por favor recargue.");
      } else if (credit != null &&
          creditToInt(credit) <
              int.parse(
                  mountToTransfer.replaceAll(",", "").replaceAll('.', ''))) {
        throw OperationException(
            "Su saldo es inferior a la cantidad que quiere transferir.");
      }

      response = await Net.connection(
        url: UP_TRANSFER_URL,
        dataMap: dataMap,
        formData: true,
        method: 'POST',
      );
      _page = parse(response.data);

      final error = findError(_page);

      if (error != null) {
        throw OperationException(error);
      }
    } on IException catch (e) {
      throw CommunicationException("Transferencia: ${e.message}");
    }
  }
}
