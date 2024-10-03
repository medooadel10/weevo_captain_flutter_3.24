import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:weevo_captain_app/Widgets/custom_image.dart';

import '../Providers/auth_provider.dart';
import '../core/networking/api_constants.dart';

class VideoItem extends StatelessWidget {
  final int i;

  const VideoItem({super.key, required this.i});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 8.0),
            child: Text(
              authProvider.groupBanner![4].banners![i].name!,
              style: TextStyle(
                fontSize: 24.0.sp,
                color: Colors.black,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.start,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(
            height: 4.h,
          ),
          GestureDetector(
            onTap: () async {
              await launchUrl(Uri.parse(
                  'https://www.youtube.com/embed/${authProvider.groupBanner![4].banners![i].link!.split('?')[1].split('=')[1]}'));
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: authProvider.groupBanner![4].banners![i].image != null
                      ? AspectRatio(
                          aspectRatio: 16 / 9,
                          child: CustomImage(
                            image: authProvider
                                        .groupBanner![4].banners![i].image!
                                        .contains('http') ||
                                    authProvider
                                        .groupBanner![4].banners![i].image!
                                        .contains('https')
                                ? authProvider
                                    .groupBanner![4].banners![i].image!
                                : '${ApiConstants.baseUrl}${authProvider.groupBanner![4].banners![i].image}',
                            height: 200.h,
                            width: size.width,
                            radius: 0,
                          ),
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
        ],
      ),
    );
  }
}
