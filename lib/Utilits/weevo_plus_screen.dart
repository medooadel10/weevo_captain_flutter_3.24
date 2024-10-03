import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../Widgets/weevo_button.dart';
import 'colors.dart';

class WeevoPlus extends StatefulWidget {
  static String id = 'WeevoPlus';

  const WeevoPlus({super.key});

  @override
  State<WeevoPlus> createState() => _WeevoPlusState();
}

class _WeevoPlusState extends State<WeevoPlus> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Image.asset(
            'assets/images/logoplus.png',
            height: 125,
            width: 125,
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.close,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: bodyWeevoPlus(context, size),
        ));
  }
}

Widget bodyWeevoPlus(context, size) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Text(
                'احصل على مميزات ويفو بلس',
                style: TextStyle(
                  fontSize: 23.0.sp,
                  color: weevoBlackGrey,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                'عشان تنجز شغلك بسرعة وسهولة وتوصل\nشحناتك في اسرع وقت',
                style: TextStyle(
                  fontSize: 18.0.sp,
                  color: Colors.grey[600],
                  letterSpacing: 0.24,
                  fontWeight: FontWeight.w300,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          )
        ],
      ),
      const SizedBox(
        height: 20,
      ),
      Expanded(
        child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            SizedBox(
              width: double.infinity,
              child: ListView.builder(
                itemCount: offerList.length,
                itemBuilder: (context, i) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: OfferItems(i),
                ),
              ),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: WeevoButton(
          onTap: () {
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(
                    20.0,
                  ),
                  topRight: Radius.circular(
                    20.0,
                  ),
                ),
              ),
              isScrollControlled: true,
              builder: (context) => SizedBox(
                height: size.height * .64,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView(
                    children: [
                      Text.rich(
                        TextSpan(
                          style: TextStyle(
                            fontSize: 14.0.sp,
                            color: weevoWhiteGrey,
                          ),
                          children: [
                            TextSpan(
                              text: 'اختر خطة الاشتراك\n',
                              style: TextStyle(
                                color: weevoBlack,
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            TextSpan(
                              text:
                                  'انضم لأكثر من 10525 شخص قدروا\nيوصلو منتجاتهم ويشتغلوا من خلال ويفو',
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.grey[850],
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          margin: const EdgeInsets.all(8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              // color: Colors.green,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            height: size.height * .1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        children: [
                                          Row(
                                            children: <Widget>[
                                              const Text(
                                                'جنيه',
                                                style: TextStyle(
                                                  fontSize: 15.0,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                  height: 0.87,
                                                ),
                                                textAlign: TextAlign.right,
                                              ),
                                              SizedBox(
                                                width: size.width * .02,
                                              ),
                                              const Text(
                                                '599',
                                                style: TextStyle(
                                                  fontSize: 15.0,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                  height: 0.87,
                                                ),
                                                textAlign: TextAlign.right,
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: size.height * .01,
                                          ),
                                          Row(
                                            children: <Widget>[
                                              const Text(
                                                'جنيه',
                                                style: TextStyle(
                                                  fontSize: 15.0,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                  height: 0.87,
                                                ),
                                                textAlign: TextAlign.right,
                                              ),
                                              SizedBox(
                                                width: size.width * .02,
                                              ),
                                              const Text(
                                                '2279',
                                                style: TextStyle(
                                                  fontSize: 15.0,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                  height: 0.87,
                                                ),
                                                textAlign: TextAlign.right,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          const Text(
                                            'خطة السنة',
                                            style: TextStyle(
                                              fontSize: 13.0,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                              height: 0.85,
                                            ),
                                            textAlign: TextAlign.right,
                                          ),
                                          SizedBox(
                                            height: size.height * .01,
                                          ),
                                          Row(
                                            children: <Widget>[
                                              const Text(
                                                'جنيه/اسبوع',
                                                style: TextStyle(
                                                  fontSize: 15.0,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                  height: 0.87,
                                                ),
                                                textAlign: TextAlign.right,
                                              ),
                                              SizedBox(
                                                width: size.width * .02,
                                              ),
                                              const Text(
                                                '12',
                                                style: TextStyle(
                                                  fontSize: 15.0,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                  height: 0.87,
                                                ),
                                                textAlign: TextAlign.right,
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          margin: const EdgeInsets.all(8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              // color: Colors.green,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            height: size.height * .1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        children: [
                                          Row(
                                            children: <Widget>[
                                              const Text(
                                                'جنيه',
                                                style: TextStyle(
                                                  fontSize: 15.0,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                  height: 0.87,
                                                ),
                                                textAlign: TextAlign.right,
                                              ),
                                              SizedBox(
                                                width: size.width * .02,
                                              ),
                                              const Text(
                                                '599',
                                                style: TextStyle(
                                                  fontSize: 15.0,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                  height: 0.87,
                                                ),
                                                textAlign: TextAlign.right,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          const Text(
                                            'خطة الـ 6 شهور',
                                            style: TextStyle(
                                              fontSize: 13.0,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                              height: 0.85,
                                            ),
                                            textAlign: TextAlign.right,
                                          ),
                                          SizedBox(
                                            height: size.height * .01,
                                          ),
                                          Row(
                                            children: <Widget>[
                                              const Text(
                                                'جنيه/اسبوع',
                                                style: TextStyle(
                                                  fontSize: 15.0,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                  height: 0.87,
                                                ),
                                                textAlign: TextAlign.right,
                                              ),
                                              SizedBox(
                                                width: size.width * .02,
                                              ),
                                              const Text(
                                                '24',
                                                style: TextStyle(
                                                  fontSize: 15.0,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                  height: 0.87,
                                                ),
                                                textAlign: TextAlign.right,
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          margin: const EdgeInsets.all(8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              // color: Colors.green,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            height: size.height * .1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        children: [
                                          Row(
                                            children: <Widget>[
                                              const Text(
                                                'جنيه',
                                                style: TextStyle(
                                                  fontSize: 15.0,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                  height: 0.87,
                                                ),
                                                textAlign: TextAlign.right,
                                              ),
                                              SizedBox(
                                                width: size.width * .02,
                                              ),
                                              const Text(
                                                '599',
                                                style: TextStyle(
                                                  fontSize: 15.0,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                  height: 0.87,
                                                ),
                                                textAlign: TextAlign.right,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          const Text(
                                            'خطة الشهر',
                                            style: TextStyle(
                                              fontSize: 13.0,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                              height: 0.85,
                                            ),
                                            textAlign: TextAlign.right,
                                          ),
                                          SizedBox(
                                            height: size.height * .01,
                                          ),
                                          Row(
                                            children: <Widget>[
                                              const Text(
                                                'جنيه/اسبوع',
                                                style: TextStyle(
                                                  fontSize: 15.0,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                  height: 0.87,
                                                ),
                                                textAlign: TextAlign.right,
                                              ),
                                              SizedBox(
                                                width: size.width * .02,
                                              ),
                                              const Text(
                                                '24',
                                                style: TextStyle(
                                                  fontSize: 15.0,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                  height: 0.87,
                                                ),
                                                textAlign: TextAlign.right,
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: WeevoButton(
                            onTap: () {},
                            title: 'اختر  الخطة السنوية',
                            color: weevoPrimaryOrangeColor,
                            isStable: true),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          title: 'اختر خطة الاشتراك',
          color: weevoPrimaryBlueColor,
          isStable: true,
        ),
      ),
    ],
  );
}

class Offers {
  String title;
  String image;
  String subtitle;
  String assetImage;

  Offers({
    required this.image,
    required this.subtitle,
    required this.title,
    required this.assetImage,
  });
}

final offerList = [
  Offers(
      image: 'assets/images/mapplus.png',
      subtitle: 'ويفو هيوفرلك اقرب مندوب ليـــــك\nوهيوصلك بمندوب في اسرع وقت',
      title: "اقرب مندوب ليك",
      assetImage: ('assets/images/path.png')),
  Offers(
      image: 'assets/images/plusss.png',
      subtitle: 'هتقدر تضيف عدد شحنات غير محدودة\nعلى تطبيق ويفو',
      title: 'عدد اوردرات غير محدود',
      assetImage: ('assets/images/order.png')),
  Offers(
      image: 'assets/images/pluss.png',
      subtitle: 'هتحصل على مميزات موسمية كتير\nوخصومات وهدايا',
      title: 'خصومات وهدايا',
      assetImage: ('assets/images/ordergift.png')),
];

class OfferItems extends StatelessWidget {
  final int s;

  const OfferItems(this.s, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                offerList[s].title,
                style: const TextStyle(
                  fontSize: 20.0,
                  color: weevoGold,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                width: 25,
              ),
              Container(
                alignment: Alignment.center,
                width: 34.0,
                height: 34.0,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: weevoGold,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      offerList[s].assetImage,
                      height: 25,
                      width: 25,
                    ),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            offerList[s].subtitle,
            style: const TextStyle(
              fontSize: 17.0,
              color: Colors.black,
              letterSpacing: 0.272,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 20,
          ),
          Image.asset(
            offerList[s].image,
            fit: BoxFit.fill,
          )
        ],
      ),
    );
  }
}
