import 'dart:async';

import 'package:flutter/material.dart';

enum DoubleTapSeekAction {
  backward,
  forward,
}

class DoubleTapSeekButton extends StatefulWidget {
  final DoubleTapSeekAction action;
  final int value;
  final void Function(Duration) onChanged;
  final void Function(Duration) onSubmitted;

  const DoubleTapSeekButton({
    Key? key,
    required this.action,
    required this.value,
    required this.onChanged,
    required this.onSubmitted,
  }) : super(key: key);

  @override
  State<DoubleTapSeekButton> createState() => _DoubleTapSeekButtonState();
}

class _DoubleTapSeekButtonState extends State<DoubleTapSeekButton> {
  late Duration value;
  Timer? timer;

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void initState() {
    super.initState();
    value = Duration(seconds: widget.value);
    timer = Timer(const Duration(milliseconds: 400), () {
      widget.onSubmitted.call(value);
    });
  }

  void increment() {
    timer?.cancel();

    timer = Timer(const Duration(milliseconds: 400), () {
      widget.onSubmitted.call(value);
    });

    widget.onChanged.call(value);

    setState(() {
      value += Duration(seconds: widget.value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: increment,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              widget.action == DoubleTapSeekAction.forward
                  ? Icons.fast_forward
                  : Icons.fast_rewind,
              size: 24.0,
              color: const Color(0xFFFFFFFF),
            ),
            const SizedBox(height: 8.0),
            Text(
              widget.action == DoubleTapSeekAction.forward
                  ? '+${value.inSeconds} секунд'
                  : '-${value.inSeconds} секунд',
              style: const TextStyle(
                fontSize: 12.0,
                color: Color(0xFFFFFFFF),
              ),
            ),
          ],
        ),
      ),
    );
  }
}