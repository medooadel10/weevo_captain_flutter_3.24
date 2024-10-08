import 'package:flutter/material.dart';

import '../Utilits/colors.dart';

class ToggleDialog extends StatefulWidget {
  final String? title;
  final String? content;
  final String? approveAction;
  final ShapeBorder? shape;
  final String? cancelAction;
  final VoidCallback? onApproveClick;
  final VoidCallback? onCancelClick;
  final Function(bool) toggleCallback;

  const ToggleDialog({
    super.key,
    this.title,
    this.content,
    this.shape,
    this.approveAction,
    this.cancelAction,
    this.onApproveClick,
    this.onCancelClick,
    required this.toggleCallback,
  });

  @override
  State<ToggleDialog> createState() => _ToggleDialogState();
}

class _ToggleDialogState extends State<ToggleDialog> {
  bool _allDevices = false;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Dialog(
          shape: widget.shape ??
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                widget.title != null
                    ? Text(
                        widget.title!,
                        style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.start,
                      )
                    : Container(),
                widget.title != null
                    ? const SizedBox(
                        height: 10.0,
                      )
                    : Container(),
                widget.content != null
                    ? Text(
                        widget.content!,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      )
                    : Container(),
                widget.content != null
                    ? const SizedBox(
                        height: 10.0,
                      )
                    : Container(),
                const SizedBox(
                  height: 10.0,
                ),
                SwitchListTile(
                  value: _allDevices,
                  onChanged: (bool v) {
                    setState(() {
                      _allDevices = v;
                    });
                    widget.toggleCallback(v);
                  },
                  activeColor: weevoPrimaryOrangeColor,
                  title: const Text('الخروج من كل الأجهزة',
                      style: TextStyle(color: Colors.black, fontSize: 17.0)),
                  subtitle: Text(
                    _allDevices ? 'نعم' : 'لا',
                    style: const TextStyle(color: Colors.grey, fontSize: 15.0),
                  ),
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  widget.onApproveClick != null || widget.approveAction != null
                      ? ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all<Color>(
                                  weevoPrimaryOrangeColor)),
                          onPressed: widget.onApproveClick,
                          child: Text(
                            widget.approveAction ?? '',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14.0,
                            ),
                          ),
                        )
                      : Container(),
                  ((widget.onApproveClick != null ||
                              widget.approveAction != null) &&
                          (widget.onCancelClick != null ||
                              widget.cancelAction != null))
                      ? const SizedBox(
                          width: 10.0,
                        )
                      : Container(),
                  widget.onCancelClick != null || widget.cancelAction != null
                      ? ElevatedButton(
                          onPressed: widget.onCancelClick,
                          style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all<Color>(
                                  weevoPrimaryOrangeColor)),
                          child: Text(
                            widget.cancelAction ?? '',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14.0),
                          ),
                        )
                      : Container()
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
