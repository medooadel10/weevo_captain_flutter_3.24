import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:weevo_captain_app/Widgets/custom_image.dart';

import '../Providers/auth_provider.dart';
import '../Screens/weevo_web_view_preview.dart';
import '../core/networking/api_constants.dart';

class WeevoStory extends StatelessWidget {
  const WeevoStory({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 12,
          ),
          child: Text(
            'مواضيع تهمك',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          height: 210.h,
          margin: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 30.0),
          child: ListView.builder(
            itemCount: authProvider.articles!.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext ctx, int i) => GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, WeevoWebViewPreview.id,
                    arguments: authProvider.articles![i].link);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6.0,
                ),
                child: SizedBox(
                  width: 160.w,
                  height: 160.h,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: CustomImage(
                              image: authProvider.articles![i].image!
                                          .contains('http') ||
                                      authProvider.articles![i].image!
                                          .contains('https')
                                  ? authProvider.articles![i].image!
                                  : '${ApiConstants.baseUrl}${authProvider.articles![i].image}',
                              width: 160.w,
                              height: 160.h,
                              radius: 0,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              right: 8.0,
                              top: 8.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Image.asset(
                                  'assets/images/posts_icon.png',
                                  height: 30.0,
                                  width: 30.0,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.0.h,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Text(
                          authProvider.articles![i].title!,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.clip,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
