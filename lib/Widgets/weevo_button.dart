import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WeevoButton extends StatefulWidget {
  final VoidCallback onTap;
  final String? title;
  final Color color;
  final bool isStable;
  final FontWeight? weight;
  final Widget? childWidget;

  const WeevoButton(
      {super.key,
      required this.onTap,
      this.title,
      required this.color,
      this.isStable = true,
      this.weight,
      this.childWidget});

  @override
  State<WeevoButton> createState() => _WeevoButtonState();
}

class _WeevoButtonState extends State<WeevoButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        elevation: WidgetStateProperty.all<double>(
          0.0,
        ),
        padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
          const EdgeInsets.all(15.0),
        ),
        backgroundColor: WidgetStateProperty.all<Color>(
          widget.isStable ? widget.color : Colors.transparent,
        ),
        foregroundColor: WidgetStateProperty.all<Color>(
            widget.isStable ? Colors.white : widget.color),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            side: BorderSide(
              width: 1.0,
              color: widget.color,
            ),
            borderRadius: BorderRadius.circular(
              20.0,
            ),
          ),
        ),
      ),
      onPressed: widget.onTap,
      child: widget.childWidget ??
          Text(
            widget.title ?? '',
            style: TextStyle(
              fontSize: 16.0.sp,
              fontWeight: widget.weight,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
    );
  }
}
