import 'package:chipmunk_flutter/core/gen/colors.gen.dart';
import 'package:chipmunk_flutter/core/util/textstyle.dart';
import 'package:chipmunk_flutter/core/widgets/suffixicon/default_prefix_icon.dart';
import 'package:chipmunk_flutter/core/widgets/suffixicon/default_suffix_icon.dart';
import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChipmunkTextForm extends StatefulWidget {
  final dartz.Function1<String, void> onTextChanged;
  final String? suffixIcon;
  final String? prefixIcon;
  final dartz.Function0? onSuffixIconClicked;
  final dartz.Function0? onPrefixIconClicked;
  final TextInputType? keyboardType;
  final String? hint;
  final Color? textColor;
  final String? errorMessage;
  final List<TextInputFormatter>? inputFormatters;
  final TextEditingController? textEditingController;
  final int? maxLength;

  const ChipmunkTextForm({
    required this.onTextChanged,
    required this.textEditingController,
    this.errorMessage,
    Key? key,
    this.keyboardType,
    this.hint,
    this.maxLength,
    this.textColor,
    this.suffixIcon,
    this.prefixIcon,
    this.onSuffixIconClicked,
    this.onPrefixIconClicked,
    this.inputFormatters,
  }) : super(key: key);

  @override
  State<ChipmunkTextForm> createState() => _ChipmunkTextFormState();
}

class _ChipmunkTextFormState extends State<ChipmunkTextForm> {
  @override
  void dispose() {
    widget.textEditingController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var suffixIcon = widget.suffixIcon != null
        ? DefaultSuffixIcon(
            svgIcon: widget.suffixIcon,
            press: widget.onSuffixIconClicked,
          )
        : null;
    var prefixIcon = widget.prefixIcon != null
        ? DefaultPrefixIcon(
            svgIcon: widget.suffixIcon,
            press: widget.onPrefixIconClicked,
          )
        : null;
    return TextFormField(
      autofocus: true,
      maxLength: widget.maxLength,
      style: ChipmunkTextStyle.button1Medium(fontColor: widget.textColor),
      controller: widget.textEditingController,
      keyboardType: widget.keyboardType,
      inputFormatters: widget.inputFormatters,
      onChanged: (value) => widget.onTextChanged(value),
      decoration: InputDecoration(
        isDense: false,
        hintText: widget.hint,
        contentPadding: EdgeInsets.fromLTRB(
          prefixIcon == null ? 16.w : 0,
          16.h,
          suffixIcon == null ? 16.w : 0,
          16.w,
        ),
        counterText: "",
        hintStyle: ChipmunkTextStyle.subTitle3Regular(fontColor: ColorName.deActive),
        errorText: widget.errorMessage,
        errorStyle: ChipmunkTextStyle.body3Regular(fontColor: ColorName.negative),
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
      ),
    );
  }
}
