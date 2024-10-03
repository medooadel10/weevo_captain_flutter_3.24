import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../Providers/auth_provider.dart';
import '../../Utilits/constants.dart';
import '../../Widgets/general_preview.dart';
import '../../Widgets/weevo_video.dart';

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
          Visibility(
            visible: authProvider.groupBannersState == NetworkState.success,
            child: const WeevoVideos(),
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
