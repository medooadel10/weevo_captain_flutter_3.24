import 'package:flutter/material.dart';

class WeevoAds extends StatelessWidget {
  static const String id = 'WEEVO_ADS';

  const WeevoAds({super.key});
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () async {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
            ),
          ),
          title: const Text(
            'عروض ويفو',
          ),
        ),
      ),
    );
  }
}
