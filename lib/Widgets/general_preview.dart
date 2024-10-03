import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:weevo_captain_app/core/widgets/custom_shimmer.dart';

import '../Providers/auth_provider.dart';
import '../Providers/wallet_provider.dart';
import '../Screens/wallet.dart';
import '../Storage/shared_preference.dart';
import '../Utilits/colors.dart';
import '../Utilits/constants.dart';
import '../Utilits/notification_const.dart';
import '../core/helpers/spacing.dart';
import '../core/networking/api_constants.dart';
import '../core/router/router.dart';
import '../core/widgets/custom_image.dart';
import '../features/available_shipments/ui/screens/available_shipments_screen.dart';
import '../features/shipments/ui/screens/shipments_screen.dart';

class GeneralPreview extends StatefulWidget {
  final Size size;

  const GeneralPreview({
    super.key,
    required this.size,
  });

  @override
  State<GeneralPreview> createState() => _GeneralPreviewState();
}

class _GeneralPreviewState extends State<GeneralPreview> {
  bool firstTime = true;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        8.0,
        8.0,
        8.0,
        0.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (authProvider.groupBannersState != NetworkState.waiting)
            SizedBox(
              height: 120.h,
              width: double.infinity,
              child: CarouselSlider(
                items: List.generate(
                  authProvider.groupBanner != null
                      ? authProvider.groupBanner![3].banners!.length
                      : 0,
                  (int i) => GestureDetector(
                    onTap: () {
                      whereTo(context,
                          authProvider.groupBanner![3].banners![i].link!);
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(0.0),
                      child: CustomImage(
                        image: authProvider.groupBanner![3].banners![i].image!
                                    .contains('http') ||
                                authProvider.groupBanner![3].banners![i].image!
                                    .contains('https')
                            ? authProvider.groupBanner![3].banners![i].image!
                            : '${ApiConstants.baseUrl}${authProvider.groupBanner![3].banners![i].image}',
                        width: MediaQuery.of(context).size.width,
                        radius: 12,
                      ),
                    ),
                  ),
                ),
                options: CarouselOptions(
                    autoPlay: true,
                    aspectRatio: 2.0,
                    enlargeCenterPage: true,
                    enlargeStrategy: CenterPageEnlargeStrategy.scale,
                    viewportFraction: 0.8,
                    onPageChanged:
                        (int i, CarouselPageChangedReason reason) {}),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
              ),
              child: CustomShimmer(
                height: 120.h,
                width: double.infinity,
                shapeBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsetsDirectional.only(
              start: 10,
              top: 15.0,
            ),
            child: Row(
              children: [
                const Text(
                  'اهلاً بك',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                horizontalSpace(3),
                Text(
                  Preferences.instance.getUserName.split(' ')[0],
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                    color: weevoPrimaryBlueColor,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 6.h,
          ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    MagicRouter.navigateTo(const AvailableShipmentsScreen());
                  },
                  child: Container(
                    height: 170.h,
                    width: double.infinity,
                    margin: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      color: weevoPrimaryOrangeColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 50.h,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 12.0),
                            child: Text(
                              'الطلبات المتاحة\nللتوصيل',
                              style: TextStyle(
                                fontSize: 18.0.sp,
                                color: const Color(0xff33334D),
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: Image.asset(
                            'assets/images/delivery_guy.png',
                            height: 100.h,
                            width: 120.w,
                            alignment: Alignment.bottomCenter,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    Provider.of<WalletProvider>(context, listen: false)
                        .fromOfferPage = false;
                    if (await authProvider.authenticateWithBiometrics()) {
                      Navigator.pushNamed(navigator.currentContext!, Wallet.id);
                    }
                  },
                  child: Container(
                    height: 170.h,
                    width: 150.h,
                    margin: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'المحفظة',
                                style: TextStyle(
                                  fontSize: 18.0.sp,
                                  color: const Color(0xff33334D),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Image.asset(
                          'assets/images/my_wallet.png',
                          alignment: Alignment.bottomCenter,
                          fit: BoxFit.contain,
                          height: 80.h,
                          width: 120.h,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    MagicRouter.navigateTo(const ShipmentsScreen(
                      shipmentsCompleted: false,
                    ));
                  },
                  child: Container(
                    height: 170.h,
                    margin: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      color: weevoPrimaryBlueColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'الطلبات المعلقة',
                                style: TextStyle(
                                  fontSize: 18.0.sp,
                                  color: const Color(0xff33334D),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Image.asset(
                          'assets/images/my_shipment.png',
                          alignment: Alignment.bottomCenter,
                          fit: BoxFit.contain,
                          height: 80.h,
                          width: 120.h,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    MagicRouter.navigateTo(const ShipmentsScreen(
                      shipmentsCompleted: true,
                    ));
                  },
                  child: Container(
                    height: 170.h,
                    margin: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      color: weevoPrimaryBlueColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'الطلبات المكتملة',
                                style: TextStyle(
                                  fontSize: 18.0.sp,
                                  color: const Color(0xff33334D),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Image.asset(
                          'assets/images/guy_alarm.png',
                          alignment: Alignment.bottomCenter,
                          fit: BoxFit.contain,
                          height: 80.h,
                          width: 120.h,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
