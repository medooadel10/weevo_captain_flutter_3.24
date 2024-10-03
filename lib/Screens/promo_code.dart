import 'package:flutter/material.dart';

import '../Utilits/colors.dart';

class PromoCode extends StatefulWidget {
  static String id = 'PromoCode';

  const PromoCode({super.key});

  @override
  State<PromoCode> createState() => _PromoCodeState();
}

class _PromoCodeState extends State<PromoCode> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: promoCodeBodty(size));
  }
}

Widget promoCodeBodty(size) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Column(
      children: [
        Stack(
          children: [
            Card(
              margin: const EdgeInsets.only(
                top: 8.0,
                right: 8.0,
                left: 8.0,
              ),
              shadowColor: weevoWhiteSilverDarker,
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                height: size.height * .18,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: weevoWhiteSilverDarker,
                ),
                child: Image.asset(
                  'assets/images/offer.png',
                ),
              ),
            ),
            Positioned(
              right: 34,
              bottom: 0,
              child: Row(
                children: [
                  const Text(
                    'WEEVO-95312',
                    style: TextStyle(color: Colors.black, fontSize: 14),
                  ),
                  SizedBox(
                    width: size.width * .04,
                  ),
                  TextButton(
                    style: ButtonStyle(
                      minimumSize: WidgetStateProperty.all<Size>(
                        Size(20, size.height * 0.03),
                      ),
                      backgroundColor: WidgetStateProperty.all<Color>(
                        Colors.amber,
                      ),
                    ),
                    child: const Text(
                      'Copy',
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Lorem Ipsum is simply dummy text of the printing and \ntypesetting industry. Lorem Ipsum has been the\n industry\'s',
            style: TextStyle(
              fontSize: 11.0,
              color: weevoGreyWhite,
              height: 1.45,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 40,
            left: 10,
            right: 10,
            bottom: 20,
          ),
          child: Container(
            height: size.height * .1,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Colors.white,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'WEEVO-95312',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              style: ButtonStyle(
                minimumSize: WidgetStateProperty.all<Size>(
                  Size(size.width * 0.4, size.height * 0.08),
                ),
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                backgroundColor: WidgetStateProperty.all<Color>(
                  weevoPrimaryOrangeColor,
                ),
              ),
              child: const Text(
                'استخدام البرومو كود ',
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
              onPressed: () {},
            ),
          ],
        )
      ],
    ),
  );
}
