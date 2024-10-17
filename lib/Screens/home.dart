// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freshchat_sdk/freshchat_sdk.dart';
import 'package:provider/provider.dart';

import '../Dialogs/action_dialog.dart';
import '../Dialogs/active_dialog.dart';
import '../Models/home_navigation_data.dart';
import '../Providers/auth_provider.dart';
import '../Providers/freshchat_provider.dart';
import '../Providers/shipment_provider.dart';
import '../Storage/shared_preference.dart';
import '../Utilits/colors.dart';
import '../Utilits/constants.dart';
import '../Widgets/custom_home_navigation.dart';
import '../core/router/router.dart';
import '../features/available_shipments/ui/screens/available_shipments_screen.dart';
import '../features/shipment_details/ui/shipment_details_screen.dart';
import 'fragment/main_screen.dart';
import 'fragment/more_screen.dart';
import 'fragment/notification_screen.dart';
import 'messages.dart';

class Home extends StatefulWidget {
  static String id = 'CategoryOne';

  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isAvailable = Preferences.instance.getIsOnline == 1;
  int _currentIndex = 0;
  late AuthProvider _authProvider;
  late FreshChatProvider freshChatInit;
  bool _isLoading = false;
  StreamSubscription<QuerySnapshot>? _chatSubscription;
  StreamSubscription<QuerySnapshot>? _notificationSubscription;
  int _totalMessages = 0;
  int _totalNotifications = 0;
  Timer? _t, locationTimer;

  @override
  void initState() {
    super.initState();
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    freshChatInit = FreshChatProvider.listenFalse(context);
    _authProvider.getServerKey();
    _authProvider.initialFCM(context);
    _authProvider.initialOpenedAppFCM(context);
    _authProvider.getUserLocation();
    getData();
    log('My token ${Preferences.instance.getAccessToken}');
    log('My Name ${_authProvider.name}');
  }

  void initChatBadge() async {
    try {
      _chatSubscription = FirebaseFirestore.instance
          .collection('messages')
          .snapshots()
          .listen((v) {
        _totalMessages = 0;
        _totalMessages = v.docs
            .where((element) =>
                element.data()['lastMessage']['peerId'] == _authProvider.id &&
                element.data()['lastMessage']['read'] == false)
            .toList()
            .length;
        setState(() {
          _authProvider.increaseChatCounter(_totalMessages);
        });
      });
    } catch (e) {
      log(e.toString());
    }

    await Future.delayed(
      const Duration(seconds: 5),
    );
  }

