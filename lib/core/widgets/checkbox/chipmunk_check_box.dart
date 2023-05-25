import 'package:chipmunk_flutter/core/gen/colors.gen.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChipmunkCheckBox extends StatelessWidget {
  final bool state;
  final Function1<bool, void> onCheck;

  const ChipmunkCheckBox({
    Key? key,
    required this.onCheck,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: 0.9,
      child: Container(
        width: 16,
        height: 16,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.r),
          color: ColorName.backgroundLight,
        ),
        child: Checkbox(
          value: state,
          onChanged: (value) => onCheck(value!),
        ),
      ),
    );
  }
}
