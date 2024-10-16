import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../Models/chat_data.dart';
import '../Models/connectivity_enum.dart';
import '../Models/feedback_data_arg.dart';
import '../Models/shipment_tracking_model.dart';
import '../Models/transaction_webview_model.dart';
import '../Providers/auth_provider.dart';
import '../Providers/forget_password_provider.dart';
import '../Providers/freshchat_provider.dart';
import '../Providers/profile_provider.dart';
import '../Providers/shipment_provider.dart';
import '../Providers/shipment_tracking_provider.dart';
import '../Providers/wallet_provider.dart';
import '../Screens/after_registration.dart';
import '../Screens/before_registration.dart';
import '../Screens/car_information.dart';
import '../Screens/chat_screen.dart';
import '../Screens/child_shipment_details.dart';
import '../Screens/delivery_areas.dart';
import '../Screens/fragment/change_your_email.dart';
import '../Screens/fragment/change_your_password.dart';
import '../Screens/fragment/change_your_phone_number.dart';
import '../Screens/fragment/profile_information.dart';
import '../Screens/fragment/sign_up_verify_phone_number.dart';
import '../Screens/handle_shipment.dart';
import '../Screens/home.dart';
import '../Screens/image_display_screen.dart';
import '../Screens/login.dart';
import '../Screens/merchant_feedback.dart';
import '../Screens/messages.dart';
import '../Screens/my_reviews.dart';
import '../Screens/onboarding.dart';
import '../Screens/promo_code.dart';
import '../Screens/reset_password.dart';
import '../Screens/shipment_tracking_map.dart';
import '../Screens/sign_up.dart';
import '../Screens/splash.dart';
import '../Screens/transaction_webview.dart';
import '../Screens/video_preview_list.dart';
import '../Screens/wallet.dart';
import '../Screens/weevo_ads.dart';
import '../Screens/weevo_web_view_preview.dart';
import 'connectivity_watcher.dart';

Map<String, WidgetBuilder> routes = {
  Splash.id: (_) => const Splash(),
  DeliveryAreas.id: (_) => const DeliveryAreas(),
  VideoPreviewList.id: (_) => const VideoPreviewList(),
  OnBoarding.id: (_) => const OnBoarding(),
  Login.id: (_) => const Login(),
  ResetPassword.id: (_) => const ResetPassword(),
  BeforeRegistration.id: (_) => const BeforeRegistration(),
  AfterRegistration.id: (_) => const AfterRegistration(),
  SignUp.id: (_) => const SignUp(),
  SignUpPhoneVerification.id: (_) => const SignUpPhoneVerification(),
  Home.id: (_) => const Home(),
  MyReviews.id: (_) => const MyReviews(),
  PromoCode.id: (_) => const PromoCode(),
  // AvailableShipmentContainer.id: (_) => AvailableShipmentContainer(),
  // Shipment.id: (_) => Shipment(),
  CarInformation.id: (_) => const CarInformation(),
  Wallet.id: (_) => const Wallet(),
  ProfileInformation.id: (_) => const ProfileInformation(),
  ChangeYourEmail.id: (_) => const ChangeYourEmail(),
  ChangeYourPassword.id: (_) => const ChangeYourPassword(),
  ChangeYourPhone.id: (_) => const ChangeYourPhone(),
  WeevoAds.id: (_) => const WeevoAds(),
};

String initRoute = Splash.id;

RouteFactory generatedRoutes = (RouteSettings settings) {
  if (settings.name == MerchantFeedback.id) {
    final FeedbackDataArg v = settings.arguments as FeedbackDataArg;
    return MaterialPageRoute(
      builder: (context) => MerchantFeedback(arg: v),
    );
  } else if (settings.name == WeevoWebViewPreview.id) {
    final String v = settings.arguments as String;
    return MaterialPageRoute(
      builder: (context) => WeevoWebViewPreview(url: v),
    );
  } else if (settings.name == TransactionWebView.id) {
    final TransactionWebViewModel v =
        settings.arguments as TransactionWebViewModel;
    return MaterialPageRoute(
      builder: (context) => TransactionWebView(model: v),
    );
  } else if (settings.name == Messages.id) {
    final bool fromHome = settings.arguments as bool;
    return MaterialPageRoute(
      builder: (context) => Messages(fromHome: fromHome),
    );
  } else if (settings.name == ChatScreen.id) {
    final ChatData chatData = settings.arguments as ChatData;
    return MaterialPageRoute(
      builder: (context) => ChatScreen(chatData: chatData),
    );
  } else if (settings.name == HandleShipment.id) {
    final ShipmentTrackingModel v = settings.arguments as ShipmentTrackingModel;
    return MaterialPageRoute(
      builder: (context) => HandleShipment(model: v),
    );
  } else if (settings.name == ShipmentTrackingMap.id) {
    final ShipmentTrackingModel data =
        settings.arguments as ShipmentTrackingModel;
    return MaterialPageRoute(
      builder: (context) => ShipmentTrackingMap(model: data),
    );
  } else if (settings.name == ImageDisplayScreen.id) {
    final String imageUrl = settings.arguments as String;
    return MaterialPageRoute(
      builder: (context) => ImageDisplayScreen(imageUrl: imageUrl),
    );
  } 
   
  else if (settings.name == ChildShipmentDetails.id) {
    final int shipmentId = settings.arguments as int;
    return MaterialPageRoute(
      builder: (context) => ChildShipmentDetails(shipmentId: shipmentId),
    );
  } else {
    return null;
  }
};

List<SingleChildWidget> providers = [
  StreamProvider(
      create: (ctx) => ConnectivityService().connectionStatusController.stream,
      initialData: ConnectivityStatus.offline),
  ChangeNotifierProvider(
    create: (context) => ShipmentProvider(),
  ),
  ChangeNotifierProvider(
    create: (context) => ShipmentTrackingProvider(),
  ),
  ChangeNotifierProvider(
    create: (_) => FreshChatProvider(),
  ),
  ChangeNotifierProvider(
    create: (_) => ForgetPasswordProvider(),
  ),
  ChangeNotifierProvider(
    create: (context) => WalletProvider(),
  ),
  ChangeNotifierProvider(
    create: (context) => ProfileProvider(),
  ),
  ChangeNotifierProvider(
    create: (_) => AuthProvider(),
  ),
];
