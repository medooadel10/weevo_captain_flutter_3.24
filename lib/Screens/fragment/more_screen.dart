import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshchat_sdk/freshchat_sdk.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:weevo_captain_app/core/router/router.dart';
import 'package:weevo_captain_app/core/widgets/custom_image.dart';

import '../../Dialogs/loading.dart';
import '../../Dialogs/toggle_dialog.dart';
import '../../Models/drawer_model.dart';
import '../../Models/user_data.dart';
import '../../Providers/auth_provider.dart';
import '../../Providers/shipment_provider.dart';
import '../../Storage/shared_preference.dart';
import '../../Utilits/colors.dart';
import '../../Utilits/constants.dart';
import '../../Widgets/connectivity_widget.dart';
import '../../core/networking/api_constants.dart';
import '../before_registration.dart';
import '../car_information.dart';
import '../delivery_areas.dart';
import '../my_reviews.dart';
import '../wallet.dart';
import '../weevo_web_view_preview.dart';
import 'change_your_email.dart';
import 'change_your_password.dart';
import 'change_your_phone_number.dart';
import 'profile_information.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  late ShipmentProvider _displayShipment;
  final List<DrawerModel> _names = [
    const DrawerModel(
      image: 'assets/images/weevo_account_settings_icon.png',
      title: 'تعديل الحساب',
      color: Color(0xffED7230),
    ),
    const DrawerModel(
      image: 'assets/images/weevo_wallet_icon.png',
      title: 'المحفظة',
      color: Color(0xff1DA4EA),
    ),
    const DrawerModel(
      image: 'assets/images/technical_support.png',
      title: 'تحدث معنا',
      color: Color(0xff5532EB),
    ),
    const DrawerModel(
      image: 'assets/images/weevo_my_address_icon.png',
      title: 'مناطق التوصيل',
      color: Color(0xffDE2D56),
    ),
    const DrawerModel(
      image: 'assets/images/delivery-truck.png',
      title: 'معلومات المركبة',
      color: Color(0xffED7230),
    ),
    const DrawerModel(
      image: 'assets/images/weevo_feedback.png',
      title: 'ملاحظات المستخدمين',
      color: Color(0xff1DA4EA),
    ),
    const DrawerModel(
      image: 'assets/images/weevo_notification_icon.png',
      title: 'الأشعارات',
      color: Color(0xff5532EB),
    ),
    // const DrawerModel(image: Icons.language, title: 'اللغة'),
    const DrawerModel(
      image: 'assets/images/weevo_change_email_icon.png',
      title: 'تغيير البريد الالكتروني',
      color: Color(0xffDE2D56),
    ),
    const DrawerModel(
      image: 'assets/images/weevo_change_phone_icon.png',
      title: 'تغير رقم الهاتف',
      color: Color(0xffED7230),
    ),
    const DrawerModel(
      image: 'assets/images/weevo_change_password_icon.png',
      title: 'تغير كلمة السر',
      color: Color(0xff1DA4EA),
    ),
    const DrawerModel(
      image: 'assets/images/facebook_icon.png',
      title: 'تابعنا  علي فيس بوك',
      color: Color(0xff5532EB),
    ),
    const DrawerModel(
      image: 'assets/images/weevo_who_are_we_icon.png',
      title: 'الشروط والاحكام',
      color: Color(0xffDE2D56),
    ),
    const DrawerModel(
      image: 'assets/images/weevo_how_to_use_icon.png',
      title: 'سياسة الخصوصية',
      color: Color(0xffED7230),
    ),
    DrawerModel(
      image: 'assets/images/weevo_exit_icon.png',
      title: 'حذف الحساب',
      color: Colors.red.withOpacity(0.8),
    ),
    const DrawerModel(
      image: 'assets/images/weevo_exit_icon.png',
      title: 'تسجيل الخروج',
      color: Color(0xff1DA4EA),
    ),
  ];
  bool _isOn = Preferences.instance.getReceiveNotification == 1;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _displayShipment = Provider.of<ShipmentProvider>(context, listen: false);
    _displayShipment.getDeliveryShipment(
        isPagination: false, isFirstTime: true, isRefreshing: false);
  }

  @override
  Widget build(BuildContext context) {
    final auth = AuthProvider.get(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: ConnectivityWidget(
        callback: () async {
          await _displayShipment.getDeliveryShipment(
              isPagination: false, isFirstTime: true, isRefreshing: false);
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
            bottom: 20.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 35.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'الحساب',
                          style: TextStyle(
                            fontSize: 24.0,
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'مندوب',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Row(
                      children: [
                        auth.photo!.isEmpty
                            ? const Icon(
                                Icons.account_circle,
                                color: Colors.grey,
                                size: 110.0,
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(50.0),
                                child: CustomImage(
                                  image: auth.photo != null
                                      ? auth.photo!
                                              .contains(ApiConstants.baseUrl)
                                          ? auth.photo ?? ''
                                          : '${ApiConstants.baseUrl}${auth.photo}'
                                      : '',
                                  height: 80.0,
                                  width: 80.0,
                                  radius: 0,
                                ),
                              ),
                        SizedBox(
                          width: 20.0.w,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                auth.name ?? '',
                                style: const TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                auth.phone ?? '',
                                style: const TextStyle(
                                  fontSize: 15.0,
                                ),
                              ),
                              Text(
                                auth.email ?? '',
                                style: const TextStyle(
                                  fontSize: 15.0,
                                ),
                              ),
                              UserData().cachedAverageRating != null
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        RatingBar.builder(
                                          initialRating: double.parse(
                                              auth.getRating ?? ''),
                                          minRating: 1,
                                          ignoreGestures: true,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemSize: 18.0,
                                          itemBuilder: (context, _) =>
                                              const Icon(
                                            Icons.star,
                                            color: weevoLightYellow,
                                          ),
                                          onRatingUpdate: (rating) {},
                                        ),
                                        SizedBox(
                                          width: 2.w,
                                        ),
                                        Text(
                                          auth.getRating ?? '',
                                          style: TextStyle(
                                            fontSize: 10.0.sp,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    )
                                  : Container()
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'الطلبات',
                          style: TextStyle(
                            fontSize: 24.0,
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Consumer<ShipmentProvider>(
                          builder: (ctx, data, ch) =>
                              data.deliveredState == NetworkState.waiting
                                  ? const SizedBox(
                                      height: 20.0,
                                      width: 20.0,
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                weevoPrimaryOrangeColor),
                                      ),
                                    )
                                  : Text(
                                      '${data.deliveredTotalItems}',
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black,
                                      ),
                                    ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ..._names.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(
                    top: 12.0,
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 16.0,
                    ),
                    title: Text(
                      item.title,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: _names.indexOf(item) == 6
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _isLoading
                                  ? Container(
                                      margin: const EdgeInsetsDirectional.only(
                                        end: 10,
                                      ),
                                      height: 15.h,
                                      width: 15.h,
                                      child: const CircularProgressIndicator(
                                        strokeWidth: 3.0,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                weevoPrimaryOrangeColor),
                                      ))
                                  : Container(),
                              Switch(
                                activeColor: weevoPrimaryOrangeColor,
                                value: _isOn,
                                onChanged: (bool value) async {
                                  if (!_isLoading) {
                                    setState(() => _isLoading = true);
                                    if (value == true) {
                                      await auth.notificationOn();
                                    } else {
                                      await auth.notificationOff();
                                    }
                                    setState(() => _isLoading = false);
                                    setState(() => _isOn = value);
                                  }
                                },
                              ),
                            ],
                          )
                        : Container(
                            decoration: BoxDecoration(
                              color: const Color(0xffF6F5F8),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            padding: const EdgeInsets.all(8.0),
                            height: 50.0.h,
                            width: 50.0.h,
                            child: const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.black,
                              size: 18.0,
                            ),
                          ),
                    leading: Container(
                      height: 50.0.h,
                      width: 50.0.h,
                      decoration: BoxDecoration(
                        color: item.color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      padding: const EdgeInsets.all(15.0),
                      child: Image.asset(
                        item.image,
                        height: 30.0.h,
                        width: 30.0.h,
                        fit: BoxFit.contain,
                        color: item.color,
                      ),
                    ),
                    onTap: () async {
                      switch (_names.indexOf(item)) {
                        case 0:
                          Navigator.pushNamed(context, ProfileInformation.id);
                          break;
                        case 1:
                          if (await auth.authenticateWithBiometrics()) {
                            Navigator.pushNamed(
                                navigator.currentContext!, Wallet.id);
                          }
                          break;
                        case 2:
                          Freshchat.showConversations();
                          break;
                        case 3:
                          Navigator.pushNamed(context, DeliveryAreas.id);
                          break;
                        case 4:
                          Navigator.pushNamed(context, CarInformation.id);
                          break;
                        case 6:
                          Navigator.pushNamed(context, MyReviews.id);
                          break;
                        case 7:
                          Navigator.pushNamed(context, ChangeYourEmail.id);
                          break;
                        case 8:
                          Navigator.pushNamed(context, ChangeYourPhone.id);
                          break;
                        case 9:
                          Navigator.pushNamed(context, ChangeYourPassword.id);
                          break;
                        case 10:
                          await launchUrlString(
                              'https://www.facebook.com/weevosupport?mibextid=LQQJ4d');
                          break;
                        case 11:
                          Navigator.pushNamed(context, WeevoWebViewPreview.id,
                              arguments: 'https://weevo.net/terms-conditions/');

                          break;
                        case 12:
                          Navigator.pushNamed(context, WeevoWebViewPreview.id,
                              arguments: 'https://weevo.net/privacy-policy/');
                          break;
                        case 13:
                          auth.deleteAccount();
                          break;

                        case 14:
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (ctx) {
                                bool allDevices = false;
                                return ToggleDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      20.0,
                                    ),
                                  ),
                                  title: 'تسجيل خروج',
                                  content: 'هل تود تسجيل الخروج من التطبيق',
                                  approveAction: 'نعم',
                                  toggleCallback: (bool v) {
                                    allDevices = v;
                                    log(allDevices.toString());
                                  },
                                  onApproveClick: () async {
                                    Navigator.pop(navigator.currentContext!);
                                    logoutUser(auth, allDevices);
                                  },
                                  cancelAction: 'لا',
                                  onCancelClick: () {
                                    Navigator.pop(ctx);
                                  },
                                );
                              });
                          break;
                      }
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'رقم الأصدار ${auth.appVersion}',
                      style: TextStyle(
                        fontSize: 14.0.sp,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

/*************  ✨ Codeium Command ⭐  *************/
  ///
  /// Logout the user and navigate to [BeforeRegistration] screen.
  ///
  /// [auth] is the [AuthProvider] that will be used to logout the user.
  ///
  /// [allDevices] is a boolean that represents whether to logout the user from
  /// all devices or not.
  ///
  /// The function first shows a [Loading] dialog, then logs the user out using
  /// [auth.logout] and finally navigates to [BeforeRegistration] screen.
  /// ****  ed7c38d1-e050-4ea0-8c18-c2e04ef40126  ******
  void logoutUser(AuthProvider auth, bool allDevices) async {
    log('all devices -> $allDevices');
    auth.logout(allDevices);
    Preferences.instance.clearUser();
    MagicRouter.pop();
    MagicRouter.navigateTo(
      const BeforeRegistration(),
    );
  }
}
