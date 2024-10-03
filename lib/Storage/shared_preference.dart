import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GlobalKey<NavigatorState> navigator = GlobalKey<NavigatorState>();

class Preferences {
  late SharedPreferences _preferences;

  static final Preferences instance = Preferences._instance();
  static const String username = 'WEEVO_COURIER_USER_NAME';
  static const String rating = 'WEEVO_COURIER_Rating';
  static const String id = 'WEEVO_COURIER_ID';
  static const String password = 'WEEVO_COURIER_PASSWORD';
  static const String email = 'WEEVO_COURIER_EMAIL';
  static const String phoneNumber = 'WEEVO_COURIER_PHONE_NUMBER';
  static const String photoUrl = 'WEEVO_COURIER_PHOTO_URL';
  static const String nationalId = 'WEEVO_COURIER_NATIONAL_ID';
  static const String gender = 'WEEVO_COURIER_GENDER';
  static const String accessToken = 'WEEVO_COURIER_ACCESS_TOKEN';
  static const String tokenType = 'WEEVO_COURIER_TOKEN_TYPE';
  static const String dateOfBirth = 'WEEVO_COURIER_DATE_OF_BIRTH';
  static const String expiresAt = 'WEEVO_COURIER_EXPIRES_AT';
  static const String receiveNotification =
      'WEEVO_COURIER_RECEIVE_NOTIFICATION';
  static const String isOnline = 'WEEVO_COURIER_IS_ONLINE';
  static const String addressId = 'WEEVO_COURIER_ADDRESS_ID';
  static const String fcmAccessToken = 'WEEVO_COURIER_FCM_ACCESS_TOKEN';
  static const String fcmToken = 'WEEVO_COURIER_FCM_TOKEN';
  static const String courierAreas = 'WEEVO_COURIER_AREAS';
  static const String courierVehicleColor = 'WEEVO_COURIER_VEHICLE_COLOR';
  static const String courierVehicleModel = 'WEEVO_COURIER_VEHICLE_MODEL';
  static const String courierDeliveryMethod = 'WEEVO_COURIER_DELIVERY_METHOD';
  static const String courierVehicleNumber = 'WEEVO_COURIER_VEHICLE_NUMBER';
  static const String courierVersionNumber = 'WEEVO_COURIER_APP_VERSION_NUMBER';
  static const String courierCommission = 'WEEVO_COURIER_APP_COMMISSION';

  Preferences._instance();

  Future<SharedPreferences> initPref() async {
    _preferences = await SharedPreferences.getInstance();
    return _preferences;
  }

  Future<bool> setUserId(String value) async {
    bool isSet = await _preferences.setString(id, value);
    return isSet;
  }

  Future<bool> setPassword(String value) async {
    bool isSet = await _preferences.setString(password, value);
    return isSet;
  }

  Future<bool> setUserName(String value) async {
    bool isSet = await _preferences.setString(username, value);
    return isSet;
  }

  Future<bool> setFcmAccessToken(String value) async {
    bool isSet = await _preferences.setString(fcmAccessToken, value);
    return isSet;
  }

  Future<bool> setRating(String value) async {
    bool isSet = await _preferences.setString(rating, value);
    return isSet;
  }

  Future<bool> setUserEmail(String value) async {
    bool isSet = await _preferences.setString(email, value);
    return isSet;
  }

  Future<bool> setCourierAreas(String value) async {
    bool isSet = await _preferences.setString(courierAreas, value);
    return isSet;
  }

  Future<bool> setTokenType(String value) async {
    bool isSet = await _preferences.setString(tokenType, value);
    return isSet;
  }

  Future<bool> setExpiresAt(String value) async {
    bool isSet = await _preferences.setString(expiresAt, value);
    return isSet;
  }

  Future<bool> setAppVersionNumber(String value) async {
    bool isSet = await _preferences.setString(courierVersionNumber, value);
    return isSet;
  }

  Future<bool> setWeevoCommission(int value) async {
    bool isSet = await _preferences.setInt(courierCommission, value);
    return isSet;
  }

  Future<bool> setVehicleNumber(String value) async {
    bool isSet = await _preferences.setString(courierVehicleNumber, value);
    return isSet;
  }

