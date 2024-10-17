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
import 'features/shipment_details/logic/cubit/shipment_details_cubit.dart';
import 'features/wasully_details/logic/cubit/wasully_details_cubit.dart';
import 'features/wasully_handle_shipment/logic/cubit/wasully_handle_shipment_cubit.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message,
    {BuildContext? context}) async {
  log("Entered background handler");
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
      options: Platform.isIOS
          ? FirebaseOptions(
              apiKey: 'AIzaSyANiqEcyoXwDcxnRwiFJT3cgFwGxL8PXvc',
              appId: '1:183711190435:ios:3167f3abe87335b0f2de16',
              messagingSenderId: '183711190435',
              projectId: 'weevo-bfa67',
              storageBucket: 'weevo-bfa67.appspot.com',
              androidClientId:
                  '183711190435-2kodenssv355a57vmgfnce2crh0pdvgb.apps.googleusercontent.com',
              iosBundleId: 'com.weevo.captainApp',
            )
          : FirebaseOptions(
              apiKey: 'AIzaSyBTdtjPztYGOEWJxdnF6NZod1pER67fces',
              appId: '1:183711190435:android:4470d48bc28a607ff2de16',
              messagingSenderId: '183711190435',
              projectId: 'weevo-bfa67',
              storageBucket: 'weevo-bfa67.appspot.com',
            ));
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
    showNotificationBanneriOS: true,
    errorLogsEnabled: true,
  );
  FirebaseMessaging.instance.setAutoInitEnabled(true);
  if (Platform.isIOS) FirebaseNotification.iOSPermission();
  FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  Freshchat.setPushRegistrationToken(
      await FirebaseMessaging.instance.getToken() ?? '');
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
            create: (context) => ShipmentDetailsCubit(getIt()),
          ),
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
            title: 'Weevo Captain | ويفو كابتن',
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
