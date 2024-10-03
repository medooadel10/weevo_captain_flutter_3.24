import 'dart:developer';
import 'dart:io';

import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshchat_sdk/freshchat_sdk.dart';
import 'package:provider/provider.dart';

import 'Storage/shared_preference.dart';
import 'Utilits/app_routes.dart';
import 'Utilits/firebase_notification.dart';
import 'core/di/dependency_injection.dart';
import 'core/networking/dio_factory.dart';
import 'core/style/app_theme.dart';
import 'features/wasully_details/logic/cubit/wasully_details_cubit.dart';
import 'features/wasully_handle_shipment/logic/cubit/wasully_handle_shipment_cubit.dart';
import 'firebase_options.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (await Freshchat.isFreshchatNotification(message.data)) {
    log("Handling a freshchat message: ${message.data}");
    Freshchat.handlePushNotification(message.data);
  }
  if (message.notification != null) {
    log("Handling a background message: ${message.notification?.title}");
    log("Handling a background message: ${message.notification?.body}");
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  Freshchat.init(
    '2540a172-9d87-4e8d-a28d-05b2fcef08fb',
    '90f02877-838c-42d2-876a-ef1b94346565',
    'msdk.freshchat.com',
    teamMemberInfoVisible: true,
    cameraCaptureEnabled: true,
    gallerySelectionEnabled: true,
    responseExpectationEnabled: true,
    fileSelectionEnabled: true,
  );
  log('The abns token device is ${await FirebaseMessaging.instance.getAPNSToken()}');
  log('The token device is ${await FirebaseMessaging.instance.getToken()}');

  Freshchat.setPushRegistrationToken(Platform.isIOS
      ? await FirebaseMessaging.instance.getToken() ?? ''
      : await FirebaseMessaging.instance.getToken() ?? '');
  FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);
  if (Platform.isIOS) {
    FirebaseNotification.iOSPermission();
  }
  FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  FirebaseMessaging.instance.setAutoInitEnabled(true);
  FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);
  if (Platform.isIOS) {
    FirebaseNotification.iOSPermission();
  }
  await Preferences.instance.initPref();
  setupGetIt();
  DioFactory.init();
  runApp(const WeevoCaptain());
}

class WeevoCaptain extends StatelessWidget {
  static final facebookAppEvents = FacebookAppEvents();

  const WeevoCaptain({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return ScreenUtilInit(
      designSize: const Size(360, 702),
      builder: (context, child) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => WasullyDetailsCubit(getIt()),
          ),
          BlocProvider(
            create: (context) => WasullyHandleShipmentCubit(getIt()),
          ),
        ],
        child: MultiProvider(
          providers: providers,
          child: MaterialApp(
            builder: EasyLoading.init(),
            navigatorKey: navigator,
            theme: AppTheme.lightTheme(context),
            title: 'Weevo captain | ويفو كابتن',
            debugShowCheckedModeBanner: false,
            initialRoute: initRoute,
            routes: routes,
            onGenerateRoute: generatedRoutes,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('ar')],
            locale: const Locale('ar'),
          ),
        ),
      ),
    );
  }
}
