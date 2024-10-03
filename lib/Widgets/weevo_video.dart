import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:weevo_captain_app/Widgets/custom_image.dart';

import '../Providers/auth_provider.dart';
import '../Screens/video_preview_list.dart';
import '../core/networking/api_constants.dart';

class WeevoVideos extends StatelessWidget {
  const WeevoVideos({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 12,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  'كيف تستخدم ويفو',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              authProvider.groupBanner![4].banners!.length > 1
                  ? InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, VideoPreviewList.id);
                      },
                      child: const Text(
                        'عرض المزيد',
                        style: TextStyle(
                          fontSize: 15.0,
                          color: Color(0xFF0062DD),
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.end,
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 8.0,
          ),
          child: GestureDetector(
            onTap: () async {
              log(authProvider.groupBanner![4].banners![0].link!
                  .split('?')[1]
                  .split('=')[1]);
              await launchUrl(Uri.parse(
                  'https://www.youtube.com/embed/${authProvider.groupBanner![4].banners![0].link!.split('?')[1].split('=')[1]}'));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 6.0,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child:
                        authProvider.groupBanner![4].banners![0].image != null
                            ? Stack(
                                children: [
                                  AspectRatio(
                                    aspectRatio: 16 / 9,
                                    child: CustomImage(
                                      image: authProvider.groupBanner![4]
                                                  .banners![0].image!
                                                  .contains('http') ||
                                              authProvider.groupBanner![4]
                                                  .banners![0].image!
                                                  .contains('https')
                                          ? authProvider.groupBanner![4]
                                              .banners![0].image!
                                          : '${ApiConstants.baseUrl}${authProvider.groupBanner![4].banners![0].image!}',
                                      width: double.infinity,
                                      height: double.infinity,
                                    ),
                                  ),
                                  AspectRatio(
                                    aspectRatio: 16 / 9,
                                    child: Container(
                                      color: Colors.black.withOpacity(0.7),
                                    ),
                                  ),
                                ],
                              )
                            : Stack(
                                children: [
                                  AspectRatio(
                                    aspectRatio: 16 / 9,
                                    child: Image.asset(
                                      'assets/images/video_image.jpg',
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  AspectRatio(
                                    aspectRatio: 16 / 9,
                                    child: Container(
                                      color: Colors.black.withOpacity(0.7),
                                    ),
                                  ),
                                ],
                              ),
                  ),
                  Image.asset(
                    'assets/images/weevo_video_icon.png',
                    height: 23.h,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
