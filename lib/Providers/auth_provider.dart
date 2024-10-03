// ignore_for_file: unused_field, unused_local_variable

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:freshchat_sdk/freshchat_sdk.dart' as fresh_chat;
import 'package:geolocator/geolocator.dart' as geo;
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/local_auth_darwin.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:weevo_captain_app/core/helpers/toasts.dart';

import '../Dialogs/action_dialog.dart';
import '../Dialogs/loading.dart';
import '../Dialogs/rating_dialog.dart';
import '../Dialogs/shipment_dialog.dart';
import '../Models/accept_merchant_offer.dart';
import '../Models/account_existed.dart';
import '../Models/articles.dart';
import '../Models/articles_data.dart';
import '../Models/cars/car_model.dart';
import '../Models/category_data.dart';
import '../Models/category_model.dart';
import '../Models/chat_data.dart';
import '../Models/city.dart';
import '../Models/country.dart';
import '../Models/courier_critical_update.dart';
import '../Models/group_banner.dart';
import '../Models/home_banner.dart';
import '../Models/image.dart';
import '../Models/send_otp_model.dart';
import '../Models/shipment_notification.dart';
import '../Models/shipment_tracking_model.dart';
import '../Models/sign_up_data.dart';
import '../Models/state.dart';
import '../Models/update_user_data.dart';
import '../Models/upload_state.dart';
import '../Models/user.dart';
import '../Models/user_data.dart';
import '../Models/user_data_by_token.dart';
import '../Models/weevo_user.dart';
import '../Screens/after_registration.dart';
import '../Screens/before_registration.dart';
import '../Screens/chat_screen.dart';
import '../Screens/child_shipment_details.dart';
import '../Screens/fragment/reset_password_0.dart';
import '../Screens/fragment/reset_password_1.dart';
import '../Screens/fragment/reset_password_2.dart';
import '../Screens/fragment/sign_up_car_info.dart';
import '../Screens/fragment/sign_up_choose_area.dart';
import '../Screens/fragment/sign_up_national_id_screen.dart';
import '../Screens/fragment/sign_up_personal_info.dart';
import '../Screens/fragment/sign_up_verify_phone_number.dart';
import '../Screens/handle_shipment.dart';
import '../Screens/home.dart';
import '../Screens/onboarding.dart';
import '../Screens/shipment_details_display.dart';
import '../Screens/wallet.dart';
import '../Storage/shared_preference.dart';
import '../Utilits/constants.dart';
import '../Utilits/notification_const.dart';
import '../core/httpHelper/http_helper.dart';
import '../core/networking/api_constants.dart';
import '../features/wasully_handle_shipment/ui/widgets/wasully_rating_dialog.dart';
import '../router/router.dart';

class AuthProvider with ChangeNotifier {
  static AuthProvider get(BuildContext context) =>
      Provider.of<AuthProvider>(context);

  static AuthProvider listenFalse(BuildContext context) =>
      Provider.of<AuthProvider>(context, listen: false);
  static const String success = 'SUCCESS';
  bool _currentPasswordIsIncorrect = false;
  int _screenIndex = 0;
  int _resetPasswordIndex = 0;
  Widget _page = const SignUpPersonalInfo();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  Widget _resetPasswordWidget = const ResetPassword0();
  List<CategoryData>? _categories;
  final bool _test = false;
  int _totalMessages = 0;
  int _totalNotifications = 0;
  String? _currentWidget;
  bool _isLoading = false;
  NetworkState? _isOnlineState;
  NetworkState? _updatePasswordState;
  NetworkState? _carInfoState;
  NetworkState? _updatePhoneState;
  NetworkState? _versionState;
  bool _fromOutsideNotification = false;
  bool _fromNotificationHome = false;
  String? _verificationId;
  CourierCriticalUpdate? _courierCriticalUpdate;
  int? _offerId;
  String? _resetPasswordMessage;
  NetworkState? _existedState;
  bool _betterOfferIsBiggerThanLastOne = false;
  bool _updateOffer = false;
  String? _betterOfferMessage;
  String? _message;

  String? get message => _message;

  int? get offerId => _offerId;

  NetworkState? get updatePasswordState => _updatePasswordState;

  bool? get updateOffer => _updateOffer;

  bool? get currentPasswordIsIncorrect => _currentPasswordIsIncorrect;

  List<CategoryData>? get categories => _categories;

  NetworkState? get carInfoState => _carInfoState;
  NetworkState? _isNotificationOnState;
  NetworkState? _updateEmailState;
  NetworkState? _updateTokenState;
  List<GroupBanner>? _groupBanner;
  List<HomeBanner>? _homeBanner;
  List<ArticlesData>? _articles;
  bool _chosenStateEmpty = true;
  bool _profileImageLoading = false;
  bool _frontIdImageLoading = false;
  bool _backIdImageLoading = false;
  int _addressSelectedItem = 0;
  User? _user;
  UserData? _userData;
  UserDataByToken? _userDataByToken;
  final Preferences _preferences = Preferences.instance;
  NetworkState? _bannerState;
  NetworkState? _resetPasswordState;
  NetworkState? _createNewUserState;
  NetworkState? _logoutState;
  NetworkState? _articleState = NetworkState.waiting;
  NetworkState? _groupBannersState = NetworkState.waiting;
  NetworkState? _courierCriticalUpdateState;
  NetworkState? _courierCommissionState;
  NetworkState? _updateCourierPersonalInfoState;
  NetworkState? _loginState;
  String? photoId;
  NetworkState? _countryState;
  States? _state;
  Cities? _city;
  List<States> states = [];
  List<Cities> chosenCities = [];
  List<UploadState> chosenStates = [];
  NetworkState? _shipmentStatusState;
  bool _canGoInside = false;
  bool _stillAvailable = false;
  int? _userId;
  String? _firstName;
  String? _lastName;
  String? _userPhoto;
  String? _userPhone;
  String? _userEmail;
  String? _userFirebaseToken;
  String? _userFirebaseId;
  String? _userGender;
  String? _userPassword;
  String? _nationalIdNumber;
  String? _nationalIdPhotoBack;
  String? _nationalIdPhotoFront;
  String? _vehicleColor;
  String? _vehicleModel;
  String? _deliveryMethod;
  String? _vehiclePlate;
  bool _checkAllAreas = false;
  List<CarModel> _carSearchList = [];
  final FirebaseMessaging fcm = FirebaseMessaging.instance;
  bool _dialogOpen = false;
  int _notificationsNo = 0;
  NetworkState? _networkState;
  NetworkState? _updateAreasState;
  double? currentLatitude, currentLongitude;
  Location? _location;
  PermissionStatus? _permissionGranted;
  bool? _serviceEnabled;
  LocationData? _locationData;
  bool _noCredit = false;
  String? _createNewUserMessage;
  NetworkState? _catState;

  // WeevoCommision weevoCommision;

  bool get noCredit => _noCredit;

  NetworkState? get updateEmailState => _updateEmailState;

  NetworkState? get versionState => _versionState;

  LocationData? get locationData => _locationData;

  List<CarModel> get carSearchList => _carSearchList;

  NetworkState? get updateCourierPersonalInfoState =>
      _updateCourierPersonalInfoState;

  String? get resetPasswordMessage => _resetPasswordMessage;

  String? get vehicleColor => _vehicleColor;

  bool get profileImageLoading => _profileImageLoading;

  bool get frontIdImageLoading => _frontIdImageLoading;

  NetworkState? get loginState => _loginState;

  Location? get location => _location;

  String? get currentWidget => _currentWidget;

  NetworkState? get updateTokenState => _updateTokenState;

  NetworkState? get logoutState => _logoutState;

  void setCurrentWidget(String? v) {
    _currentWidget = v;
  }

  NetworkState? get shipmentStatusState => _shipmentStatusState;

  int get resetPasswordIndex => _resetPasswordIndex;

  void filterCarsModel(List<CarModel> carList, String? title) {
    _carSearchList = [];
    _carSearchList = carList
        .where(
          (element) => element.name!
              .toLowerCase()
              .startsWith(title?.toLowerCase() ?? ''),
        )
        .toList();
    notifyListeners();
  }

  void setFromOutsideNotification(bool v) {
    _fromOutsideNotification = v;
  }

  NetworkState? get updateAreasState => _updateAreasState;

  void setFromNotificationHome(bool v) {
    _fromNotificationHome = v;
  }

  bool get fromNotificationHome => _fromNotificationHome;

  String? get verificationId => _verificationId;

  bool get fromOutsideNotification => _fromOutsideNotification;

  Future<LocationData> getUserLocation() async {
    _location = Location();
    if (await locationServiceEnabled() && await locationPermissionGranted()) {
      _location?.changeSettings(
          accuracy: LocationAccuracy.navigation, interval: 10000);
      _locationData = await _location?.getLocation();
    }
    return _locationData!;
  }

  NetworkState? get updatePhoneState => _updatePhoneState;

  NetworkState? get bannerState => _bannerState;

  Future<void> getCurrentLocation() async {
    if (_location == null) {
      _location = Location();
      _locationData = await _location?.getLocation();
      return;
    }
    _locationData = await _location?.getLocation();
  }