  void _initDynamicLinks() async {
    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri deepLink = data?.link ?? Uri.parse('');
    log('dd$deepLink');
    log(' ---------- ${deepLink.path}');
    String state = deepLink.path.substring(1);
    log('state >>>>> $state');

    log('state >>>>>>>>>>>>>>>>> "merchantId" $state');
    MagicRouter.navigateTo(
      ShipmentDetailsScreen(id: int.parse(state)),
    );
    // }

    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) {
      final Uri deepLink = dynamicLinkData.link;
      log('Deep Link Path: ${deepLink.path}');
      String state = deepLink.path.substring(1);
      log('Extracted State: $state');
      MagicRouter.navigateTo(
        ShipmentDetailsScreen(id: int.parse(state)),
      );
    }, onError: (error) {
      log('Link Error: $error');
    });
  }

  void initNotificationBadge() async {
    try {
      _notificationSubscription = FirebaseFirestore.instance
          .collection('courier_notifications')
          .doc(_authProvider.id)
          .collection(_authProvider.id!)
          .snapshots()
          .listen((v) {
        _totalNotifications = 0;
        _totalNotifications = v.docs
            .where((element) => element.data()['read'] == false)
            .toList()
            .length;
        setState(() {
          _authProvider.increaseNotificationCounter(_totalNotifications);
        });
      });
    } catch (e) {
      log(e.toString());
    }
  }

  void subscribeTopics() {
    var data = FirebaseFirestore.instance
        .collection('courierFcmTopics')
        .doc(_authProvider.id);
    _t = Timer.periodic(const Duration(minutes: 1), (timer) async {
      var userFcm = await data.get();
      if (userFcm.exists) {
        List unsubscribeList = userFcm['topics_to_unsubscribe'];
        List subscribeList = userFcm['topics_to_subscribe'];
        if (unsubscribeList.isNotEmpty) {
          await _authProvider.unSubscribeAreas(unsubscribeList);
          await data.update({'topics_to_unsubscribe': []});
          await data.update({'topics_to_unsubscribe_done': true});
        }
        if (subscribeList.isNotEmpty) {
          await _authProvider.subscribeAreas(subscribeList);
          await data.update({'topics_to_subscribe': []});
          await data.update({'topics_to_subscribe_done': true});
        }
        await data
            .update({'last_update_from_user_device': DateTime.now().toLocal()});
      }
    });
  }

  void getData() async {
    if (await _authProvider.checkConnection()) {
      await _authProvider.getCurrentUserdata(false);
      freshChatInit.initFreshChat();
      await _authProvider.getFirebaseToken();
      if (_authProvider.userDataByToken!.active == 1) {
        if (_authProvider.userDataByToken!.banned == 0) {
          await _authProvider.getArticle();
          check(
              ctx: navigator.currentContext!,
              auth: _authProvider,
              state: _authProvider.articleState!);
          _authProvider.getGroupsWithBanners();
          await _authProvider.getAllCategories();
          await _authProvider.getCourierCommission();
          _authProvider.getCountries();
          FirebaseFirestore.instance
              .collection('courier_users')
              .doc(_authProvider.id)
              .set({
            'id': _authProvider.id,
            'email': _authProvider.email,
            'name': _authProvider.name,
            'imageUrl': _authProvider.photo,
            'fcmToken': _authProvider.fcmToken,
            'national_id': _authProvider.phone,
          });
          _authProvider.updateToken(value: _authProvider.fcmToken);
          initChatBadge();
          initNotificationBadge();
          _initDynamicLinks();
          _authProvider.setCurrentCaptainLocation();
          locationTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
            _authProvider.setCurrentCaptainLocation();
          });
        } else {
          showDialog(
            context: navigator.currentContext!,
            builder: (ctx) => ActiveDialog(
              name: _authProvider.name!,
              title:
                  '                               تم حظر حسابك\n      لاعادة التفعيل يرجي التوجه لمقر الشركه او الاتصال بنا',
              content: 'العنوان',
              isInterview: false,
            ),
          );
        }
      } else {
        showDialog(
          context: navigator.currentContext!,
          builder: (ctx) => const ActiveDialog(
            title:
                'شكرا على تسجيلك أنت دلوقتي بقيت كابتن في ويفو\nسوف يتم تفعيل حسابك خلال ٢٤ ساعة',
            isInterview: false,
          ),
        );
      }
    } else {
      showDialog(
        context: navigator.currentContext!,
        builder: (ctx) => ActionDialog(
          content: 'تأكد من الاتصال بشبكة الانترنت',
          cancelAction: 'حسناً',
          approveAction: 'حاول مرة اخري',
          onApproveClick: () async {
            Navigator.pop(context);
            getData();
          },
          onCancelClick: () {
            Navigator.pop(context);
          },
        ),
      );
    }
  }

  @override
  void dispose() {
    _chatSubscription?.cancel();
    _notificationSubscription?.cancel();
    freshChatInit.freshChatOnMessageCountUpdateDispose();
    if (_t?.isActive ?? false) {
      _t?.cancel();
    }
    if (locationTimer?.isActive ?? false) {
      locationTimer?.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ShipmentProvider shipmentProvider =
        Provider.of<ShipmentProvider>(context, listen: false);
    AuthProvider auth = Provider.of<AuthProvider>(context);
    final FreshChatProvider freshChat = FreshChatProvider.get(context);
    return WillPopScope(
      onWillPop: () async {
        switch (_currentIndex) {
          case 3:
            setState(() => _currentIndex = 0);
            break;
          case 2:
            setState(() => _currentIndex = 0);
            break;
          case 1:
            setState(() => _currentIndex = 0);
            break;
          case 0:
            showDialog(
              context: context,
              builder: (context) => ActionDialog(
                title: 'الخروج من التطبيق',
                content: 'هل تود الخروج من التطبيق',
                approveAction: 'نعم',
                cancelAction: 'لا',
                onApproveClick: () {
                  Navigator.pop(context);
                  SystemNavigator.pop();
                },
                onCancelClick: () {
                  Navigator.pop(context);
                },
              ),
            );
        }
        return false;
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          floatingActionButton: Stack(
            children: [
              SizedBox(
                height: 50,
                width: 50,
                child: FloatingActionButton(
                  elevation: 0.0,
                  onPressed: () async {
                    if (auth.notificationsNo > 0) {
                      auth.resetShipmentNotification();
                    }
                    shipmentProvider.setAvailableShipmentIndex(1);
                    shipmentProvider.setFromNewShipment(true);
                    MagicRouter.navigateTo(const AvailableShipmentsScreen());
                  },
                  backgroundColor: weevoPrimaryBlueColor,
                  child: Image.asset(
                    'assets/images/weevo_new_logo.png',
                    height: 35.0,
                    width: 35.0,
                    color: Colors.white,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              auth.notificationsNo > 0
                  ? Container(
                      height: 25.0,
                      width: 25.0,
                      decoration: const BoxDecoration(
                        color: weevoPrimaryBlueColor,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: _authProvider.notificationsNo > 99
                            ? const Text(
                                '99+',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.0,
                                ),
                              )
                            : Text(
                                '${_authProvider.notificationsNo}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.0,
                                ),
                              ),
                      ),
                    )
                  : const SizedBox(
                      height: 25.0,
                      width: 25.0,
                    ),
            ],
          ),
          appBar: AppBar(
            title: _currentIndex == 0
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          _isLoading
                              ? Container(
                                  height: 30.h,
                                  width: 30.w,
                                  padding: const EdgeInsets.all(5.0),
                                  child: const CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        weevoPrimaryOrangeColor),
                                  ),
                                )
                              : Switch(
                                  inactiveTrackColor: Colors.grey,
                                  activeColor: weevoPrimaryOrangeColor,
                                  value: isAvailable,
                                  onChanged: (bool v) async {
                                    if (await auth.checkConnection()) {
                                      if (!_isLoading) {
                                        setState(() => _isLoading = true);
                                        if (v == true) {
                                          await auth.courierOnline();
                                        } else {
                                          await auth.courierOffline();
                                        }
                                        setState(() => _isLoading = false);
                                        setState(() => isAvailable = v);
                                      }
                                    } else {
                                      showDialog(
                                        context: navigator.currentContext!,
                                        builder: (ctx) => ActionDialog(
                                          content:
                                              'تأكد من الاتصال بشبكة الانترنت',
                                          cancelAction: 'حسناً',
                                          approveAction: 'حاول مرة اخري',
                                          onApproveClick: () async {
                                            Navigator.pop(context);
                                            getData();
                                          },
                                          onCancelClick: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      );
                                    }
                                  },
                                ),
                          SizedBox(
                            width: 8.w,
                          ),
                          InkWell(
                            onTap: () async {
                              Freshchat.showConversations();
                            },
                            child: Stack(
                              alignment: Alignment.topRight,
                              children: [
                                SvgPicture.asset(
                                  'assets/images/chat.svg',
                                  width: 30.0.w,
                                  height: 30.0.h,
                                  color: weevoPrimaryOrangeColor,
                                ),
                                if (freshChat.freshChatNewMessageCounter !=
                                        null &&
                                    freshChat.freshChatNewMessageCounter! > 0)
                                  Container(
                                    height: 15.h,
                                    width: 15.w,
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: weevoPrimaryOrangeColor),
                                    child: Center(
                                      child: Text(
                                        '${freshChat.freshChatNewMessageCounter}',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 9.sp),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Text(
                        'الرئيسية',
                        textAlign: TextAlign.center,
                      ),
                      Image.asset(
                        'assets/images/weevo_blue_logo.png',
                        filterQuality: FilterQuality.high,
                        fit: BoxFit.cover,
                        height: 30.0.h,
                      ),
                    ],
                  )
                : Row(
                    children: [
                      if (_currentIndex == 1 || _currentIndex == 2)
                        InkWell(
                          onTap: () {
                            Freshchat.showConversations();
                          },
                          child: Stack(
                            alignment: Alignment.topRight,
                            children: [
                              SvgPicture.asset(
                                'assets/images/chat.svg',
                                width: 30.0.w,
                                height: 30.0.h,
                                color: weevoPrimaryOrangeColor,
                              ),
                              if (freshChat.freshChatNewMessageCounter !=
                                      null &&
                                  freshChat.freshChatNewMessageCounter! > 0)
                                Container(
                                  height: 15.h,
                                  width: 15.w,
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: weevoPrimaryOrangeColor),
                                  child: Center(
                                    child: Text(
                                      '${freshChat.freshChatNewMessageCounter}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 9.sp),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      Expanded(
                        child: Text(
                          _currentIndex == 0
                              ? 'الرئيسية'
                              : _currentIndex == 1
                                  ? 'الإشعارات'
                                  : _currentIndex == 2
                                      ? 'الرسائل'
                                      : 'الحساب',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
          ),
          body: _getCurrentScreen(context),
          backgroundColor: Colors.white,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: SafeArea(
            bottom: Platform.isAndroid,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 10.0.w,
              ),
              height: 75.0.h,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  HomeNavigationData.navigationData.length,
                  (index) => CustomHomeNavigation(
                    svgPicture: index == _currentIndex
                        ? HomeNavigationData.navigationData[index].svgPicture
                        : HomeNavigationData.navigationData[index].svgPicture,
                    label: HomeNavigationData.navigationData[index].label,
                    isSelected: index == _currentIndex,
                    onTap: () {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getCurrentScreen(
    BuildContext ctx,
  ) {
    late Widget w;
    switch (_currentIndex) {
      case 0:
        w = const MainScreen();
        break;
      case 1:
        w = const NotificationScreen();
        break;
      case 2:
        w = const Messages(fromHome: true);
        break;
      case 3:
        w = const MoreScreen();
        break;
    }
    return w;
  }
}
