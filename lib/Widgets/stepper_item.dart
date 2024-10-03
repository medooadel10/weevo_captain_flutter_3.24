import 'package:flutter/material.dart';

class StepperItem extends StatelessWidget {
  final String title;
  final String path;
  final int itemIndex;
  final int selectedItem;
  final Color contentColor;
  final Color textColor;
  final double height;
  final double width;

  const StepperItem({
    super.key,
    required this.title,
    required this.path,
    required this.itemIndex,
    required this.selectedItem,
    required this.contentColor,
    required this.textColor,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(
              12.0,
            ),
            height: height,
            width: width,
            decoration: BoxDecoration(
              color: contentColor,
              borderRadius: BorderRadius.circular(
                35.0,
              ),
            ),
            child: Image.asset(
              path,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: size.height * 0.008,
          ),
          Text(
            title,
            style: TextStyle(
              color: textColor,
              fontSize: 12.0,
              fontWeight: FontWeight.w700,
            ),
          )
        ],
      ),
    );
  }
}
