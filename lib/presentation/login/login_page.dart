import 'package:chipmunk_flutter/core/error/chipmunk_error_dialog.dart';
import 'package:chipmunk_flutter/core/gen/colors.gen.dart';
import 'package:chipmunk_flutter/core/util/textstyle.dart';
import 'package:chipmunk_flutter/core/util/validators.dart';
import 'package:chipmunk_flutter/core/widgets/chipmunk_scaffold.dart';
import 'package:chipmunk_flutter/init.dart';
import 'package:chipmunk_flutter/presentation/chipmunk_router.dart';
import 'package:chipmunk_flutter/presentation/login/bloc/login.dart';
import 'package:chipmunk_flutter/presentation/login/component/country_code.dart';
import 'package:chipmunk_flutter/presentation/login/component/login_bottom_button.dart';
import 'package:chipmunk_flutter/presentation/login/component/password_input_field.dart';
import 'package:chipmunk_flutter/presentation/login/component/phone_number_input_field.dart';
import 'package:chipmunk_flutter/presentation/smsverify/sms_verify_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

class LoginPage extends StatelessWidget {
  final String? countryCode;
  final String? countryName;

  const LoginPage({
    Key? key,
    this.countryCode,
    this.countryName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<LoginBloc>()
        ..add(
          LoginInit(
            countryCode,
            countryName,
          ),
        ),
      child: const _LoginPage(),
    );
  }
}

class _LoginPage extends StatefulWidget {
  const _LoginPage({Key? key}) : super(key: key);

  @override
  State<_LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<_LoginPage> {
  late LoginBloc bloc;
  late TextEditingController phonNumberTextEditingController;
  late TextEditingController passwordTextEditingController;
  final router = serviceLocator<ChipmunkRouter>().router;

  @override
  void initState() {
    bloc = BlocProvider.of<LoginBloc>(context);
    phonNumberTextEditingController = TextEditingController();
    passwordTextEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSideEffectListener<LoginBloc, LoginSideEffect>(
      listener: (context, sideEffect) {
        if (sideEffect is LoginError) {
          context.handleError(sideEffect.error);
        } else if (sideEffect is LoginLandingScreen) {
          router.navigateTo(
            context,
            sideEffect.landingRoute,
            routeSettings: RouteSettings(
              arguments: SmsVerifyArgs(
                phoneNumber: sideEffect.phoneNumber,
              ),
            ),
          );
        }
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
                              BlocBuilder<LoginBloc, LoginState>(
                                builder: (context, state) {
                                  return CountryCode(
                                    router,
                                    countryCode: state.countryCode,
                                    countryName: state.countryName,
                                    onTap: (result) {
                                      bloc.add(
                                        LoginChangeCountryCode(
                                          result.countryCode,
                                          result.countryName,
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                              SizedBox(height: 20.h),
                              BlocBuilder<LoginBloc, LoginState>(
                                buildWhen: (previous, current) => previous.phoneNumber != current.phoneNumber,
                                builder: (context, state) {
                                  return PhoneNumberInputField(
                                    textEditingController: phonNumberTextEditingController,
                                    isShowErrorMsg: state.phoneNumber.isNotEmpty &&
                                        !ChipmunkValidator.isValidPhoneNumber(state.phoneNumber),
                                    onSuffixIconClicked: () {
                                      bloc.add(LoginPhoneNumberCancel());
                                    },
                                    onTextChanged: (text) {
                                      bloc.add(LoginPhoneNumberInput(text));
                                    },
                                  );
                                },
                              ),
                              SizedBox(height: 20.h),
                              PasswordInputField(
                                textEditingController: passwordTextEditingController,
                                onSuffixIconClicked: () {
                                  bloc.add(LoginPasswordCancel());
                                },
                                onTextChanged: (text) {
                                  bloc.add(LoginPasswordInput(text));
                                },
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: TextButton(
                                  onPressed: () {
                                    router.navigateTo(
                                      context,
                                      Routes.joinRoute,
                                    );
                                  },
                                  child: Text(
                                    "회원가입",
                                    style: ChipmunkTextStyle.subTitle3Regular(fontColor: ColorName.deActive),
                                  ),
                                ),
                              )
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
                      child: BlocBuilder<LoginBloc, LoginState>(
                        builder: (context, state) {
                          return LoginBottomButton(
                            isKeyboardVisible,
                            router,
                            isEnabled: state.isButtonEnabled,
                            onPressed: () {
                              bloc.add(LoginBottomButtonClick());
                            },
                          );
                        },
                      ),
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
