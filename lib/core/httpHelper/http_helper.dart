import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart';

import '../../Providers/auth_provider.dart';
import '../../Storage/shared_preference.dart';
import 'header_config.dart';

const String baseUrl =
    'https://eg.api.weevoapp.com/api/v1/captain/'; // Production
// const String baseUrl =
//     'https://api-dev-mobile.weevoapp.com/api/v1/captain/'; // Debug

class HttpHelper {
  static final HttpHelper instance = HttpHelper._instance();

  HttpHelper._instance();

  Future<Response> httpPost(String path, bool withAuth,
      {Map<String, dynamic>? body, bool withoutPath = false}) async {
    final Response r = await post(
        Uri.parse(withoutPath ? path : '$baseUrl$path'),
        body: json.encode(body),
        headers: withAuth
            ? await HeaderConfig.getHeaderWithToken()
            : await HeaderConfig.getHeader());
    log('request URL -> ${r.request?.url}');
    log('statusCode -> ${r.statusCode}');
    log('payload -> $body');
    if (r.statusCode >= 200 && r.statusCode < 300) {
      log('decoded response -> ${json.decode(r.body)}');
    } else if (r.statusCode == 401) {
      if (Preferences.instance.getPhoneNumber.isNotEmpty &&
          Preferences.instance.getPassword.isNotEmpty) {
        await AuthProvider.listenFalse(navigator.currentContext!).authLogin();
        await getData();
      }
    }
    log('response -> ${r.body}');
    return r;
  }

  Future<Response> httpDelete(String path, bool withAuth,
      {Map<String, dynamic>? body}) async {
    final Response r = await delete(Uri.parse('$baseUrl$path'),
        body: body == null ? null : json.encode(body),
        headers: withAuth
            ? await HeaderConfig.getHeaderWithToken()
            : await HeaderConfig.getHeader());
    log('request URL -> ${r.request?.url}');
    log('statusCode -> ${r.statusCode}');
    if (r.statusCode >= 200 && r.statusCode < 300) {
      log('decoded response -> ${json.decode(r.body)}');
    } else if (r.statusCode == 401) {
      if (Preferences.instance.getPhoneNumber.isNotEmpty &&
          Preferences.instance.getPassword.isNotEmpty) {
        await AuthProvider.listenFalse(navigator.currentContext!).authLogin();
        await getData();
      }
    }
    log('CountriesResponse -> ${r.body}');

    return r;
  }

  Future<Response> httpGet(String path, bool withAuth,
      {bool hasBase = true}) async {
    final Response r = await get(Uri.parse('${hasBase ? baseUrl : ''}$path'),
        headers: withAuth
            ? await HeaderConfig.getHeaderWithToken()
            : await HeaderConfig.getHeader());
    log('request URL -> ${r.request?.url}');
    log('statusCode -> ${r.statusCode}');
    if (r.statusCode >= 200 && r.statusCode < 300) {
      log('decoded response -> ${json.decode(r.body)}');
    } else if (r.statusCode == 401) {
      log('ERRRRRRRR');
      if (Preferences.instance.getPhoneNumber.isNotEmpty &&
          Preferences.instance.getPassword.isNotEmpty) {
        await AuthProvider.listenFalse(navigator.currentContext!).authLogin();
        await getData();
      }
    }
    log('response -> ${r.body}');
    return r;
  }

  Future<Response> httpPut(String path, bool withAuth,
      {Map<String, dynamic>? body}) async {
    final Response r = await put(Uri.parse('$baseUrl$path'),
        body: json.encode(body),
        headers: withAuth
            ? await HeaderConfig.getHeaderWithToken()
            : await HeaderConfig.getHeader());
    log('request URL -> ${r.request?.url}');
    log('statusCode -> ${r.statusCode}');
    if (r.statusCode >= 200 && r.statusCode < 300) {
      log('decoded response -> ${json.decode(r.body)}');
    } else if (r.statusCode == 401) {
      if (Preferences.instance.getPhoneNumber.isNotEmpty &&
          Preferences.instance.getPassword.isNotEmpty) {
        await AuthProvider.listenFalse(navigator.currentContext!).authLogin();
        await getData();
      }
    }
    log('response -> ${r.body}');
    return r;
  }

  Future<void> getData() async {
    log('Get All Data');
    Future.wait([
      AuthProvider.listenFalse(navigator.currentContext!)
          .getCurrentUserdata(false),
      // AuthProvider.listenFalse(navigator.currentContext).getToken(),
      // AuthProvider.listenFalse(navigator.currentContext).getFirebaseToken(),
      AuthProvider.listenFalse(navigator.currentContext!).getArticle(),
      AuthProvider.listenFalse(navigator.currentContext!)
          .getGroupsWithBanners(),
      AuthProvider.listenFalse(navigator.currentContext!).getAllCategories(),
      AuthProvider.listenFalse(navigator.currentContext!)
          .getCourierCommission(),
      AuthProvider.listenFalse(navigator.currentContext!).getCountries(),
    ]);
  }
}
