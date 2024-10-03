import 'package:flutter/material.dart';

import '../Utilits/colors.dart';

class ChooseCaptainItem extends StatelessWidget {
  const ChooseCaptainItem({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.23,
      child: Stack(
        children: [
          Card(
            elevation: 2.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                20.0,
              ),
            ),
            margin: const EdgeInsets.all(
              12.0,
            ),
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.only(right: 8, left: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/captain_car_icon.png',
                          width: size.width * 0.08,
                        ),
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        Container(
                          padding: const EdgeInsets.all(
                            4.0,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              8.0,
                            ),
                            border: Border.all(
                              color: Colors.grey[400]!,
                              width: 2.0,
                            ),
                          ),
                          child: const Row(
                            children: [
                              Text(
                                'ع س م',
                              ),
                              Text(
                                ' | ',
                              ),
                              Text(
                                '192',
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        Row(
                          children: [
                            const Text(
                              'SUZUKI',
                            ),
                            SizedBox(
                              width: size.width * 0.03,
                            ),
                            const Text(
                              'M50',
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  // SizedBox(
                  //   width: size.width * 0.01,
                  // ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'محمد سيد فهمي',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'كابتن سيارة',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 16.0,
                        ),
                      ),
                      Row(
                        children: [
                          Row(
                            children: List.generate(
                              5,
                              (index) => index > 2
                                  ? index == 3
                                      ? Icon(
                                          Icons.star_half,
                                          color: Colors.yellow[700],
                                          size: 20.0,
                                        )
                                      : Icon(
                                          Icons.star_border,
                                          color: Colors.yellow[700],
                                          size: 20.0,
                                        )
                                  : Icon(
                                      Icons.star,
                                      color: Colors.yellow[700],
                                      size: 20.0,
                                    ),
                            ),
                          ),
                          SizedBox(
                            width: size.width * 0.01,
                          ),
                          const Text(
                            '3.6',
                            style: TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  // SizedBox(
                  //   width: size.width * 0.01,
                  // ),
                  const CircleAvatar(
                    radius: 50.0,
                    backgroundImage: AssetImage(
                      'assets/images/captain_picture.png',
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(
                minimumSize: WidgetStateProperty.all<Size>(
                  Size(size.width * 0.34, size.height * 0.08),
                ),
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                backgroundColor:
                    WidgetStateProperty.all<Color>(weevoPrimaryOrangeColor),
                padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                  const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 16.0,
                  ),
                ),
              ),
              child: const Text(
                'اختيار الكابتن',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
