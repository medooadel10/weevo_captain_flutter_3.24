import 'package:flutter/material.dart';

import '../Models/state.dart';
import 'colors.dart';

class ExpandedStatesItem extends StatelessWidget {
  final States states;

  const ExpandedStatesItem({
    super.key,
    required this.states,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Card(
      margin: const EdgeInsets.symmetric(
        vertical: 4.0,
        horizontal: 10.0,
      ),
      elevation: 2.0,
      shadowColor: weevoGreyColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          10.0,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.all(
              6.0,
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: size.height * 0.008,
                      ),
                      child: Row(
                        children: [
                          const Text(
                            'ملابس وفاشون',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12.0,
                            ),
                          ),
                          SizedBox(
                            width: size.width * .03,
                          ),
                          Container(
                            width: size.width * 0.05,
                            height: size.width * 0.05,
                            padding: EdgeInsets.all(
                              size.width * 0.013,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Image.asset(
                              'assets/images/smallshirt.png',
                              fit: BoxFit.fill,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: size.width * .05,
                    ),
                    Column(
                      children: [
                        Text(
                          states.name ?? '',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Text(
                          'وصف المنتج',
                          style: TextStyle(
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: size.height * .01,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: size.width * .23,
                      height: size.height * .04,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text(
                            'جنيه',
                            style: TextStyle(
                              fontSize: 10.0,
                              color: weevoDarkGrey,
                              letterSpacing: -0.0021000000834465026,
                              fontWeight: FontWeight.w300,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Image.asset('assets/images/e.png'),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: size.width * .07,
                    ),
                    Row(
                      children: [
                        const Text(
                          'كيلو جرام',
                          style: TextStyle(
                            fontSize: 10.0,
                            color: weevoDarkGrey,
                            letterSpacing: -0.0021000000834465026,
                            fontWeight: FontWeight.w300,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          width: size.width * 0.02,
                        ),
                        Image.asset('assets/images/ee.png'),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(
                  12.0,
                ),
                bottomRight: Radius.circular(
                  12.0,
                ),
              ),
              child: Image.asset(
                'assets/images/shirt.png',
                width: size.width * 0.3,
                height: size.height * 0.12,
                fit: BoxFit.fill,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
