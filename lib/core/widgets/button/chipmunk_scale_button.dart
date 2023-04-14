import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';

class ChipmunkScaleButton extends StatelessWidget {
  final String text;
  final dartz.Function0 press;
  final bool? isEnabled;
  final ButtonStyle? style;

  const ChipmunkScaleButton({
    Key? key,
    required this.text,
    required this.press,
    this.isEnabled,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _ChipmunkAnimatedButton(
      onPressed: isEnabled == false ? null : press,
      style: style,
      child: Text(
        text,
      ),
    );
  }
}

class _ChipmunkAnimatedButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final ButtonStyle? style;

  const _ChipmunkAnimatedButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.style,
  });

  @override
  State<StatefulWidget> createState() => _ChipmunkAnimatedButtonState();
}

class _ChipmunkAnimatedButtonState extends State<_ChipmunkAnimatedButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: ScaleTransition(
        scale: Tween<double>(begin: 1, end: 0.95).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeInOut,
          ),
        ),
        child: ElevatedButton(
          style: widget.style,
          onPressed: widget.onPressed,
          child: widget.child,
        ),
      ),
    );
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _onTapCancel() {
    _controller.reverse();
  }
}
