import 'package:chipmunk_flutter/core/util/textstyle.dart';
import 'package:chipmunk_flutter/core/widgets/chipmunk_scaffold.dart';
import 'package:chipmunk_flutter/init.dart';
import 'package:chipmunk_flutter/presentation/chipmunk_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'bloc/phone_number.dart';
import 'component/country_code.dart';
import 'component/phone_number_bottom_button.dart';
import 'component/phone_number_input_field.dart';

class PhoneNumberPage extends StatelessWidget {
  final String? countryCode;
  final String? countryName;

  const PhoneNumberPage({
    Key? key,
    this.countryCode,
    this.countryName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<PhoneNumberBloc>()
        ..add(
          PhoneNumberInit(
            countryCode,
            countryName,
          ),
        ),
      child: const _PhoneNumberPage(),
    );
  }
}

class _PhoneNumberPage extends StatefulWidget {
  const _PhoneNumberPage({Key? key}) : super(key: key);

  @override
  State<_PhoneNumberPage> createState() => _PhoneNumberPageState();
}

class _PhoneNumberPageState extends State<_PhoneNumberPage> {
  late PhoneNumberBloc bloc;
  late TextEditingController phonNumberTextEditingController;
  final router = serviceLocator<ChipmunkRouter>().router;

  @override
  void initState() {
    bloc = BlocProvider.of<PhoneNumberBloc>(context);
    phonNumberTextEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSideEffectListener<PhoneNumberBloc, PhoneNumberSideEffect>(
      listener: (context, sideEffect) {
        if (sideEffect is PhoneNumberError) {}
      },
      child: Scaffold(
        appBar: const ChipmunkEmptyAppBar(),
        body: SafeArea(
          bottom: false,
          child: KeyboardVisibilityBuilder(
            builder: (BuildContext context, bool isKeyboardVisible) {
              return Container(
                padding: EdgeInsets.only(
                  top: 20.h,
                  bottom: isKeyboardVisible ? 0 : 20.h,
                ),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(height: 100.h),
                              Text('require_certify_phone_number'.tr(), style: ChipmunkTextStyle.headLine3()),
                              SizedBox(height: 40.h),
                              CountryCode(router, bloc),
                              SizedBox(height: 20.h),
                              PhoneNumberInputField(
                                bloc,
                                textEditingController: phonNumberTextEditingController,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 100),
                      padding: EdgeInsets.only(
                        left: isKeyboardVisible ? 0 : 20.w,
                        right: isKeyboardVisible ? 0 : 20.w,
                        bottom: isKeyboardVisible ? 0 : 20.h,
                      ),
                      curve: Curves.easeInOut,
                      child: PhoneNumberBottomButton(isKeyboardVisible, router),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
