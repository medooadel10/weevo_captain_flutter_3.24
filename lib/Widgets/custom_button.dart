import 'package:flutter/material.dart';

class CustomBtn extends StatelessWidget {
  final String text;
  final String image;
  final double height;
  final double width;
  final double imageHieght;
  final TextStyle textStyle;
  final void Function() onChange;
  final Color? backgroundColor;
  final bool showImage;
  final double elevation;

  const CustomBtn(
      {super.key,
      required this.text,
      required this.height,
      required this.width,
      required this.elevation,
      required this.image,
      required this.textStyle,
      required this.onChange,
      this.backgroundColor,
      required this.showImage,
      required this.imageHieght});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: MaterialButton(
        onPressed: onChange,
        color: backgroundColor ?? Colors.blue[100]!,
        elevation: elevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text,
                textAlign: TextAlign.center,
                style: textStyle,
              ),
              if (showImage)
                Padding(
                  padding: const EdgeInsets.only(right: 3.0),
                  child: Image.asset(
                    image,
                    height: imageHieght,
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