  Future<bool> setNationalId(String value) async {
    bool isSet = await _preferences.setString(nationalId, value);
    return isSet;
  }

  Future<bool> setVehicleModel(String value) async {
    bool isSet = await _preferences.setString(courierVehicleModel, value);
    return isSet;
  }

  Future<bool> setVehicleColor(String value) async {
    bool isSet = await _preferences.setString(courierVehicleColor, value);
    return isSet;
  }

  Future<bool> setDeliveryMethod(String value) async {
    bool isSet = await _preferences.setString(courierDeliveryMethod, value);
    return isSet;
  }

  Future<bool> setIsOnline(int value) async {
    bool isSet = await _preferences.setInt(isOnline, value);
    return isSet;
  }

  // Future<bool> setTabIndex(String value) async {
  //   bool isSet = await _preferences.setString(tabIndex,value);
  //   return isSet;
  // }

  Future<bool> setReceiveNotification(int value) async {
    bool isSet = await _preferences.setInt(receiveNotification, value);
    return isSet;
  }

  Future<bool> setUserPhotoUrl(String value) async {
    bool isSet = await _preferences.setString(photoUrl, value);
    return isSet;
  }

  Future<bool> setAccessToken(String value) async {
    bool isSet = await _preferences.setString(accessToken, value);
    return isSet;
  }

  Future<bool> setFcmToken(String value) async {
    bool isSet = await _preferences.setString(fcmToken, value);
    return isSet;
  }

  Future<bool> setDateOfBirth(String value) async {
    bool isSet = await _preferences.setString(dateOfBirth, value);
    return isSet;
  }

  Future<bool> setGender(String value) async {
    bool isSet = await _preferences.setString(gender, value);
    return isSet;
  }

  Future<bool> setPhoneNumber(String value) async {
    bool isSet = await _preferences.setString(phoneNumber, value);
    return isSet;
  }

  Future<bool> setAddressId(int value) async {
    bool isSet = await _preferences.setInt(addressId, value);
    return isSet;
  }

  Future<bool> clearUser() async {
    bool isCleared = await _preferences.clear();
    return isCleared;
  }

  String get getUserId => _preferences.getString(id) ?? '';

  String get getPassword => _preferences.getString(password) ?? '';

  String get getGender => _preferences.getString(gender) ?? '';

  String get getPhoneNumber => _preferences.getString(phoneNumber) ?? '';

  String get getAccessToken => _preferences.getString(accessToken) ?? '';

  String get getDateOfBirth => _preferences.getString(dateOfBirth) ?? '';

  String get getTokenType => _preferences.getString(tokenType) ?? '';

  int get getCourierCommission => _preferences.getInt(courierCommission) ?? -1;

  String get getFcmToken => _preferences.getString(fcmToken) ?? '';

  String get getUserName => _preferences.getString(username) ?? '';

  String get getRating => _preferences.getString(rating) ?? '';

  String get getCourierAreas => _preferences.getString(courierAreas) ?? '';

  int get getIsOnline => _preferences.getInt(isOnline) ?? -1;

  int get getReceiveNotification =>
      _preferences.getInt(receiveNotification) ?? -1;

  String get getUserEmail => _preferences.getString(email) ?? '';

  String get getNationalId => _preferences.getString(nationalId) ?? '';

  String get getCourierVehicleColor =>
      _preferences.getString(courierVehicleColor) ?? '';

  String get getCourierVehicleNumber =>
      _preferences.getString(courierVehicleNumber) ?? '';

  String get getCourierVehicleModel =>
      _preferences.getString(courierVehicleModel) ?? '';

  String get getCourierDeliveryMethod =>
      _preferences.getString(courierDeliveryMethod) ?? '';

  int get getAddressId => _preferences.getInt(addressId) ?? -1;

  String get getFCMAccessToken => _preferences.getString(fcmAccessToken) ?? '';

  String get getUserPhotoUrl => _preferences.getString(photoUrl) ?? '';

  String get getCurrentAppVersionNumber =>
      _preferences.getString(courierVersionNumber) ?? '';

  String get getExpiresAt => _preferences.getString(expiresAt) ?? '';
}
