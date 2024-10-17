import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WeevoButton extends StatefulWidget {
  final Function? onTap;
  final String? title;
  final Color color;
  final bool isStable;
  final FontWeight? weight;
  final double? radius;
  final String? icon;
  final bool isExpand;
  final Widget? child;
  const WeevoButton({
    super.key,
    required this.onTap,
    this.title,
    required this.color,
    required this.isStable,
    this.weight,
    this.radius,
    this.icon,
    this.isExpand = false,
    this.child,
  });

  @override
  State<WeevoButton> createState() => _WeevoButtonState();
}

class _WeevoButtonState extends State<WeevoButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.isExpand ? double.infinity : null,
      child: ElevatedButton.icon(
        style: ButtonStyle(
          elevation: WidgetStateProperty.all<double>(
            0.0,
          ),
          padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
            const EdgeInsets.all(13.0),
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
                widget.radius ?? 12.0,
              ),
            ),
          ),
        ),
        onPressed: widget.onTap != null
            ? () {
                FocusScope.of(context).unfocus();
                widget.onTap!();
              }
            : null,
        label: widget.child ??
            Text(
              widget.title ?? '',
              style: TextStyle(
                fontSize: 16.0.sp,
                fontWeight: widget.weight,
              ),
            ),
        icon: widget.icon != null
            ? Image.asset(
                widget.icon!,
                height: 30.h,
                width: 30.w,
              )
            : Container(),
      ),
    );
  }
}
