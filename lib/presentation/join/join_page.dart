import 'package:chipmunk_flutter/core/error/chipmunk_error_dialog.dart';
import 'package:chipmunk_flutter/core/util/textstyle.dart';
import 'package:chipmunk_flutter/core/util/validators.dart';
import 'package:chipmunk_flutter/core/widgets/chipmunk_scaffold.dart';
import 'package:chipmunk_flutter/init.dart';
import 'package:chipmunk_flutter/presentation/chipmunk_router.dart';
import 'package:chipmunk_flutter/presentation/join/bloc/join.dart';
import 'package:chipmunk_flutter/presentation/login/component/country_code.dart';
import 'package:chipmunk_flutter/presentation/login/component/login_bottom_button.dart';
import 'package:chipmunk_flutter/presentation/login/component/password_input_field.dart';
import 'package:chipmunk_flutter/presentation/login/component/phone_number_input_field.dart';
import 'package:chipmunk_flutter/presentation/smsverify/sms_verify_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

class JoinPage extends StatelessWidget {
  final String? countryCode;
  final String? countryName;

  const JoinPage({
    Key? key,
    this.countryCode,
    this.countryName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<JoinBloc>()
        ..add(
          JoinInit(
            countryCode,
            countryName,
          ),
        ),
      child: const _JoinPage(),
    );
  }
}

class _JoinPage extends StatefulWidget {
  const _JoinPage({Key? key}) : super(key: key);

  @override
  State<_JoinPage> createState() => _JoinPageState();
}

class _JoinPageState extends State<_JoinPage> {
  late JoinBloc bloc;
  late TextEditingController phonNumberTextEditingController;
  late TextEditingController passwordTextEditingController;
  late TextEditingController passwordAgainTextEditingController;
  final router = serviceLocator<ChipmunkRouter>().router;

  @override
  void initState() {
    bloc = BlocProvider.of<JoinBloc>(context);
    phonNumberTextEditingController = TextEditingController();
    passwordTextEditingController = TextEditingController();
    passwordAgainTextEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSideEffectListener<JoinBloc, JoinSideEffect>(
      listener: (context, sideEffect) {
        if (sideEffect is JoinError) {
          context.handleError(sideEffect.error);
        } else if (sideEffect is JoinLandingScreen) {
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
                              Text('회원가입을 진행해주세요', style: ChipmunkTextStyle.headLine3()),
                              SizedBox(height: 40.h),
                              Text(
                                "휴대폰번호 ",
                                style: ChipmunkTextStyle.subTitle3Medium(),
                              ),
                              SizedBox(height: 20.h),
                              BlocBuilder<JoinBloc, JoinState>(
                                builder: (context, state) {
                                  return CountryCode(
                                    router,
                                    countryCode: state.countryCode,
                                    countryName: state.countryName,
                                    onTap: (result) {
                                      bloc.add(
                                        JoinChangeCountryCode(
                                          result.countryCode,
                                          result.countryName,
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                              SizedBox(height: 20.h),
                              BlocBuilder<JoinBloc, JoinState>(
                                buildWhen: (previous, current) => previous.phoneNumber != current.phoneNumber,
                                builder: (context, state) {
                                  return PhoneNumberInputField(
                                    textEditingController: phonNumberTextEditingController,
                                    isShowErrorMsg: state.phoneNumber.isNotEmpty &&
                                        !ChipmunkValidator.isValidPhoneNumber(state.phoneNumber),
                                    onTextChanged: (text) {
                                      bloc.add(JoinPhoneNumberInput(text));
                                    },
                                    onSuffixIconClicked: () {
                                      bloc.add(JoinPhoneNumberCancel());
                                    },
                                  );
                                },
                              ),
                              SizedBox(height: 40.h),
                              Text(
                                "비밀번호 ",
                                style: ChipmunkTextStyle.subTitle3Medium(),
                              ),
                              SizedBox(height: 20.h),
                              PasswordInputField(
                                textEditingController: passwordTextEditingController,
                                onSuffixIconClicked: () {
                                  bloc.add(JoinPasswordCancel());
                                },
                                onTextChanged: (text) {
                                  bloc.add(JoinPasswordInput(text));
                                },
                              ),
                              SizedBox(height: 20.h),
                              PasswordInputField(
                                textEditingController: passwordAgainTextEditingController,
                                hint: 'require_certify_password_hint_again',
                                onSuffixIconClicked: () {
                                  bloc.add(JoinPasswordAgainCancel());
                                },
                                onTextChanged: (text) {
                                  bloc.add(JoinPasswordAgainInput(text));
                                },
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
                      child: BlocBuilder<JoinBloc, JoinState>(
                        builder: (context, state) {
                          return LoginBottomButton(
                            isKeyboardVisible,
                            router,
                            isEnabled: state.isButtonEnabled,
                            onPressed: () {
                              bloc.add(JoinBottomButtonClick());
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
