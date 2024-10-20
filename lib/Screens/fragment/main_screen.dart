import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../Providers/auth_provider.dart';
import '../../Utilits/constants.dart';
import '../../Widgets/general_preview.dart';
import '../../Widgets/weevo_video.dart';
import '../../core/widgets/custom_shimmer.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          GeneralPreview(
            size: size,
          ),
          SizedBox(
            height: 8.h,
          ),
          if (authProvider.groupBannersState != NetworkState.waiting)
            const WeevoVideos()
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
          // SizedBox(
          //   height: 8.h,
          // ),
          // Visibility(
          //   visible: authProvider.articleState == NetworkState.SUCCESS,
          //   child: WeevoStory(),
          // ),
        ],
      ),
    );
  }
}
