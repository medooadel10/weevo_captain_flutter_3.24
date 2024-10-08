import 'dart:developer';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FirebaseNotifications {
  FirebaseMessaging? _firebaseMessaging;

  FlutterLocalNotificationsPlugin? _notificationsPlugin;

  Map<String, dynamic>? _not;

  Future<void> setUpFirebase() async {
    _firebaseMessaging = FirebaseMessaging.instance;
    _firebaseMessaging?.setAutoInitEnabled(true);
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);
    checkLastMessage();
    firebaseCloudMessagingListeners();

    _notificationsPlugin = FlutterLocalNotificationsPlugin();

    _notificationsPlugin
        ?.resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    var android = const AndroidInitializationSettings('@mipmap/launcher_icon');
    var ios = const DarwinInitializationSettings(
        requestSoundPermission: true,
        defaultPresentBadge: true,
        defaultPresentAlert: true,
        defaultPresentSound: true);
    var initSetting = InitializationSettings(android: android, iOS: ios);
    _notificationsPlugin?.initialize(initSetting,
        onDidReceiveNotificationResponse: onSelectNotification);
  }

  Future<void> checkLastMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    log(initialMessage?.data.toString() ?? 'no message');
    handlePath(initialMessage?.data ?? {});
  }

  Future<void> firebaseCloudMessagingListeners() async {
    if (Platform.isIOS) iOSPermission();

    _firebaseMessaging?.getToken().then((token) {
      log("TOOOKEN$token");
      // Get.find<PreferenceManager>().saveFCMToken(token);
      // GetStorage().write(CachingKey.DEVICE_TOKEN, token);
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage data) {
      log('on message ${data.data}');
      log('on message ${data.notification}');
      _not = data.data;
      if (Platform.isAndroid) {
        showNotification(data.data, data.notification?.title ?? '',
            data.notification?.body ?? '');
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage data) {
      log('on Opened ${data.data}');

      handlePath(data.data);
    });

//     _firebaseMessaging.configure(
//       onMessage: (Map<String, dynamic> message) async {
//
//         // _onMessageStreamController.add(message);
//         // FlutterRingtonePlayer.playNotification(
//         //   volume: 50,
//         //   asAlarm: true,
//         // );
//       },
//       onResume: (Map<String, dynamic> message) async {
//         log('on resume $message');
// //        navigatorKey.currentState.pushNamed("screen");
// //        _onMessageStreamController.add(message);
// //        FlutterRingtonePlayer.playNotification(
// //          volume: 50,
// //          asAlarm: true,
// //        );
//       },
//       onLaunch: (Map<String, dynamic> message) async {
//         log('on launch $message');
// //        _onMessageStreamController.add(message);
// //        FlutterRingtonePlayer.playNotification(
// //          volume: 50,
// //          asAlarm: true,
// //        );
//         handlePath(message);
//       },
//     );
  }

  showNotification(
      Map<String, dynamic> message, String title, String body) async {
    log("Notification Response : $message");

    var androidt = const AndroidNotificationDetails(
        '12', 'CHANNEL_POLICE_STEAK',
        priority: Priority.max,
        channelShowBadge: true,
        playSound: true,
        ticker: 'ticker',
        icon: "@mipmap/launcher_icon",
        enableVibration: true,
        enableLights: true,
        importance: Importance.max);
    var iost = const DarwinNotificationDetails();
    var platform = NotificationDetails(android: androidt, iOS: iost);
    await _notificationsPlugin?.show(0, title, body, platform, payload: "");
  }

  void iOSPermission() {
    _firebaseMessaging?.requestPermission(
        alert: true, announcement: true, badge: true, sound: true);
    // _firebaseMessaging.requestNotificationPermissions(
    //     IosNotificationSettings(sound: true, badge: true, alert: true));
    // _firebaseMessaging.onIosSettingsRegistered
    //     .listen((IosNotificationSettings settings) {
    //   log("Settings registered: $settings");
    // });
  }

  void handlePath(Map<String, dynamic> dataMap) {
    handlePathByRoute(dataMap);
  }

  Future<void> handlePathByRoute(Map<String, dynamic> dataMap) async {
    // String type = dataMap["key"].toString();
    // var keyId = dataMap['key_id'].toString();
    // NotificationData notificationData = NotificationData.fromJson(dataMap);

    // Get.toNamed(Routes.HOME);
  }

  Future<void> onSelectNotification(NotificationResponse payload) async {
    log(payload.toString());
    handlePath(_not ?? {});
  }
}
