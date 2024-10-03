import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Providers/auth_provider.dart';
import '../Widgets/connectivity_widget.dart';
import '../Widgets/video_item.dart';

class VideoPreviewList extends StatelessWidget {
  static const String id = 'Video_Preview_List';

  const VideoPreviewList({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_outlined,
            ),
          ),
          title: const Text(
            'كيف تستخدم ويفو',
          ),
        ),
        body: ConnectivityWidget(
          callback: () {},
          child: ListView.builder(
            itemBuilder: (BuildContext context, int i) => VideoItem(
              i: i,
            ),
            itemCount: authProvider.groupBanner![4].banners!.length,
          ),
        ),
      ),
    );
  }
}
