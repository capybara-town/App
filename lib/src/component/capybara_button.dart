import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../theme/color_theme.dart';

class CapybaraButton extends StatefulWidget {
  const CapybaraButton({
    Key? key,
    required this.onTap,
    required this.width,
    this.height = 60,
    this.scale = 0.95,
    required this.text,
    this.textStyle = const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: ColorTheme.white),
    this.background = ColorTheme.redPoint,
    this.active = true,
  }) : super(key: key);

  final Function() onTap;
  final double width;
  final double height;
  final double scale;
  final String text;
  final TextStyle? textStyle;
  final Color background;
  final bool active;

  @override
  State<CapybaraButton> createState() => _ButtonAnimState();
}

class _ButtonAnimState extends State<CapybaraButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  bool tapDown = false;
  bool tapCancel = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 150),
        reverseDuration: const Duration(milliseconds: 100),
        value: 1.0,
        lowerBound: 0.000001,
        upperBound: 1.00000
    );

    _animation = CurvedAnimation(
        parent: _controller,
        curve: CustomEaseOutCircCurve(scale: widget.scale),
        reverseCurve: CustomEaseInCircCurve(scale: widget.scale)
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse().then((_) {
      if (!tapCancel && widget.active) widget.onTap();
      _controller.forward();
      setState(() {
        tapDown = false;
      });
    });
    tapCancel = false;
  }

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _controller.reverse();
      tapDown = true;
    });
  }

  void _onTapCancel() {
    tapCancel = true;
    _controller.reverse().then((_) {
      _controller.forward();
      setState(() {
        tapDown = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
        scale: _animation,
        child: GestureDetector(
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeInOut,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: widget.background
                ),
                width: widget.width,
                height: widget.height,
                child: Center(child: Text(widget.text, style: widget.textStyle))
            )
        )
    );
  }
}

class CustomEaseOutCircCurve extends Curve {

  final double scale;

  const CustomEaseOutCircCurve({required this.scale});

  @override
  double transformInternal(double t) {
    // Curves.easeOutCirc의 동작을 사용자 정의 커브 함수로 변환합니다.
    return ((1 - scale) * sqrt(1 - pow(t - 1, 2)) + scale);
  }
}

class CustomEaseInCircCurve extends Curve {

  final double scale;

  const CustomEaseInCircCurve({required this.scale});

  @override
  double transformInternal(double t) {
    return ((1 - scale) * (1 - sqrt(1 - pow(t, 2))) + scale);
  }
}