  Future<void> getShipmentStatus(
    int id,
  ) async {
    try {
      _shipmentStatusState = NetworkState.waiting;
      http.Response r = await HttpHelper.instance.httpGet(
        'shipments/$id',
        true,
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        _shipmentStatusState = NetworkState.success;
        _canGoInside = jsonDecode(r.body)['status'] != 'cancelled';
        _stillAvailable = jsonDecode(r.body)['status'] == 'available';
      } else {
        _shipmentStatusState = NetworkState.error;
      }
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }

  Future<void> getAllCategories() async {
    try {
      _catState = NetworkState.waiting;
      http.Response r = await HttpHelper.instance.httpGet(
        'product-categories?paginate=1000',
        true,
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        CategoryModel model = CategoryModel.fromJson(
          jsonDecode(r.body),
        );
        _categories = model.data;
        _catState = NetworkState.success;
      } else {
        _catState = NetworkState.error;
      }
    } catch (e) {
      log(e.toString());
    }
    log(_categories.toString());
    log('${_categories?.length}');
    notifyListeners();
  }

  Future<void> subscribeAreas(List topics) async {
    for (var element in topics) {
      await fcm.subscribeToTopic(element);
    }
  }

  Future<void> unSubscribeAreas(List topics) async {
    for (var element in topics) {
      await fcm.unsubscribeFromTopic(element);
    }
  }

  CategoryData? getCatById(int id) {
    int index = _categories!.indexWhere((element) => element.id == id);
    if (index == -1) {
      return null;
    }
    return _categories![index];
  }

  bool get stillAvailable => _stillAvailable;

  List<GroupBanner>? get groupBanner => _groupBanner;

  Future<bool> locationServiceEnabled() async {
    _serviceEnabled = await _location?.serviceEnabled();
    if (!(_serviceEnabled ?? false)) {
      _serviceEnabled = await _location?.requestService();
      if (!(_serviceEnabled ?? false)) {
        return false;
      }
    }
    return true;
  }

  Future<void> setAppVersion({
    String? appVersion,
  }) async {
    _versionState = NetworkState.waiting;
    try {
      http.Response r = await HttpHelper.instance.httpPost(
        'update',
        true,
        body: {
          'app_version': appVersion,
          'password_verification': password,
        },
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        _versionState = NetworkState.success;
      } else {
        _versionState = NetworkState.error;
      }
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }

  Future<bool> locationPermissionGranted() async {
    _permissionGranted = await _location?.hasPermission();
    if (_permissionGranted == PermissionStatus.deniedForever) {
      showDialog(
          context: navigator.currentContext!,
          builder: (_) => ActionDialog(
                content: 'يجب عليك تفعيل الموقع من الاعدادت هل تود ذلك',
                cancelAction: 'لا',
                onCancelClick: () {
                  Navigator.pop(navigator.currentContext!);
                },
                approveAction: 'نعم',
                onApproveClick: () async {
                  Navigator.pop(navigator.currentContext!);
                  await geo.Geolocator.openLocationSettings();
                },
              ));
    } else if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location?.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  Future<void> updateToken({
    String? value,
  }) async {
    _updateTokenState = NetworkState.waiting;
    try {
      http.Response r = await HttpHelper.instance.httpPost(
        'update',
        true,
        body: {
          'firebase_notification_token': value,
          'password_verification': password,
        },
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        _updateTokenState = NetworkState.success;
      } else {
        _updateTokenState = NetworkState.error;
      }
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }

  Future<void> getBanners() async {
    _bannerState = NetworkState.waiting;
    try {
      http.Response r = await HttpHelper.instance.httpGet(
        'banners?group_slug=merchant-home-top-banners',
        true,
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        _homeBanner = (json.decode(r.body) as List)
            .map((e) => HomeBanner.fromJson(e))
            .toList();
        _bannerState = NetworkState.success;
      } else {
        _bannerState = NetworkState.error;
      }
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }

  Future<void> getGroupsWithBanners() async {
    _groupBannersState = NetworkState.waiting;
    try {
      http.Response r = await HttpHelper.instance.httpGet(
        'banners/groups?with-banners=true',
        true,
      );
      log('${r.statusCode}');
      if (r.statusCode >= 200 && r.statusCode < 300) {
        _groupBanner = (json.decode(r.body) as List)
            .map((e) => GroupBanner.fromJson(e))
            .toList();
        _groupBannersState = NetworkState.success;
      } else {
        _groupBannersState = NetworkState.error;
      }
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }

  void setUserDataOne(SignUpData data) {
    _firstName = data.firstName;
    _lastName = data.lastName;
    _userPhoto = data.photo;
    _userPhone = data.phone;
    _userEmail = data.email;
    _userGender = data.gender;
    _userPassword = data.password;
    _nationalIdNumber = data.nationalIdNumber;
    log(data.toString());
  }

  void setUserDataTwo(SignUpData data) {
    _userFirebaseToken = data.userFirebaseToken;
    _userFirebaseId = data.userFirebaseId;
    log(data.toString());
  }

  void setUserDataThree(SignUpData data) {
    _nationalIdPhotoFront = data.nationalIdFront;
    _nationalIdPhotoBack = data.nationalIdBack;
  }

  int? getStateIdByName(String? stateName) =>
      states.firstWhereOrNull((x) => x.name == stateName)?.id;

  int? getCityIdByName(String? stateName, String? cityName) {
    Cities? cities;
    States? state = states.firstWhereOrNull(
      (x) => x.name == stateName,
    );
    if (state != null) {
      cities = state.cities?.firstWhereOrNull((y) => y.name == cityName);
    }
    return cities?.id;
  }

  // Future<bool> authenticateWithBiometrics() async {
  //   final LocalAuthentication localAuthentication = LocalAuthentication();
  //
  //   bool isBiometricSupported = await localAuthentication.isDeviceSupported();
  //   bool canCheckBiometrics = await localAuthentication.canCheckBiometrics;
  //   bool isAuthenticated = false;
  //
  //   if (isBiometricSupported && canCheckBiometrics) {
  //     try {
  //       isAuthenticated = await localAuthentication.authenticate(
  //         localizedReason: 'Please complete the biometrics to proceed.',
  //         biometricOnly: true,
  //       );
  //     } on PlatformException catch (e) {
  //       log('${e.message}');
  //       if (e.code == notAvailable ||
  //           e.code == passcodeNotSet ||
  //           e.code == notEnrolled) {
  //         isAuthenticated = await localAuthentication.authenticate(
  //           localizedReason: 'Please complete the biometrics to proceed.',
  //         );
  //       }
  //     }
  //   } else {
  //     try {
  //       isAuthenticated = await localAuthentication.authenticate(
  //         localizedReason: 'Please complete the biometrics to proceed.',
  //       );
  //     } on PlatformException catch (e) {
  //       log('${e.message}');
  //       if (e.code == notAvailable ||
  //           e.code == passcodeNotSet ||
  //           e.code == notEnrolled) {
  //         isAuthenticated = true;
  //       }
  //     }
  //   }
  //   return isAuthenticated;
  // }
  Future<bool> authenticateWithBiometrics() async {
    final LocalAuthentication auth = LocalAuthentication();
    bool isBiometricSupported = await auth.isDeviceSupported();
    bool canCheckBiometrics = await auth.canCheckBiometrics;
    bool isAuthenticated = false;
    if (isBiometricSupported && canCheckBiometrics) {
      try {
        isAuthenticated = await auth.authenticate(
          localizedReason: 'من فضلك قم بتسجيل الدخول للمحفظة',
          options: const AuthenticationOptions(
            useErrorDialogs: true,
            stickyAuth: true,
            biometricOnly: false,
            sensitiveTransaction: true,
          ),
          authMessages: const [
            AndroidAuthMessages(
              signInTitle: 'قم بتسجيل الدخول للمحفظة',
              cancelButton: 'الغاء',
              biometricHint: 'البصمة',
              biometricNotRecognized: 'لم يتم التحقق من البصمة',
              biometricSuccess: 'تم التحقق بنجاح',
              biometricRequiredTitle: 'من فضلك قم بتسجيل الدخول للمحفظة',
              deviceCredentialsRequiredTitle:
                  'من فضلك قم بتسجيل الدخول للمحفظة',
              deviceCredentialsSetupDescription: 'قم بتسجيل الدخول للمحفظة',
              goToSettingsButton: 'تسجيل الدخول',
              goToSettingsDescription: 'قم بتسجيل الدخول للمحفظة',
            ),
            IOSAuthMessages(
              cancelButton: 'الغاء',
              goToSettingsButton: 'تسجيل الدخول',
              goToSettingsDescription: 'قم بتسجيل الدخول للمحفظة',
              localizedFallbackTitle: 'قم بتسجيل الدخول للمحفظة',
              lockOut: 'من فضلك قم بتسجيل الدخول للمحفظة',
            ),
          ],
        );
        if (isAuthenticated) {
          return true;
        } else {
          showToast('قم بتسجيل الدخول للمحفظة');
          return false;
        }
      } on PlatformException catch (e) {
        if (e.code == auth_error.notAvailable) {
          showToast('غير متاح');
          return false;
        } else if (e.code == auth_error.notEnrolled) {
          showToast('لم يتم التسجيل');
          return false;
        } else {
          log('Error ${e.message ?? e.details?.toString() ?? e.code}');
          showToast('خطأ غير معروف');
          return false;
        }
      }
    } else {
      showToast('غير متاح');
    }
    return isAuthenticated;
  }

  String? getStateNameById(int id) =>
      states.firstWhereOrNull((i) => i.id == id)?.name;

  String? getCityNameById(int stateId, int cityId) => states
      .firstWhereOrNull((i) => i.id == stateId)
      ?.cities
      ?.firstWhereOrNull((c) => c.id == cityId)
      ?.name;

  void setUserDataFour(SignUpData data) {
    _vehiclePlate = data.vehiclePlate;
    _vehicleColor = data.vehicleColor;
    _vehicleModel = data.vehicleModel;
    _deliveryMethod = data.deliveryMethod;
  }

  UserDataByToken? get userDataByToken => _userDataByToken;

  void checkAll(bool value) {
    _checkAllAreas = value;
    notifyListeners();
  }

  void checkAllToggle() {
    _checkAllAreas = !_checkAllAreas;
    notifyListeners();
  }

  void checkAllFirstTime(bool value) {
    _checkAllAreas = value;
  }

  bool get checkAllAreas => _checkAllAreas;

  String? get nationalIdPhotoBack => _nationalIdPhotoBack;

  String? get userPhoto => _userPhoto;

  String? get userPhone => _userPhone;

  String? get firstName => _firstName;

  int? get userId => _userId;

  void addCity(UploadState item, bool firstTime) {
    if (chosenStates.firstWhereOrNull((i) => i.id == item.id) == null) {
      chosenStates.add(item);
    } else {
      int index = chosenStates.indexWhere((i) => i.id == item.id);
      chosenStates[index] = item;
    }
    _chosenStateEmpty = chosenStates.isEmpty;
    if (!firstTime) {
      notifyListeners();
    }
  }

  void clearChosenStatus(int id) {
    chosenStates.removeAt(chosenStates.indexWhere((i) => i.id == id));
    _chosenStateEmpty = chosenStates.isEmpty;
    notifyListeners();
  }

  void getMyAreas(List<int> citiesId) {
    List<Cities>? cities = [];
    states.map((e) => e.cities).toList().forEach((element) {
      for (var i in element ?? []) {
        cities.add(i);
      }
    });
    List<Cities> chosenCities =
        cities.where((e) => citiesId.contains(e.id)).toList();
    for (var chosenCity in chosenCities) {
      int? stateId = chosenCity.stateId;
      addCity(
        UploadState(
          id: stateId ?? 0,
          name: getStateNameById(stateId ?? 0) ?? '',
          chosenCities: chosenCities
              .where(
                (c) => c.stateId == stateId,
              )
              .toList(),
        ),
        true,
      );
    }
    notifyListeners();
  }

  void removeCity(UploadState item) {
    chosenStates.remove(item);
    _chosenStateEmpty = chosenStates.isEmpty;
    notifyListeners();
  }

  bool get chosenStateEmpty => _chosenStateEmpty;

  void removeAllChosenCities() {
    chosenStates.clear();
    notifyListeners();
  }

  void addNewCity(Cities city) {
    chosenCities.add(city);
    notifyListeners();
  }

  void addAllCities(List<Cities> cities) {
    chosenCities = [];
    chosenCities.addAll(cities);
    notifyListeners();
  }

  void removeAllCities() {
    chosenCities.clear();
    notifyListeners();
  }

  void deleteCity(Cities city) {
    chosenCities.remove(city);
    notifyListeners();
  }

  void populateNewCities(int stateId) {
    UploadState? uploadState =
        chosenStates.firstWhereOrNull((i) => i.id == stateId);
    if (uploadState != null) {
      chosenCities.addAll(uploadState.chosenCities);
    }
  }

  int getChosenStatesCities(States s) {
    UploadState? uploadState =
        chosenStates.firstWhereOrNull((i) => i.id == s.id);
    if (uploadState != null) {
      return uploadState.chosenCities.length;
    }
    return 0;
  }

  void clearNewCities() {
    chosenCities.clear();
  }

  void addAllChosenCities(List<UploadState> cities) {
    chosenStates = [];
    chosenStates.addAll(cities);
  }

  bool isCheckAllCities(States s) => chosenCities.length == s.cities?.length;

  bool isCheckAllStates(States s) {
    UploadState? uploadState =
        chosenStates.firstWhereOrNull((i) => i.id == s.id);
    if (uploadState != null) {
      return uploadState.chosenCities.length == s.cities?.length;
    }
    return false;
  }

  bool isInsideChosenCities(Cities item) {
    bool isInside = false;
    Cities? city = chosenCities.firstWhereOrNull((i) => i.id == item.id);
    if (city != null) {
      isInside = true;
    }
    return isInside;
  }

  bool isChosen(int stateId, Cities item) {
    bool isChosen = false;
    UploadState? uploadState =
        chosenStates.firstWhereOrNull((element) => element.id == stateId);
    if (uploadState != null) {
      Cities? city =
          uploadState.chosenCities.firstWhereOrNull((i) => i.id == item.id);
      if (city != null) {
        isChosen = true;
      }
    }
    return isChosen;
  }

  States getStateById(int id) {
    int index = states.indexWhere((i) => i.id == id);
    return states[index];
  }

  void setImageLoading(bool value) {
    _profileImageLoading = value;
    notifyListeners();
  }

  void setFrontIdImageLoading(bool value) {
    _frontIdImageLoading = value;
    notifyListeners();
  }

  void setBackIdImageLoading(bool value) {
    _backIdImageLoading = value;
    notifyListeners();
  }

  Future<String?> saveUser(
    User data,
    String? password,
    bool isLogin,
  ) async {
    try {
      await _preferences.setUserId(data.user!.id.toString());
      await _preferences.setGender(data.user!.gender!);
      await _preferences.setPhoneNumber(data.user!.phone!);
      await _preferences.setUserEmail(data.user!.email!);
      await _preferences.setNationalId(data.user!.nationalIdNumber!);
      if (data.user?.vehicleModel != null) {
        await _preferences.setVehicleModel(data.user!.vehicleModel!);
      }
      if (data.user?.vehicleColor != null) {
        await _preferences.setVehicleColor(data.user!.vehicleColor!);
      }
      if (data.user?.cachedAverageRating != null) {
        await _preferences.setRating(data.user!.cachedAverageRating!);
      }
      if (data.user?.vehicleNumber != null) {
        await _preferences.setVehicleNumber(data.user!.vehicleNumber!);
      }
      if (data.user?.deliveryMethod != null) {
        await _preferences.setDeliveryMethod(data.user!.deliveryMethod!);
      }
      await _preferences.setReceiveNotification(1);
      await _preferences.setIsOnline(1);
      await _preferences.setPassword(password!);
      await _preferences.setTokenType(data.tokenType!);
      if (data.user?.photo != null) {
        await _preferences.setUserPhotoUrl(data.user!.photo!);
      }
      await _preferences
          .setUserName('${data.user!.firstName} ${data.user!.lastName!}');
      await _preferences.setAccessToken(data.accessToken!);
      await _preferences.setExpiresAt(data.expiresAt!);
      await _preferences.setCourierAreas(
          data.user!.deliveryAreas!.map((e) => e.cityId!).toList().toString());
      return success;
    } catch (e) {
      log('error from saveUser -> ${e.toString()}');
      return e.toString();
    }
  }

  NetworkState? get countryState => _countryState;

  Future<void> getCountries() async {
    states = [];
    _countryState = NetworkState.waiting;
    try {
      http.Response r = await HttpHelper.instance.httpGet(
        'location/countries',
        false,
      );
      log(r.body);
      if (r.statusCode >= 200 && r.statusCode < 300) {
        var data = jsonDecode(r.body) as List;
        Countries countries = Countries.fromJson(data[0]);
        states = countries.states ?? [];
        _countryState = NetworkState.success;
      } else {
        _countryState = NetworkState.error;
      }
    } catch (e) {
      log('errors -> ${e.toString()}');
    }
    notifyListeners();
  }

  Future<Img?> uploadPhotoID({String? path, String? imageName}) async {
    try {
      http.Response r = await HttpHelper.instance.httpPost(
        'register/upload-national-id',
        false,
        body: {
          'file': path,
          'filename': imageName,
        },
      );
      if (r.statusCode == 200 && r.statusCode < 300) {
        return Img.fromJson(jsonDecode(r.body));
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<String?> deletePhotoID({String? token, String? imageName}) async {
    try {
      http.Response r = await HttpHelper.instance.httpPost(
        'register/delete-national-id',
        false,
        body: {
          'filename': imageName,
          'token': token,
        },
      );
      if (r.statusCode == 200 && r.statusCode < 300) {
        return success;
      } else {
        return 'error';
      }
    } catch (e) {
      return 'error';
    }
  }

  Future<Img?> uploadPhoto({String? path, String? imageName}) async {
    try {
      http.Response r = await HttpHelper.instance.httpPost(
        'register/upload-image',
        false,
        body: {
          'file': path,
          'filename': imageName,
        },
      );
      if (r.statusCode == 200 && r.statusCode < 300) {
        return Img.fromJson(jsonDecode(r.body));
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<String?> deletePhoto({String? token, String? imageName}) async {
    try {
      http.Response r = await HttpHelper.instance.httpPost(
        'register/delete-image',
        false,
        body: {
          'filename': imageName,
          'token': token,
        },
      );
      if (r.statusCode == 200 && r.statusCode < 300) {
        return success;
      } else {
        return 'error';
      }
    } catch (e) {
      return 'error';
    }
  }

  NetworkState? get isNotificationOnState => _isNotificationOnState;

  NetworkState? get isOnlineState => _isOnlineState;

  Future<void> courierIsOnline({
    int? value,
  }) async {
    _isOnlineState = NetworkState.waiting;
    try {
      http.Response r = await HttpHelper.instance.httpPost(
        'update',
        true,
        body: {
          'online': value,
          'password_verification': password,
        },
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        _isOnlineState = NetworkState.success;
        await _preferences.setIsOnline(jsonDecode(r.body)['online']);
      } else {
        _isOnlineState = NetworkState.error;
      }
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }

  Future<void> courierCarInformation({
    String? vehicleColor,
    String? vehicleNumber,
    String? vehicleModel,
    String? vehicleMethod,
  }) async {
    _carInfoState = NetworkState.waiting;
    try {
      http.Response r = await HttpHelper.instance.httpPost(
        'update',
        true,
        body: {
          'vehicle_model': vehicleModel,
          'vehicle_color': vehicleColor,
          'vehicle_number': vehicleNumber,
          'delivery_method': vehicleMethod,
          'password_verification': password,
        },
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        UserData user = UserData.fromJson(json.decode(r.body));
        await _preferences.setVehicleNumber(user.vehicleNumber!);
        if (user.vehicleColor != null) {
          await _preferences.setVehicleColor(user.vehicleColor!);
        }
        if (user.vehicleModel != null) {
          await _preferences.setVehicleModel(user.vehicleModel!);
        }
        await _preferences.setDeliveryMethod(user.deliveryMethod!);
        _carInfoState = NetworkState.success;
      } else {
        _carInfoState = NetworkState.error;
      }
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }

  Future<void> userReceiveNotification({
    int? value,
  }) async {
    _isNotificationOnState = NetworkState.waiting;
    try {
      http.Response r = await HttpHelper.instance.httpPost(
        'update',
        true,
        body: {
          'receive_notifications': value,
          'password_verification': password,
        },
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        _isNotificationOnState = NetworkState.success;
        await _preferences.setReceiveNotification(
            jsonDecode(r.body)['receive_notifications']);
      } else {
        _isNotificationOnState = NetworkState.error;
      }
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }

  Future<void> getToken() async {
    String? token = await fcm.getToken();
    await _preferences.setFcmToken(token ?? '');
    log('FCM TOKEN -> $token');
  }

  Future<void> updateEmail({
    String? newEmail,
  }) async {
    try {
      _updateEmailState = NetworkState.waiting;
      notifyListeners();
      http.Response r = await HttpHelper.instance.httpPost(
        'update',
        true,
        body: {
          'email': newEmail,
          'password_verification': password,
        },
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        _user = User.fromJson(jsonDecode(r.body));
        await _preferences.setUserEmail(newEmail ?? '');
        _updateEmailState = NetworkState.success;
      } else {
        _updateEmailState = NetworkState.error;
      }
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }

  Future<void> getCurrentUserdata(bool retry) async {
    try {
      _updateAreasState = NetworkState.waiting;
      if (retry) {
        notifyListeners();
      }
      http.Response r = await HttpHelper.instance.httpPost(
        'me',
        true,
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        _userDataByToken = UserDataByToken.fromJson(jsonDecode(r.body));
        getMyAreas(
            _userDataByToken!.deliveryAreas!.map((e) => e.cityId!).toList());
        _updateAreasState = NetworkState.success;
      } else {
        _updateAreasState = NetworkState.error;
      }
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }

  Future<void> updateAreas({
    List<int>? areasId,
  }) async {
    try {
      log('areassss -> $areasId');
      _updateAreasState = NetworkState.waiting;
      notifyListeners();
      http.Response r = await HttpHelper.instance.httpPost(
        'update',
        true,
        body: {
          'cities': areasId,
          'password_verification': password,
        },
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        await _preferences.setCourierAreas(areasId.toString());
        _updateAreasState = NetworkState.success;
      } else {
        _updateAreasState = NetworkState.error;
      }
    } catch (e) {
      log('areas error -> ${e.toString()}');
    }
    notifyListeners();
  }

  Future<void> updatePassword({
    String? password,
    String? currentPassword,
  }) async {
    try {
      _updatePasswordState = NetworkState.waiting;
      notifyListeners();
      http.Response r = await HttpHelper.instance.httpPost(
        'update',
        true,
        body: {
          'password': password,
          'password_verification': currentPassword,
        },
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        _userData = UserData.fromJson(jsonDecode(r.body));
        await _preferences.setPassword(password!);
        _updatePasswordState = NetworkState.success;
      } else {
        if (json.decode(r.body)['message'] == 'password is incorrect!') {
          _currentPasswordIsIncorrect = true;
        }
        _updatePasswordState = NetworkState.error;
      }
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }

  Future<void> updatePhone({
    BuildContext? context,
    VoidCallback? onApprove,
    String? phone,
  }) async {
    try {
      _updatePhoneState = NetworkState.waiting;
      notifyListeners();
      http.Response r = await HttpHelper.instance.httpPost(
        'update',
        true,
        body: {
          'phone': phone,
          'password_verification': _preferences.getPassword,
        },
      );
      log('${json.decode(r.body)}');
      if (r.statusCode >= 200 && r.statusCode < 300) {
        UpdateUserData updateData =
            UpdateUserData.fromJson(json.decode(r.body));
        await _preferences.setPhoneNumber(updateData.phone!);
        _updatePhoneState = NetworkState.success;
      } else {
        String? msg = json.decode(r.body)['errors']['phone'][0];
        if (msg == 'The phone has already been taken.') {
          showDialog(
              context: navigator.currentContext!,
              builder: (context) => ActionDialog(
                    content: 'الرقم موجود بالفعل',
                    onApproveClick: onApprove,
                    approveAction: 'حسناً',
                  ));
        }
        _updatePhoneState = NetworkState.error;
      }
    } catch (e) {
      log('update phone error -> ${e.toString()}');
    }
    notifyListeners();
  }

  Future<void> updatePersonalInfo({
    String? firstName,
    String? lastName,
    String? dateOfBirth,
    String? gender,
    String? photo,
  }) async {
    try {
      _updateCourierPersonalInfoState = NetworkState.waiting;
      http.Response r;
      r = await HttpHelper.instance.httpPost(
        'update',
        true,
        body: {
          'first_name': firstName,
          'last_name': lastName,
          'gender': gender,
          if (photo != null) 'photo': photo,
          'password_verification': password,
          'date_of_birth': dateOfBirth,
        },
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        await _preferences.setUserName('$firstName $lastName');
        await _preferences.setDateOfBirth(dateOfBirth!);
        await _preferences.setGender(gender!);
        if (photo != null) {
          await _preferences.setUserPhotoUrl(photo);
        }
        _updateCourierPersonalInfoState = NetworkState.success;
      } else {
        _updateCourierPersonalInfoState = NetworkState.error;
      }
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }

  void setAddressSelectedItem(int i) {
    _addressSelectedItem = i;
    notifyListeners();
  }

  int get addressSelectedItem => _addressSelectedItem;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool get isLoading => _isLoading;

  void updateScreen(int i) {
    _screenIndex = i;
    getCurrentPage(i);
    notifyListeners();
  }

  bool get test => _test;

  int get screenIndex => _screenIndex;

  Widget get currentPage => _page;

  NetworkState? get createNewUserState => _createNewUserState;

  Future<void> createNewUser(WeevoUser user) async {
    log(user.toJson().toString());
    try {
      _createNewUserState = NetworkState.waiting;
      http.Response r = await HttpHelper.instance.httpPost(
        'register',
        false,
        body: user.toJson(),
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        createUser = User.fromJson(jsonDecode(r.body));
        _userId = createUser?.user?.id;
        createUserPassword = user.password;
        _createNewUserState = NetworkState.success;
      } else {
        Map<String?, dynamic> map = jsonDecode(r.body)['errors'];
        if (map.containsKey('email')) {
          _createNewUserMessage = 'الأيميل موجود بالفعل';
        } else if (map.containsKey('phone')) {
          _createNewUserMessage = 'الهاتف موجود بالفعل';
        } else {
          _createNewUserMessage = 'حدث خطأ برجاء المحاولة مرة اخري';
        }
        _createNewUserState = NetworkState.error;
      }
      log(r.body);
      log('status code -> ${r.statusCode}');
    } catch (e) {
      log('catch error -> ${e.toString()}');
    }
    notifyListeners();
  }

  NetworkState? get courierCriticalUpdateState => _courierCriticalUpdateState;

  CourierCriticalUpdate? get courierCriticalUpdate => _courierCriticalUpdate;

  Future<void> getCourierCommission() async {
    _courierCommissionState = NetworkState.waiting;
    try {
      http.Response r = await HttpHelper.instance.httpGet(
        'app/get-weevo-commission',
        true,
      );
      await _preferences
          .setWeevoCommission(json.decode(r.body)['commission_rate']);
      if (r.statusCode >= 200 && r.statusCode < 300) {
        _courierCommissionState = NetworkState.success;
      } else {
        _courierCommissionState = NetworkState.error;
      }
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }

  Future<void> courierUpdate(String? currentVersion) async {
    _courierCriticalUpdateState = NetworkState.waiting;
    try {
      http.Response r = await HttpHelper.instance.httpPost(
        'check-for-critical-update',
        false,
        body: {
          'current_app_version': currentVersion,
          'os': Platform.isAndroid ? 'android' : 'ios',
        },
      );
      await _preferences.setAppVersionNumber(currentVersion!);
      if (r.statusCode >= 200 && r.statusCode < 300) {
        _courierCriticalUpdate =
            CourierCriticalUpdate.fromJson(json.decode(r.body));
        log("UpdateData -> ${r.body}");
        _courierCriticalUpdateState = NetworkState.success;
      } else {
        _courierCriticalUpdateState = NetworkState.error;
      }
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }

  Future<void> setCurrentCaptainLocation() async {
    await getUserLocation();
    try {
      Response r = await HttpHelper.instance.httpPost(
        'set-current-location',
        true,
        body: {
          'lat': _locationData?.latitude,
          'lng': _locationData?.longitude,
        },
      );
      log('send current location body -> ${r.body}');
      log('send current location url -> ${r.request?.url}');
      log('send current location statusCode -> ${r.statusCode}');
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> loginUser({
    required String? email,
    required String? password,
  }) async {
    try {
      _loginState = NetworkState.waiting;
      http.Response r = await HttpHelper.instance.httpPost(
        'login',
        false,
        body: {
          'login': email,
          'password': password,
        },
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        userLoginData = User.fromJson(json.decode(r.body));
        createUserPassword = password;
        await getFirebaseToken();
        if (userLoginData?.user?.emailVerifiedAt != null) {
          await saveUser(userLoginData!, createUserPassword, true);
          setLoading(false);
          Navigator.pushReplacementNamed(
            navigator.currentContext!,
            AfterRegistration.id,
          );
        } else {
          isLogin = true;
          _userPhone = userLoginData?.user?.phone;
          _userEmail = userLoginData?.user?.email;
          _nationalIdNumber = userLoginData?.user?.nationalIdNumber;
          verifyPhoneNumber();
        }
        _loginState = NetworkState.success;
      } else {
        setLoading(false);
        showDialog(
            context: navigator.currentContext!,
            builder: (_) => ActionDialog(
                  content: '${json.decode(r.body)['message']}',
                  approveAction: 'حسناً',
                  onApproveClick: () {
                    Navigator.pop(navigator.currentContext!);
                  },
                ));
        _loginState = NetworkState.error;
      }
    } catch (e) {
      log('error -> ${e.toString()}');
    }
    notifyListeners();
  }

  Future<bool> checkConnection() async {
    List<ConnectivityResult> result = await Connectivity().checkConnectivity();
    if (result.contains(ConnectivityResult.wifi) ||
        result.contains(ConnectivityResult.mobile)) {
      return true;
    }
    return false;
  }

  void getCurrentPage(int i) {
    switch (i) {
      case 0:
        _page = const SignUpPersonalInfo();
        break;
      // case 1:
      //   _page = SignUpPhoneVerification();
      //   break;
      case 1:
        _page = const SignUpNationalIDScreen();
        break;
      case 2:
        _page = const SignUpCarInfo();
        break;
      case 3:
        _page = const SignUpChooseArea();
        break;
    }
  }

  States? get state => _state;

  Cities? get city => _city;

  String? get id => _preferences.getUserId;

  String? get appVersion => _preferences.getCurrentAppVersionNumber;

  String? get getNationalId => _preferences.getPhoneNumber;

  String? get getRating => _preferences.getRating;

  int get addressId => _preferences.getAddressId;

  String? get password => _preferences.getPassword;

  String? get gender => _preferences.getGender;

  String? get name => _preferences.getUserName;

  String? get dateOfBirth => _preferences.getDateOfBirth;

  String? get email => _preferences.getUserEmail;

  String? get photo => _preferences.getUserPhotoUrl;

  String? get expirationDate => _preferences.getExpiresAt;

  String? get token => _preferences.getAccessToken;

  String? get phone => _preferences.getPhoneNumber;

  int get receiveNotification => _preferences.getReceiveNotification;

  int get isOnline => _preferences.getIsOnline;

  String? get courierAreas => _preferences.getCourierAreas;

  void reset() {
    _userId = null;
    _firstName = null;
    _lastName = null;
    _userPhoto = null;
    _userPhone = null;
    _userEmail = null;
    _userGender = null;
    _userPassword = null;
    _verificationId = null;
    _userFirebaseToken = null;
    _nationalIdNumber = null;
    _nationalIdPhotoBack = null;
    _nationalIdPhotoFront = null;
    _vehicleColor = null;
    _vehicleModel = null;
    _vehiclePlate = null;
    _deliveryMethod = null;
    chosenStates.clear();
    _screenIndex = 0;
    _page = const SignUpPersonalInfo();
  }

  void clearChosenAreas() {
    chosenStates.clear();
  }

  String? get nationalIdNumber => _nationalIdNumber;

  String? get tokenIsValid => _preferences.getAccessToken.isNotEmpty &&
          _preferences.getExpiresAt.isNotEmpty &&
          DateTime.parse(_preferences.getExpiresAt).isAfter(DateTime.now())
      ? _preferences.getAccessToken
      : null;

  bool get isValid => tokenIsValid != null;

  String? get appAuthorization =>
      '${_preferences.getTokenType} ${_preferences.getAccessToken}';

  String? get lastName => _lastName;

  String? get userEmail => _userEmail;

  String? get userGender => _userGender;

  String? get userPassword => _userPassword;

  String? get nationalIdPhotoFront => _nationalIdPhotoFront;

  bool get backIdImageLoading => _backIdImageLoading;

  String? get fcmToken => _preferences.getFcmToken;

  String? get vehicleModel => _vehicleModel;

  String? get deliveryMethod => _deliveryMethod;

  String? get vehiclePlate => _vehiclePlate;

  final bool _kShouldTestAsyncErrorOnInit = false;

// Toggle this for testing Crashlytics in your app locally.
//   bool _kTestingCrashlytics = false;

  // ignore: unused_element
  Future<void> _testAsyncErrorOnInit() async {
    Future<void>.delayed(const Duration(seconds: 2), () {
      final List<int> list = <int>[];
      log(list[100].toString());
    });
  }

  // initializeFirebaseCrashlytics() {
  //   FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  // }

  int start = 120;
  bool wait = false;
  SendOtpModel? sendOtpModel;
  ResendOtpModel? resendOtpModel;
  String? otpToken;
  User? createUser;
  User? userLoginData;
  String? createUserPassword;
  bool isLogin = false;

  void startTimer() {
    const onsec = Duration(seconds: 1);
    wait = true;
    Timer timer = Timer.periodic(onsec, (timer) {
      if (start == 0) {
        timer.cancel();
        wait = false;
      } else {
        start--;
      }
      notifyListeners();
    });
  }

  void resendReset() {
    wait = true;
    notifyListeners();
  }

  format(Duration d) =>
      d.toString().split('.').first.padLeft(8, "0").substring(3, 8);

  Future<void> verifyPhoneNumber() async {
    try {
      http.Response r = await HttpHelper.instance.httpPost(
        '${ApiConstants.baseUrl}/api/v2/captin/register/send-otp',
        false,
        withoutPath: true,
        body: {
          "phone": _userPhone,
          "email": _userEmail,
          // "national_id_number": _nationalIdNumber,
        },
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        sendOtpModel = SendOtpModel.fromJson(json.decode(r.body));
        otpToken = sendOtpModel?.otpToken;
        start = ((sendOtpModel?.retryAfter?.toInt() ?? 0) * 60);
        resendReset();
        startTimer();
        setLoading(false);
        Navigator.pushNamed(
            navigator.currentContext!, SignUpPhoneVerification.id);
      } else {
        setLoading(false);
        showDialog(
            context: navigator.currentContext!,
            builder: (_) => ActionDialog(
                  content: '${json.decode(r.body)['message']}',
                  approveAction: 'حسناً',
                  onApproveClick: () {
                    Navigator.pop(navigator.currentContext!);
                  },
                ));
      }
    } catch (e) {
      log('verifyPhoneNumber error -> ${e.toString()}');
    }
    notifyListeners();
  }

  Future<void> checkOtp({
    required String? otp,
  }) async {
    try {
      showDialog(
          context: navigator.currentContext!,
          builder: (context) => const Loading());
      http.Response r = await HttpHelper.instance.httpPost(
        '${ApiConstants.baseUrl}/api/v2/captin/register/check-otp',
        false,
        withoutPath: true,
        body: {
          "otp": otp,
          "otp_token": otpToken,
          "identifier": _userPhone,
        },
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        if (isLogin) {
          reset();
          await saveUser(userLoginData!, createUserPassword, true);
        } else {
          reset();
          await saveUser(createUser!, createUserPassword, false);
        }
        Navigator.pop(navigator.currentContext!);
        Navigator.pushNamedAndRemoveUntil(
            navigator.currentContext!, AfterRegistration.id, (route) => false);
      } else {
        Navigator.pop(navigator.currentContext!);
        showDialog(
            context: navigator.currentContext!,
            builder: (_) => ActionDialog(
                  content: '${json.decode(r.body)['message']}',
                  approveAction: 'حسناً',
                  onApproveClick: () {
                    Navigator.pop(navigator.currentContext!);
                  },
                ));
      }
    } catch (e) {
      log('error from create user -> ${e.toString()}');
    }
  }

  Future<void> resendOtp() async {
    try {
      showDialog(
          context: navigator.currentContext!,
          barrierDismissible: false,
          builder: (context) => const Loading());
      http.Response r = await HttpHelper.instance.httpPost(
        '${ApiConstants.baseUrl}/api/v2/captin/register/resend-otp',
        false,
        withoutPath: true,
        body: {
          "identifier": _userPhone,
        },
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        Navigator.pop(navigator.currentContext!);
        resendOtpModel = ResendOtpModel.fromJson(json.decode(r.body));
        otpToken = resendOtpModel?.otpToken;
        start = ((resendOtpModel?.retryAfter?.toInt() ?? 0) * 60);
        resendReset();
        startTimer();
      } else {
        Navigator.pop(navigator.currentContext!);
        showDialog(
            context: navigator.currentContext!,
            builder: (_) => ActionDialog(
                  content: '${json.decode(r.body)['message']}',
                  approveAction: 'حسناً',
                  onApproveClick: () {
                    Navigator.pop(navigator.currentContext!);
                  },
                ));
      }
    } catch (e) {
      log('error from create user -> ${e.toString()}');
    }
  }

  Future<void> getFirebaseToken() async {
    fresh_chat.Freshchat.setNotificationConfig(
      priority: fresh_chat.Priority.PRIORITY_HIGH,
      importance: fresh_chat.Importance.IMPORTANCE_MAX,
      notificationSoundEnabled: true,
    );
    String? token = await fcm.getToken();
    fresh_chat.Freshchat.setPushRegistrationToken(token!);
    fcm.subscribeToTopic('all');
    fcm.subscribeToTopic('courier');
    await _preferences.setFcmToken(token);
    fcm.onTokenRefresh.listen(fresh_chat.Freshchat.setPushRegistrationToken);
  }

  void updateResetPasswordScreen(int i) {
    _resetPasswordIndex = i;
    getCurrentResetPasswordWidget(i);
    notifyListeners();
  }

  void setVerificationId(String? v) {
    _verificationId = v;
  }

  void setResetPhoneNumber(String? v) {
    _userPhone = v;
  }

  void setResetUserFirebaseToken(String? v) {
    _userFirebaseToken = v;
  }

  void getCurrentResetPasswordWidget(int i) {
    switch (i) {
      case 0:
        _resetPasswordWidget = const ResetPassword0();
        break;
      case 1:
        _resetPasswordWidget = const ResetPassword1();
        break;
      case 2:
        _resetPasswordWidget = const ResetPassword2();
        break;
    }
  }

  Future<void> notificationOff() async {
    await userReceiveNotification(value: 0);
  }

  Future<void> courierOnline() async {
    await courierIsOnline(value: 1);
  }

  Future<void> courierOffline() async {
    await courierIsOnline(value: 0);
  }

  Future<void> notificationOn() async {
    await userReceiveNotification(value: 1);
  }

  Future<void> getInitMessage() async {
    RemoteMessage? message = await fcm.getInitialMessage();
    goTo(message);
  }

  int get notificationsNo => _notificationsNo;

  Future<void> getArticle() async {
    _articleState = NetworkState.waiting;
    try {
      http.Response r = await HttpHelper.instance.httpGet(
        'articles',
        true,
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        Articles article = Articles.fromJson(json.decode(r.body));
        _articles = article.data;
        _articleState = NetworkState.success;
      } else {
        _articleState = NetworkState.error;
      }
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }

  void increaseChatCounter(int count) async {
    _totalMessages = count;
  }

  void increaseNotificationCounter(int count) async {
    _totalNotifications = count;
  }

  void resetShipmentNotification() {
    _notificationsNo = 0;
    _dialogOpen = false;
    notifyListeners();
  }

  int get totalNotifications => _totalNotifications;

  int get totalMessages => _totalMessages;

  List<ArticlesData>? get articles => _articles;

  void goTo(RemoteMessage? m) {
    if (m != null) {
      if (m.data['has_offer'] == '1' && m.data['better_offer'] == '0') {
        _notificationsNo++;
        Navigator.pushReplacementNamed(navigator.currentContext!, Home.id);
        if (!_dialogOpen) {
          _dialogOpen = true;
          showDialog(
            context: navigator.currentContext!,
            barrierDismissible: false,
            builder: (context) => ShipmentDialog(
              shipmentNotification:
                  ShipmentNotification.fromMap(json.decode(m.data['data'])),
              betterOffer: false,
              onDetailsCallback: () {
                _dialogOpen = false;
                _notificationsNo--;
                notifyListeners();
              },
              onAvailableOkPressed: () {
                _notificationsNo--;
                _dialogOpen = false;
                notifyListeners();
                sendNotification(
                    title: 'ويفو وفرلك كابتن',
                    body: 'الكابتن $name قبل طلب الشحن وتم خصم مقدمالشحنة',
                    toToken: ShipmentNotification.fromMap(
                            json.decode(m.data['data']))
                        .merchantFcmToken,
                    image: photo != null
                        ? photo!.contains(ApiConstants.baseUrl)
                            ? photo
                            : '${ApiConstants.baseUrl}$photo'
                        : '',
                    type: '',
                    screenTo: 'shipment_offers',
                    data: ShipmentNotification.fromMap(
                            json.decode(m.data['data']))
                        .toMap());
              },
              onOfferOkPressed: () {
                _dialogOpen = false;
                _notificationsNo--;
                notifyListeners();
                sendNotification(
                    title: 'وصلك عرض شحن',
                    body: 'الكابتن $name قدم عرض لشحن أوردرك',
                    toToken: token,
                    image: photo != null && photo!.isNotEmpty
                        ? photo!.contains(ApiConstants.baseUrl)
                            ? photo
                            : '${ApiConstants.baseUrl}$photo'
                        : '',
                    type: '',
                    screenTo: 'shipment_offers',
                    data: ShipmentNotification.fromMap(
                            json.decode(m.data['data']))
                        .toMap());
              },
              onRefuseShipment: () {
                _dialogOpen = false;
                _notificationsNo--;
                notifyListeners();
                Navigator.pop(context);
              },
            ),
          );
        }
      } else if (m.data['has_offer'] == '1' && m.data['better_offer'] == '1') {
        _notificationsNo++;
        Navigator.pushReplacementNamed(navigator.currentContext!, Home.id);
        if (!_dialogOpen) {
          _dialogOpen = true;
          showDialog(
            context: navigator.currentContext!,
            barrierDismissible: false,
            builder: (context) => ShipmentDialog(
              shipmentNotification:
                  ShipmentNotification.fromMap(json.decode(m.data['data'])),
              betterOffer: true,
              onDetailsCallback: () {
                _dialogOpen = false;
                _notificationsNo--;
                notifyListeners();
              },
              onAvailableOkPressed: () {
                _notificationsNo--;
                _dialogOpen = false;
                notifyListeners();
                sendNotification(
                    title: 'ويفو وفرلك مندوب',
                    body: 'الكابتن $name قبل طلب الشحن وتم خصم مقدمالشحنة',
                    toToken: ShipmentNotification.fromMap(
                            json.decode(m.data['data']))
                        .merchantFcmToken,
                    image: photo != null
                        ? photo!.contains(ApiConstants.baseUrl)
                            ? photo
                            : '${ApiConstants.baseUrl}$photo'
                        : '',
                    type: '',
                    screenTo: 'shipment_offers',
                    data: ShipmentNotification.fromMap(
                            json.decode(m.data['data']))
                        .toMap());
              },
              onOfferOkPressed: () async {
                _dialogOpen = false;
                _notificationsNo--;
                notifyListeners();
                sendNotification(
                    title: 'عرض أفضل',
                    body: 'تم تقديم عرض أفضل من الكابتن $name',
                    toToken: ShipmentNotification.fromMap(
                            json.decode(m.data['data']))
                        .merchantFcmToken,
                    image: photo != null
                        ? photo!.contains(ApiConstants.baseUrl)
                            ? photo
                            : '${ApiConstants.baseUrl}$photo'
                        : '',
                    type: '',
                    screenTo: 'shipment_offers',
                    data: ShipmentNotification.fromMap(
                            json.decode(m.data['data']))
                        .toMap());
              },
              onRefuseShipment: () {
                _dialogOpen = false;
                _notificationsNo--;
                notifyListeners();
                Navigator.pop(context);
              },
            ),
          );
        }
      } else if (m.data['type'] == 'rating') {
        MagicRouter.navigateAndPopAll(RatingDialog(
            model: ShipmentTrackingModel.fromJson(json.decode(
          m.data['data'],
        ))));
      } else if (m.data['type'] == 'wasully_rating') {
        MagicRouter.navigateAndPopAll(WasullyRatingDialog(
            model: ShipmentTrackingModel.fromJson(json.decode(
          m.data['data'],
        ))));
      } else {
        _fromOutsideNotification = true;
        switch (m.data['screen_to']) {
          case homeScreen:
            Navigator.pushReplacementNamed(navigator.currentContext!, Home.id);
            break;
          case wallet:
            Navigator.pushReplacementNamed(
                navigator.currentContext!, Wallet.id);
            break;
          case shipmentScreen:
            if (m.data['data']['has_children']) {
              Navigator.pushReplacementNamed(
                  navigator.currentContext!, ShipmentDetailsDisplay.id,
                  arguments: m.data['data']['shipment_id']);
            } else {
              Navigator.pushReplacementNamed(
                  navigator.currentContext!, ChildShipmentDetails.id,
                  arguments: m.data['data']['shipment_id']);
            }
            break;
          case shipmentDetailsScreen:
            if (AcceptMerchantOffer.fromMap(json.decode(m.data['data']))
                    .childrenShipment ==
                0) {
              Navigator.pushNamed(
                  navigator.currentContext!, ShipmentDetailsDisplay.id,
                  arguments:
                      AcceptMerchantOffer.fromMap(json.decode(m.data['data']))
                          .shipmentId);
            } else {
              Navigator.pushNamed(
                  navigator.currentContext!, ChildShipmentDetails.id,
                  arguments:
                      AcceptMerchantOffer.fromMap(json.decode(m.data['data']))
                          .shipmentId);
            }
            break;
          case handleShipmentScreen:
            Navigator.pushReplacementNamed(
                navigator.currentContext!, HandleShipment.id,
                arguments: ShipmentTrackingModel.fromJson(
                    json.decode(m.data['data'])));
            break;
          case noScreen:
            showDialog(
                context: navigator.currentContext!,
                builder: (c) => ActionDialog(
                      content:
                          'تم الغاء الشحنة من قبل التاجر\nيمكنك التقديم علي شحنات اخري\nمن صفحة الشحنات المتاحة',
                      approveAction: 'حسناً',
                      onApproveClick: () {
                        Navigator.pop(c);
                      },
                    ));
            break;
          case walletScreen:
            Navigator.pushReplacementNamed(
                navigator.currentContext!, Wallet.id);
            break;
          case chatScreen:
            ChatData chatData = ChatData.fromJson(json.decode(m.data['data']));
            ChatData chatData0;
            if (chatData.currentUserNationalId == getNationalId) {
              chatData0 = ChatData(
                currentUserNationalId: chatData.currentUserNationalId,
                peerNationalId: chatData.peerNationalId,
                currentUserId: chatData.currentUserId,
                peerId: chatData.peerId,
                peerImageUrl: chatData.peerImageUrl,
                peerUserName: chatData.peerUserName,
                shipmentId: chatData.shipmentId,
                currentUserName: chatData.currentUserName,
                currentUserImageUrl: chatData.currentUserImageUrl,
                conversionId: chatData.conversionId,
                type: chatData.type,
              );
            } else {
              chatData0 = ChatData(
                peerNationalId: chatData.currentUserNationalId,
                currentUserNationalId: chatData.peerNationalId,
                currentUserId: chatData.peerId,
                peerId: chatData.currentUserId,
                peerImageUrl: chatData.currentUserImageUrl,
                peerUserName: chatData.currentUserName,
                currentUserName: chatData.peerUserName,
                shipmentId: chatData.shipmentId,
                currentUserImageUrl: chatData.peerImageUrl,
                conversionId: chatData.conversionId,
                type: chatData.type,
              );
            }
            Navigator.pushReplacementNamed(
                navigator.currentContext!, ChatScreen.id,
                arguments: chatData0);
            break;
          default:
            isValid
                ? Navigator.pushReplacementNamed(
                    navigator.currentContext!,
                    Home.id,
                  )
                : Navigator.pushReplacementNamed(
                    navigator.currentContext!,
                    OnBoarding.id,
                  );
        }
      }
    } else {
      isValid
          ? Navigator.pushReplacementNamed(
              navigator.currentContext!,
              Home.id,
            )
          : Navigator.pushReplacementNamed(
              navigator.currentContext!,
              OnBoarding.id,
            );
    }
  }

  Future<bool> checkPhoneExisted(String? phone) async {
    _existedState = NetworkState.waiting;
    try {
      http.Response r = await HttpHelper.instance.httpPost(
        'register/check-existence',
        false,
        body: {
          'login': phone,
        },
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        AccountExisted accountExisted =
            AccountExisted.fromJson(json.decode(r.body));
        _existedState = NetworkState.success;
        notifyListeners();
        return accountExisted.existed;
      } else {
        _existedState = NetworkState.error;
        notifyListeners();
        return false;
      }
    } catch (e) {
      log(e.toString());
      _existedState = NetworkState.error;
      notifyListeners();

      return false;
    }
  }

  Future<bool> checkEmailExisted(String? email) async {
    _existedState = NetworkState.waiting;
    try {
      http.Response r = await HttpHelper.instance.httpPost(
        'register/check-existence',
        false,
        body: {
          'login': email,
        },
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        AccountExisted accountExisted =
            AccountExisted.fromJson(json.decode(r.body));
        _existedState = NetworkState.success;
        notifyListeners();
        return accountExisted.existed;
      } else {
        _existedState = NetworkState.error;
        notifyListeners();
        return false;
      }
    } catch (e) {
      log(e.toString());
      _existedState = NetworkState.error;
      notifyListeners();
      return false;
    }
  }

  NetworkState? get existedState => _existedState;

  bool? get dialogOpen => _dialogOpen;

  String? get courierVehicleNumber => _preferences.getCourierVehicleNumber;

  String? get courierVehicleModel => _preferences.getCourierVehicleModel;

  String? get courierVehicleColor => _preferences.getCourierVehicleColor;

  String? get courierDeliveryMethod => _preferences.getCourierDeliveryMethod;

  Future<void> resetPassword({
    required String? firebaseToken,
    required String? phone,
    required String? password,
    required String? passwordConfirmation,
  }) async {
    try {
      http.Response r = await HttpHelper.instance.httpPost(
        'password/reset',
        false,
        body: {
          'firebase_token': firebaseToken,
          'phone': phone,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        _resetPasswordState = NetworkState.success;
      } else {
        if (json.decode(r.body)['message'] == "User doesn't exist!") {
          _resetPasswordMessage = 'هذا الحساب غير موجود';
        } else if (json.decode(r.body).toString().contains('errors')) {
          if (json.decode(r.body)['errors']['password'][0] ==
              "The password must be at least 8 characters.") {
            _resetPasswordMessage =
                'يجب ان تكون كلمة المرور مكونة من 8 أحرف علي الاقل';
          }
        } else {
          _resetPasswordMessage = 'حدث خطأ حاول مرة اخري';
        }
        _resetPasswordState = NetworkState.error;
      }
    } catch (e) {
      log('error from reset password -> ${e.toString()}');
    }
    notifyListeners();
  }

  Future<void> logout(bool logoutOtherDevices) async {
    try {
      http.Response r = await HttpHelper.instance.httpPost(
        'logout?logout_other_devices=$logoutOtherDevices',
        true,
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        await _preferences.clearUser();
        _logoutState = NetworkState.success;
      } else {
        _logoutState = NetworkState.error;
      }
    } catch (e) {
      log('error from logout user -> ${e.toString()}');
    }
    notifyListeners();
  }

  Future<void> clearUserData() async {
    await _preferences.clearUser();
  }

  Future<void> authLogin() async {
    try {
      Response r = await HttpHelper.instance.httpPost(
        'login',
        false,
        body: {
          'login': _preferences.getPhoneNumber,
          'password': _preferences.getPassword,
        },
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        userLoginData = User.fromJson(json.decode(r.body));
        await Future.wait([
          _preferences.setTokenType(userLoginData!.tokenType!),
          _preferences.setAccessToken(userLoginData!.accessToken!),
        ]);
      }
    } catch (e) {
      log('login error -> ${e.toString()}');
    }
  }

  Future<void> deleteAccount() async {
    try {
      showDialog(
          context: navigator.currentContext!, builder: (_) => const Loading());
      http.Response r = await HttpHelper.instance.httpDelete(
        'deleted-account/${_preferences.getUserId}',
        true,
      );
      log('deleteAccount -> ${r.body}');
      log('deleteAccount -> ${r.statusCode}');
      if (r.statusCode >= 200 && r.statusCode < 300) {
        MagicRouter.pop();
        showDialog(
            context: navigator.currentContext!,
            builder: (_) => ActionDialog(
                  content: r.body,
                  approveAction: 'حسناً',
                  onApproveClick: () async {
                    await _preferences.clearUser();
                    MagicRouter.pop();
                    MagicRouter.navigateAndPopAll(const BeforeRegistration());
                  },
                ));
      } else {
        MagicRouter.pop();
        showDialog(
            context: navigator.currentContext!,
            builder: (_) => ActionDialog(
                  content: r.body,
                  approveAction: 'حسناً',
                  onApproveClick: () async {
                    MagicRouter.pop();
                  },
                ));
      }
    } catch (e) {
      log('error -> ${e.toString()}');
    }
  }

  void initialFCM(BuildContext context) async {
    FirebaseMessaging.onMessage.listen((RemoteMessage m) async {
      log('Data -> ${m.data}');
      if (await fresh_chat.Freshchat.isFreshchatNotification(m.data)) {
        log("is Freshchat notification -> ${await fresh_chat.Freshchat.isFreshchatNotification(m.data)}");
        fresh_chat.Freshchat.handlePushNotification(m.data);
      }
      final notification = m.notification;
      if (notification != null) {
        if (m.data['has_offer'] == '1' && m.data['better_offer'] == '0') {
          _notificationsNo++;
          if (!_dialogOpen) {
            _dialogOpen = true;
            showDialog(
                context: navigator.currentContext!,
                barrierDismissible: false,
                builder: (context) {
                  return ShipmentDialog(
                    shipmentNotification: ShipmentNotification.fromMap(
                      jsonDecode(m.data['data']),
                    ),
                    betterOffer: false,
                    onDetailsCallback: () {
                      _dialogOpen = false;
                      _notificationsNo--;
                      notifyListeners();
                    },
                    onAvailableOkPressed: () {
                      _notificationsNo--;
                      _dialogOpen = false;
                      notifyListeners();
                      sendNotification(
                          title: 'ويفو وفرلك كابتن',
                          body:
                              'الكابتن $name قبل طلب الشحن وتم خصم مقدمالشحنة',
                          toToken: ShipmentNotification.fromMap(
                                  json.decode(m.data['data']))
                              .merchantFcmToken,
                          image: photo != null
                              ? photo!.contains(ApiConstants.baseUrl)
                                  ? photo
                                  : '${ApiConstants.baseUrl}$photo'
                              : '',
                          type: '',
                          screenTo: 'shipment_offers',
                          data: ShipmentNotification.fromMap(
                                  json.decode(m.data['data']))
                              .toMap());
                    },
                    onOfferOkPressed: () {
                      _notificationsNo--;
                      _dialogOpen = false;
                      notifyListeners();
                      sendNotification(
                          title: 'عرض جديد',
                          body: 'الكابتن $name قدم عرض لشحن أوردرك',
                          toToken: token,
                          image: photo != null && photo!.isNotEmpty
                              ? photo!.contains(ApiConstants.baseUrl)
                                  ? photo
                                  : '${ApiConstants.baseUrl}$photo'
                              : '',
                          type: '',
                          screenTo: 'shipment_offers',
                          data: ShipmentNotification.fromMap(
                                  json.decode(m.data['data']))
                              .toMap());
                    },
                    onRefuseShipment: () {
                      _notificationsNo--;
                      _dialogOpen = false;
                      Navigator.pop(context);
                      notifyListeners();
                    },
                  );
                });
          }
        } else if (m.data['has_offer'] == '1' &&
            m.data['better_offer'] == '1') {
          log('shipment notification data from better offer ->> ${m.data}');
          _notificationsNo++;
          if (!_dialogOpen) {
            _dialogOpen = true;
            showDialog(
                context: navigator.currentContext!,
                barrierDismissible: false,
                builder: (context) {
                  return ShipmentDialog(
                    shipmentNotification: ShipmentNotification.fromMap(
                        json.decode(m.data['data'])),
                    betterOffer: true,
                    onDetailsCallback: () {
                      _dialogOpen = false;
                      _notificationsNo--;
                      notifyListeners();
                    },
                    onOfferOkPressed: () {
                      _notificationsNo--;
                      _dialogOpen = false;
                      notifyListeners();
                      sendNotification(
                          title: 'عرض أفضل',
                          body: 'تم تقديم عرض أفضل من الكابتن $name',
                          toToken: ShipmentNotification.fromMap(
                                  json.decode(m.data['data']))
                              .merchantFcmToken,
                          image: photo != null
                              ? photo!.contains(ApiConstants.baseUrl)
                                  ? photo
                                  : '${ApiConstants.baseUrl}$photo'
                              : '',
                          type: '',
                          screenTo: 'shipment_offers',
                          data: ShipmentNotification.fromMap(
                                  json.decode(m.data['data']))
                              .toMap());
                    },
                    onAvailableOkPressed: () {
                      _notificationsNo--;
                      _dialogOpen = false;
                      notifyListeners();
                      sendNotification(
                          title: 'ويفو وفرلك كابتن',
                          body:
                              'الكابتن $name قبل طلب الشحن وتم خصم مقدمالشحنة',
                          toToken: ShipmentNotification.fromMap(
                                  json.decode(m.data['data']))
                              .merchantFcmToken,
                          image: photo != null
                              ? photo!.contains(ApiConstants.baseUrl)
                                  ? photo
                                  : '${ApiConstants.baseUrl}$photo'
                              : '',
                          type: '',
                          screenTo: 'shipment_offers',
                          data: ShipmentNotification.fromMap(
                                  json.decode(m.data['data']))
                              .toMap());
                    },
                    onRefuseShipment: () {
                      _notificationsNo--;
                      _dialogOpen = false;
                      MagicRouter.pop();
                      notifyListeners();
                    },
                    isWasully: m.data['type'] == 'wasully',
                  );
                });
          }
        } else if (m.data['type'] == 'rating') {
          MagicRouter.navigateAndPopAll(RatingDialog(
              model: ShipmentTrackingModel.fromJson(json.decode(
            m.data['data'],
          ))));
        } else {
          configLocalNotification((NotificationResponse? payload) {
            switch (m.data['screen_to']) {
              case homeScreen:
                Navigator.pushNamed(context, Home.id);
                break;
              case wallet:
                Navigator.pushNamed(context, Wallet.id);
                break;
              case shipmentScreen:
                if (m.data['data']['has_children']) {
                  Navigator.pushNamed(context, ShipmentDetailsDisplay.id,
                      arguments: m.data['data']['shipment_id']);
                } else {
                  Navigator.pushNamed(context, ChildShipmentDetails.id,
                      arguments: m.data['data']['shipment_id']);
                }
                break;
              case shipmentDetailsScreen:
                if (AcceptMerchantOffer.fromMap(json.decode(m.data['data']))
                        .childrenShipment ==
                    0) {
                  Navigator.pushNamed(context, ShipmentDetailsDisplay.id,
                      arguments: AcceptMerchantOffer.fromMap(
                              json.decode(m.data['data']))
                          .shipmentId);
                } else {
                  Navigator.pushNamed(context, ChildShipmentDetails.id,
                      arguments: AcceptMerchantOffer.fromMap(
                              json.decode(m.data['data']))
                          .shipmentId);
                }
                break;
              case handleShipmentScreen:
                Navigator.pushNamed(context, HandleShipment.id,
                    arguments: ShipmentTrackingModel.fromJson(
                        json.decode(m.data['data'])));
                break;
              case walletScreen:
                Navigator.pushNamed(context, Wallet.id);
                break;
              case chatScreen:
                ChatData chatData =
                    ChatData.fromJson(json.decode(m.data['data']));
                ChatData chatData0;
                if (chatData.currentUserNationalId == getNationalId) {
                  chatData0 = ChatData(
                    currentUserNationalId: chatData.currentUserNationalId,
                    peerNationalId: chatData.peerNationalId,
                    currentUserId: chatData.currentUserId,
                    peerId: chatData.peerId,
                    peerImageUrl: chatData.peerImageUrl,
                    peerUserName: chatData.peerUserName,
                    shipmentId: chatData.shipmentId,
                    currentUserName: chatData.currentUserName,
                    currentUserImageUrl: chatData.currentUserImageUrl,
                    conversionId: chatData.conversionId,
                    type: chatData.type,
                  );
                } else {
                  chatData0 = ChatData(
                    peerNationalId: chatData.currentUserNationalId,
                    currentUserNationalId: chatData.peerNationalId,
                    currentUserId: chatData.peerId,
                    peerId: chatData.currentUserId,
                    peerImageUrl: chatData.currentUserImageUrl,
                    peerUserName: chatData.currentUserName,
                    currentUserName: chatData.peerUserName,
                    shipmentId: chatData.shipmentId,
                    currentUserImageUrl: chatData.peerImageUrl,
                    conversionId: chatData.conversionId,
                    type: chatData.type,
                  );
                }
                Navigator.pushNamed(context, ChatScreen.id,
                    arguments: chatData0);
                break;
              case noScreen:
                showDialog(
                    context: context,
                    builder: (c) => ActionDialog(
                          content:
                              'تم الغاء الشحنة من قبل التاجر\nيمكنك التقديم علي شحنات اخري\nمن صفحة الشحنات المتاحة',
                          approveAction: 'حسناً',
                          onApproveClick: () {
                            Navigator.pop(c);
                          },
                        ));
                break;
              default:
                isValid
                    ? Navigator.pushReplacementNamed(
                        context,
                        Home.id,
                      )
                    : Navigator.pushReplacementNamed(
                        context,
                        OnBoarding.id,
                      );
            }
          });
          if (_currentWidget != 'ChatScreen' && _currentWidget != 'Messages') {
            showNotification(m);
          }
        }
      }
      notifyListeners();
    });
  }

  void initialOpenedAppFCM(BuildContext context) {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage m) async {
      final notification = m.notification;
      if (notification != null) {
        if (m.data['has_offer'] == '1' && m.data['better_offer'] == '0') {
          log('shipment notification data from offer ->> ${m.data}');
          _notificationsNo++;
          if (!_dialogOpen) {
            _dialogOpen = true;
            showDialog(
                context: navigator.currentContext!,
                barrierDismissible: false,
                builder: (context) {
                  return ShipmentDialog(
                    shipmentNotification: ShipmentNotification.fromMap(
                      jsonDecode(m.data['data']),
                    ),
                    betterOffer: false,
                    onDetailsCallback: () {
                      _dialogOpen = false;
                      _notificationsNo--;
                      notifyListeners();
                    },
                    onAvailableOkPressed: () {
                      _notificationsNo--;
                      _dialogOpen = false;
                      notifyListeners();
                      sendNotification(
                          title: 'ويفو وفرلك كابتن',
                          body:
                              'الكابتن $name قبل طلب الشحن وتم خصم مقدمالشحنة',
                          toToken: ShipmentNotification.fromMap(
                                  json.decode(m.data['data']))
                              .merchantFcmToken,
                          image: photo != null
                              ? photo!.contains(ApiConstants.baseUrl)
                                  ? photo
                                  : '${ApiConstants.baseUrl}$photo'
                              : '',
                          type: '',
                          screenTo: 'shipment_offers',
                          data: ShipmentNotification.fromMap(
                                  json.decode(m.data['data']))
                              .toMap());
                    },
                    onOfferOkPressed: () {
                      _notificationsNo--;
                      _dialogOpen = false;
                      notifyListeners();
                      sendNotification(
                          title: 'عرض جديد',
                          body: 'الكابتن $name قدم عرض لشحن أوردرك',
                          toToken: token,
                          image: photo != null && photo!.isNotEmpty
                              ? photo!.contains(ApiConstants.baseUrl)
                                  ? photo
                                  : '${ApiConstants.baseUrl}$photo'
                              : '',
                          type: '',
                          screenTo: 'shipment_offers',
                          data: ShipmentNotification.fromMap(
                                  json.decode(m.data['data']))
                              .toMap());
                    },
                    onRefuseShipment: () {
                      _notificationsNo--;
                      _dialogOpen = false;
                      Navigator.pop(context);
                      notifyListeners();
                    },
                  );
                });
          }
        } else if (m.data['has_offer'] == '1' &&
            m.data['better_offer'] == '1') {
          log('shipment notification data from better offer ->> ${m.data}');
          _notificationsNo++;
          if (!_dialogOpen) {
            _dialogOpen = true;
            showDialog(
                context: navigator.currentContext!,
                barrierDismissible: false,
                builder: (context) {
                  return ShipmentDialog(
                    shipmentNotification: ShipmentNotification.fromMap(
                        json.decode(m.data['data'])),
                    betterOffer: true,
                    onDetailsCallback: () {
                      _dialogOpen = false;
                      _notificationsNo--;
                      notifyListeners();
                    },
                    onAvailableOkPressed: () {
                      _notificationsNo--;
                      _dialogOpen = false;
                      notifyListeners();
                      sendNotification(
                          title: 'ويفو وفرلك كابتن',
                          body:
                              'الكابتن $name قبل طلب الشحن وتم خصم مقدمالشحنة',
                          toToken: ShipmentNotification.fromMap(
                                  json.decode(m.data['data']))
                              .merchantFcmToken,
                          image: photo != null
                              ? photo!.contains(ApiConstants.baseUrl)
                                  ? photo
                                  : '${ApiConstants.baseUrl}$photo'
                              : '',
                          type: '',
                          screenTo: 'shipment_offers',
                          data: ShipmentNotification.fromMap(
                                  json.decode(m.data['data']))
                              .toMap());
                    },
                    onOfferOkPressed: () {
                      _notificationsNo--;
                      _dialogOpen = false;
                      notifyListeners();
                      sendNotification(
                          title: 'عرض أفضل',
                          body: 'تم تقديم عرض أفضل من الكابتن $name',
                          toToken: ShipmentNotification.fromMap(
                                  json.decode(m.data['data']))
                              .merchantFcmToken,
                          image: photo != null
                              ? photo!.contains(ApiConstants.baseUrl)
                                  ? photo
                                  : '${ApiConstants.baseUrl}$photo'
                              : '',
                          type: '',
                          screenTo: 'shipment_offers',
                          data: ShipmentNotification.fromMap(
                                  json.decode(m.data['data']))
                              .toMap());
                    },
                    onRefuseShipment: () {
                      _notificationsNo--;
                      _dialogOpen = false;
                      Navigator.pop(context);
                      notifyListeners();
                    },
                  );
                });
          }
        } else if (m.data['type'] == 'rating') {
          MagicRouter.navigateAndPopAll(RatingDialog(
              model: ShipmentTrackingModel.fromJson(json.decode(
            m.data['data'],
          ))));
        } else if (m.data['type'] == 'wasully_rating') {
          MagicRouter.navigateAndPopAll(WasullyRatingDialog(
              model: ShipmentTrackingModel.fromJson(json.decode(
            m.data['data'],
          ))));
        } else {
          configLocalNotification((NotificationResponse? payload) {
            switch (m.data['screen_to']) {
              case homeScreen:
                Navigator.pushNamed(context, Home.id);
                break;
              case wallet:
                Navigator.pushNamed(context, Wallet.id);
                break;
              case shipmentScreen:
                if (m.data['data']['has_children']) {
                  Navigator.pushNamed(context, ShipmentDetailsDisplay.id,
                      arguments: m.data['data']['shipment_id']);
                } else {
                  Navigator.pushNamed(context, ChildShipmentDetails.id,
                      arguments: m.data['data']['shipment_id']);
                }
                break;
              case shipmentDetailsScreen:
                if (AcceptMerchantOffer.fromMap(json.decode(m.data['data']))
                        .childrenShipment ==
                    0) {
                  Navigator.pushNamed(context, ShipmentDetailsDisplay.id,
                      arguments: AcceptMerchantOffer.fromMap(
                              json.decode(m.data['data']))
                          .shipmentId);
                } else {
                  Navigator.pushNamed(context, ChildShipmentDetails.id,
                      arguments: AcceptMerchantOffer.fromMap(
                              json.decode(m.data['data']))
                          .shipmentId);
                }
                break;
              case noScreen:
                showDialog(
                    context: context,
                    builder: (c) => ActionDialog(
                          content:
                              'تم الغاء الشحنة من قبل التاجر\nيمكنك التقديم علي شحنات اخري\nمن صفحة الشحنات المتاحة',
                          approveAction: 'حسناً',
                          onApproveClick: () {
                            Navigator.pop(c);
                          },
                        ));
                break;
              case handleShipmentScreen:
                Navigator.pushNamed(context, HandleShipment.id,
                    arguments: ShipmentTrackingModel.fromJson(
                        json.decode(m.data['data'])));
                break;
              case walletScreen:
                Navigator.pushNamed(context, Wallet.id);
                break;
              case chatScreen:
                ChatData chatData =
                    ChatData.fromJson(json.decode(m.data['data']));
                ChatData chatData0;
                if (chatData.currentUserNationalId == getNationalId) {
                  chatData0 = ChatData(
                    currentUserNationalId: chatData.currentUserNationalId,
                    peerNationalId: chatData.peerNationalId,
                    currentUserId: chatData.currentUserId,
                    peerId: chatData.peerId,
                    peerImageUrl: chatData.peerImageUrl,
                    peerUserName: chatData.peerUserName,
                    shipmentId: chatData.shipmentId,
                    currentUserName: chatData.currentUserName,
                    currentUserImageUrl: chatData.currentUserImageUrl,
                    conversionId: chatData.conversionId,
                    type: chatData.type,
                  );
                } else {
                  chatData0 = ChatData(
                    currentUserNationalId: chatData.peerNationalId,
                    peerNationalId: chatData.currentUserNationalId,
                    currentUserId: chatData.peerId,
                    peerId: chatData.currentUserId,
                    peerImageUrl: chatData.currentUserImageUrl,
                    peerUserName: chatData.currentUserName,
                    currentUserName: chatData.peerUserName,
                    shipmentId: chatData.shipmentId,
                    currentUserImageUrl: chatData.peerImageUrl,
                    conversionId: chatData.conversionId,
                    type: chatData.type,
                  );
                }
                Navigator.pushNamed(context, ChatScreen.id,
                    arguments: chatData0);
                break;
              default:
                isValid
                    ? Navigator.pushReplacementNamed(
                        context,
                        Home.id,
                      )
                    : Navigator.pushReplacementNamed(
                        context,
                        OnBoarding.id,
                      );
            }
          });
          if (_currentWidget != 'ChatScreen' && _currentWidget != 'Messages') {
            showNotification(m);
          }
        }
      }
      notifyListeners();
    });
  }

  Future<void> sendMessage(String? content, int type, ChatData chatData,
      String? conversionId) async {
    final DocumentReference convoDoc =
        FirebaseFirestore.instance.collection('messages').doc(conversionId);
    QuerySnapshot map = await convoDoc.collection(conversionId ?? '').get();
    await convoDoc.set(<String?, dynamic>{
      'lastMessage': <String?, dynamic>{
        'currentUserId': chatData.currentUserId,
        'currentUserImage': chatData.currentUserImageUrl,
        'currentUsername': chatData.currentUserName,
        'currentNationalId': chatData.currentUserNationalId,
        'peerNationalId': chatData.peerNationalId,
        'peerId': chatData.peerId,
        'peerUsername': chatData.peerUserName,
        'dateTime': DateTime.now().toIso8601String(),
        'peerImageUrl': chatData.peerImageUrl,
        'shipmentId': chatData.shipmentId,
        'content': content,
        'type': type,
        'read': false,
        'count': map.docs
                .map((e) => e['read'])
                .where((i) => i == false)
                .toList()
                .length +
            1
      },
      'users': <String?>[
        chatData.currentUserNationalId,
        chatData.peerNationalId
      ]
    }).then((dynamic success) async {
      await FirebaseFirestore.instance
          .collection('messages')
          .doc(conversionId)
          .collection(conversionId ?? '')
          .add({
        'currentUserId': chatData.currentUserId,
        'currentUserImage': chatData.currentUserImageUrl,
        'currentUsername': chatData.currentUserName,
        'peerUsername': chatData.peerUserName,
        'peerImageUrl': chatData.peerImageUrl,
        'peerNationalId': chatData.peerNationalId,
        'currentNationalId': chatData.currentUserNationalId,
        'peerId': chatData.peerId,
        'dateTime': DateTime.now().toIso8601String(),
        'content': content,
        'read': false,
        'type': type,
      });
      DocumentSnapshot userToken = await FirebaseFirestore.instance
          .collection('merchant_users')
          .doc(chatData.peerId)
          .get();
      String? token = userToken['fcmToken'];
      switch (type) {
        case 0:
          sendNotification(
              title: chatData.currentUserName,
              body: content,
              image: (chatData.currentUserImageUrl != null &&
                      chatData.currentUserImageUrl!.isNotEmpty)
                  ? chatData.currentUserImageUrl!.contains(ApiConstants.baseUrl)
                      ? chatData.currentUserImageUrl
                      : '${ApiConstants.baseUrl}${chatData.currentUserImageUrl}'
                  : '',
              toToken: token,
              type: 'chat',
              screenTo: 'chat_screen',
              data: ChatData(
                currentUserNationalId: chatData.currentUserNationalId,
                peerNationalId: chatData.peerNationalId,
                currentUserId: chatData.currentUserId,
                currentUserName: chatData.currentUserName,
                currentUserImageUrl: chatData.currentUserImageUrl,
                peerId: chatData.peerId,
                shipmentId: chatData.shipmentId,
                peerUserName: chatData.peerUserName,
                peerImageUrl: chatData.peerImageUrl,
                conversionId: conversionId,
                type: type,
              ).toJson());
          break;
        case 1:
          sendNotification(
              title: chatData.currentUserName,
              body: 'photo',
              image: (chatData.currentUserImageUrl != null &&
                      chatData.currentUserImageUrl!.isNotEmpty)
                  ? chatData.currentUserImageUrl!.contains(ApiConstants.baseUrl)
                      ? chatData.currentUserImageUrl
                      : '${ApiConstants.baseUrl}${chatData.currentUserImageUrl}'
                  : '',
              toToken: token,
              type: 'chat',
              screenTo: 'chat_screen',
              data: ChatData(
                currentUserNationalId: chatData.currentUserNationalId,
                peerNationalId: chatData.peerNationalId,
                currentUserId: chatData.currentUserId,
                currentUserName: chatData.currentUserName,
                currentUserImageUrl: chatData.currentUserImageUrl,
                peerId: chatData.peerId,
                shipmentId: chatData.shipmentId,
                peerUserName: chatData.peerUserName,
                peerImageUrl: chatData.peerImageUrl,
                conversionId: conversionId,
                type: type,
              ).toJson());
          break;

        case 2:
          break;
      }
    });
  }

  void configLocalNotification(
      Function(NotificationResponse) onSelectedNotificationCallback) async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('app_icon');
    DarwinInitializationSettings initializationSettingsIOS =
        const DarwinInitializationSettings();
    InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'org.weevo.courier',
      'weevo courier',
      importance: Importance.max,
    );
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onSelectedNotificationCallback);
  }

  // Future<String?> _downloadAndSaveFile(String? url, String? fileName) async {
  //   if (url != null && url.isNotEmpty) {
  //     final Directory directory = await getApplicationDocumentsDirectory();
  //     final String filePath = '${directory.path}/$fileName';
  //     final http.Response response =
  //         await HttpHelper.instance.httpGet(url, false, hasBase: false);
  //     final File file = File(filePath);
  //     await file.writeAsBytes(response.bodyBytes);
  //     return filePath;
  //   } else {
  //     return null;
  //   }
  // }

  void showNotification(RemoteMessage remoteMessage) async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('app_icon');
    DarwinInitializationSettings initializationSettingsIOS =
        const DarwinInitializationSettings();
    InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'org.emarketingo.courier',
      'Weevo Captian',
      importance: Importance.max,
    );
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        const AndroidNotificationDetails(
      'org.emarketingo.courier',
      'Weevo Captian',
      playSound: true,
      enableVibration: true,
      importance: Importance.max,
      priority: Priority.max,
    );
    DarwinNotificationDetails iOSPlatformChannelSpecifics =
        const DarwinNotificationDetails();
    NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    FlutterRingtonePlayer().play(
        android: AndroidSounds.notification, ios: IosSounds.receivedMessage);
    await flutterLocalNotificationsPlugin.show(
        DateTime.now().millisecond,
        remoteMessage.notification?.title,
        remoteMessage.notification?.body,
        platformChannelSpecifics,
        payload: null);
  }

  Future<void> getServerKey() async {
    final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
    try {
      final client = await clientViaServiceAccount(
          ServiceAccountCredentials.fromJson({
            "type": "service_account",
            "project_id": "weevo-bfa67",
            "private_key_id": "a869e38765348eced08b59f61f98b0cd812b6cba",
            "private_key":
                "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQC5smjWiNMFjhQ6\nHGPZGc1/WoiaNYBEEtJNYNxW26kxRsAzP2wbECChUd+s77mFgiL2PDqcx1yb8VRe\nXlx2BPZUcCOdPaEcAIJ3/+MVD40MGWzmxNaQztG45/1BELhQqYT9w1tVjXdqTZ2f\nkXe/XfOeqGKzm0shHYkeWaUZDcRLGr6vkPJTFuBU/2mvpfOWaQhl4yMz/XULpwtk\nM0htBh0d6syi5mkd/GlRys9aum2BZu1vX9nXDVnZ7mZ/bjYs0sI9SJSiEtU2s94u\nWReTjFpGt5xms26I0KBfQUjr5pIkSTb48AzupXBFCuyryPnlWYzGG01EqE9CXQHm\n8JXrJCgzAgMBAAECggEAVZctCU0xbosJOauiPgvNkxiog+OLBlVih3XQuVwvxN2m\ncziVXHf3gkOZhD1OVoIgGTyzi1W8ksgOKhz2IxOwckTptW0VmDGH8UWJZkivq1cA\nwfESMNaTBdYv/dB2E/++o7Rqoak91EqID2deOV9Vjdhw/fXjEBVsAQgyt7SHuFGH\nG81j2Edz8w9Ovsxnl05E3HtKUGAz/or24Fii6SRD+Q2m8oWGEc8YjmqvQ3P6rrC5\nY/iY/43mCo1MG6JWWJs3Yom5JkSlqShq2Ms2J+Ol6bSNB3NHSF5m26+lsuKTkPAU\nsmk0oAyGCvVkiXhnPhifEx3eX8cPp593PO8VxjFM+QKBgQDnrDYrVIQXuQBmuS2d\nPJxGayUVkyfLyUGsTRhH5lsVWmgBVdEhRUVhr55WVco4Zyo5cJlUY3EFUFlBvswY\n32rHTAXrLIZIiCoGYuiS3L0SxdEC/W9p9iRDOL+t1NHEXZTraYD3RytZgLFFm2W5\npgAGtFG7+ixcZXuim6UNdzAY3QKBgQDNMki8wnVsvvyUuI9aCjAu7zCcDz2cUgYi\nzChw5WPbhbLQC6lmMTMU6MRppQ09u5HMZ8dv1LmUk/7Nb8VYOFU5t7/FOzoOTm7T\nN2rMXj/EjAqRnUPKkvJ5dKg49I1n2mt3IBeSqidZHvwwC1ZSHeALLYSAdFRO4IPa\ndtyOp3isTwKBgDIdlcY/zSdYlNaj3lMyRlgRW39USvqRecxtDQCYu0FeQjtvtgKt\nennMRMNGYa1b2817JyATNuLAY96OCJak1fNw5aLfCdls4zJoeQk0CQ6jjjhIXK6e\nWW/VOdm/vPTujYVzWDulwKHm7fIx0Iqdd0n7/eZdEvWV2m3tn4HPM69dAoGAUQ/G\nUFt5zAX+/jmS1/0iX8g6KcyTiEeXCPQiHcdhFX3R0AJrX2WcSmxR+3IqsvKAfIGa\n9gDRd3KnvDyld155vJ1sctwc6T3u5h4EYMvy4RB5tGCuQT6f7384XZeurRJKVfsl\nlNkHRlvJQKmZ5kLLGV9X8u8Bx09Gh21hYDGkqF0CgYBg/arcsY2Ixv9AffdvuO4q\nN1eE0iw9ZCh7NwSd7YbLygrUNrjcSWIvEl7c8erC9X6s/JUqIqsxOg7Q3YIgDQeq\n1utOq1dOPUGIJKpEzqU6lSWa2jauOAOF+ryeyCKUCUcEO8brrjqu74Bgdv3/1jgL\nCTvOEaua5uw5+AGHdpRpRQ==\n-----END PRIVATE KEY-----\n",
            "client_email":
                "firebase-adminsdk-r4y79@weevo-bfa67.iam.gserviceaccount.com",
            "client_id": "107215847941644970026",
            "auth_uri": "https://accounts.google.com/o/oauth2/auth",
            "token_uri": "https://oauth2.googleapis.com/token",
            "auth_provider_x509_cert_url":
                "https://www.googleapis.com/oauth2/v1/certs",
            "client_x509_cert_url":
                "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-r4y79%40weevo-bfa67.iam.gserviceaccount.com",
            "universe_domain": "googleapis.com"
          }),
          scopes);
      final serverKey = client.credentials.accessToken.data;
      Preferences.instance.setFcmAccessToken(serverKey);
      log('firebase project accessToken -> $serverKey');
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> sendNotification(
      {required Map<String?, dynamic> data,
      required String? toToken,
      required String? screenTo,
      required String? title,
      required String? body,
      required String? image,
      required String? type}) async {
    const String firebaseProjectName = 'weevo-bfa67';
    log('SEND');
    http.Response r = await post(
      Uri.parse(
          'https://fcm.googleapis.com/v1/projects/$firebaseProjectName/messages:send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${Preferences.instance.getFCMAccessToken}',
      },
      body: jsonEncode(
        {
          "message": {
            "token": toToken,
            "notification": {
              "title": title,
              "body": body,
              "image": image,
            },
            'data': {
              "data": data.toString(),
              "type": type,
              "screen_to": screenTo
            },
            "android": {
              "notification": {
                "click_action": "FLUTTER_NOTIFICATION_CLICK",
                "sound": "default"
              },
              "priority": "high"
            }
          }
        },
      ),
    );
    log('body -> ${r.body}');
    log('url -> ${r.request?.url}');
    log('status code -> ${r.statusCode}');
  }

  NetworkState? get networkState => _networkState;

  Future<void> sendShipmentOffer({int? offer, int? shipmentId}) async {
    log('offer -> $offer');
    try {
      _networkState = NetworkState.waiting;
      notifyListeners();
      http.Response r = await HttpHelper.instance.httpPost(
        'shipping-offers/send-offer',
        true,
        body: {
          'offer': offer,
          'shipment_id': shipmentId,
        },
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        _networkState = NetworkState.success;
        Map<String?, dynamic> map = json.decode(r.body);
        if (map.containsKey('alreadyExist')) {
          _offerId = map['entity']['id'];
          _updateOffer = true;
        } else {
          _updateOffer = false;
        }
        _message = map['message'];
      } else {
        if (json.decode(r.body)['message'] ==
            'Your current balance does not allow for this action!') {
          _noCredit = true;
        } else if (json.decode(r.body)['message'] ==
            'You do not have sufficient balance to send this number of shipping offers.') {
          _noCredit = true;
        } else {
          _noCredit = false;
        }
        _networkState = NetworkState.error;
      }
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }

  bool get betterOfferIsBiggerThanLastOne => _betterOfferIsBiggerThanLastOne;

  Future<void> updateShipmentOffer({int? offer, int? offerId}) async {
    try {
      _betterOfferIsBiggerThanLastOne = false;
      _networkState = NetworkState.waiting;
      notifyListeners();
      http.Response r = await HttpHelper.instance.httpPut(
        'shipping-offers/$offerId/update',
        true,
        body: {
          'offer': offer,
        },
      );
      if (r.statusCode >= 200 && r.statusCode < 300) {
        _networkState = NetworkState.success;
      } else {
        if (json.decode(r.body)['message'] ==
            'You cannot send a better offer with a value greater than the previous offer!') {
          _betterOfferIsBiggerThanLastOne = true;
          _betterOfferMessage =
              'لا يمكنك أرسال عرض أفضل بقيمة اكبر من العرض السابق!';
        }
        _networkState = NetworkState.error;
      }
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
  }

  NetworkState? get articleState => _articleState;

  NetworkState? get groupBannersState => _groupBannersState;

  List<HomeBanner>? get homeBanner => _homeBanner;

  Widget? get resetPasswordWidget => _resetPasswordWidget;

  NetworkState? get resetPasswordState => _resetPasswordState;

  String? get userFirebaseToken => _userFirebaseToken;

  String? get userFirebaseId => _userFirebaseId;

  String? get betterOfferMessage => _betterOfferMessage;

  String? get createNewUserMessage => _createNewUserMessage;

  bool get canGoInside => _canGoInside;
}
