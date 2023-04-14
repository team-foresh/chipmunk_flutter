import 'package:chipmunk_flutter/core/gen/assets.gen.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChipmunkScaffold extends StatelessWidget {
  final Widget child;
  final bool? bottom;
  final bool? top;
  final PreferredSizeWidget? appBar;
  final Widget? bottomSheet;
  final EdgeInsets? padding;

  const ChipmunkScaffold({
    Key? key,
    required this.child,
    this.bottom,
    this.top,
    this.appBar,
    this.bottomSheet,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar ?? const ChipmunkEmptyAppBar(),
      bottomSheet: bottomSheet,
      body: SafeArea(
        bottom: bottom ?? true,
        top: top ?? true,
        child: Container(
          padding: padding ?? EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
          child: child,
        ),
      ),
    );
  }
}

class ChipmunkEmptyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChipmunkEmptyAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar();
  }

  @override
  Size get preferredSize => const Size(0.0, 0.0);
}

abstract class ChipmunkCustomAppBar {
  static leadingAppBar(
    BuildContext context, {
    required String title,
    Function0? onPressed,
  }) =>
      AppBar(
        leading: IconButton(
          icon: Assets.icons.arrowLeft.svg(),
          onPressed: onPressed ?? () => Navigator.pop(context),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          iconSize: 24,
        ),
        title: Text(title),
      );
}
