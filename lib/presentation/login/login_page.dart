import 'dart:async';

import 'package:chipmunk_flutter/core/error/chipmunk_error_dialog.dart';
import 'package:chipmunk_flutter/core/util/textstyle.dart';
import 'package:chipmunk_flutter/core/widgets/bottomsheet/bottom_sheet_ext.dart';
import 'package:chipmunk_flutter/core/widgets/chipmunk_scaffold.dart';
import 'package:chipmunk_flutter/init.dart';
import 'package:chipmunk_flutter/presentation/chipmunk_router.dart';
import 'package:chipmunk_flutter/presentation/login/bloc/login.dart';
import 'package:chipmunk_flutter/presentation/login/component/login_bottom_button.dart';
import 'package:chipmunk_flutter/presentation/smsverify/sms_verify_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import '../agreeterms/agree_terms_bottom_sheet.dart';
import 'component/login_phone_number.dart';
import 'component/login_verify_code_number.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<LoginBloc>(),
      child: const Scaffold(
        appBar: ChipmunkEmptyAppBar(),
        body: SafeArea(
          bottom: false,
          child: _LoginPage(),
        ),
      ),
    );
  }
}

class _LoginPage extends StatefulWidget {
  const _LoginPage({Key? key}) : super(key: key);

  @override
  State<_LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<_LoginPage> {
  late LoginBloc _bloc;
  final router = serviceLocator<ChipmunkRouter>().router;
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _verifyCodeController = TextEditingController();
  final GlobalKey<AnimatedListState> _stepperKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<LoginBloc>(context);
  }

  @override
  void dispose() {
    super.dispose();
    _phoneNumberController.dispose();
    _verifyCodeController.dispose();
    _bloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSideEffectListener<LoginBloc, LoginSideEffect>(
      listener: (context, sideEffect) async {
        if (sideEffect is LoginError) {
          context.handleError(sideEffect.error, needToFinish: false);
        } else if (sideEffect is LoginLandingRoute) {
          router.navigateTo(
            context,
            sideEffect.landingRoute,
            routeSettings: RouteSettings(
              arguments: SmsVerifyArgs(
                phoneNumber: sideEffect.phoneNumber,
              ),
            ),
            clearStack: sideEffect.landingRoute == Routes.homeRoute ? true : false,
          );
        } else if (sideEffect is LoginShowTermsBottomSheet) {
          final result = await context.showChipmunkBottomSheet(
            content: (context) => AgreeTermsBottomSheet(
              sideEffect.terms,
              sideEffect.phoneNumber,
            ),
          );
          if (result) {
            _bloc.add(LoginRequestVerifyCode());
          }
        } else if (sideEffect is LoginNextStep) {
          _stepperKey.currentState?.insertItem(0, duration: const Duration(milliseconds: 200));
        }
      },
      child: KeyboardVisibilityBuilder(
        builder: (BuildContext context, bool isKeyboardVisible) {
          return Container(
            padding: EdgeInsets.only(
              top: 20,
              bottom: isKeyboardVisible ? 0 : 20,
            ),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: BlocListener<LoginBloc, LoginState>(
                      listener: (context, state) {
                        _phoneNumberController.text = state.phoneNumber;
                        _verifyCodeController.text = state.verifyCode;
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 40),
                          // 상단 타이틀.
                          BlocBuilder<LoginBloc, LoginState>(
                            buildWhen: (previous, current) => previous.guideTitle != current.guideTitle,
                            builder: (context, state) {
                              return Text(state.guideTitle, style: ChipmunkTextStyle.headLine3());
                            },
                          ),
                          const SizedBox(height: 20),
                          BlocListener<LoginBloc, LoginState>(
                            listenWhen: (previous, current) =>
                                previous.isRequestVerifyCodeEnable && !current.isRequestVerifyCodeEnable,
                            listener: (context, state) {
                              Timer.periodic(
                                const Duration(seconds: 1),
                                (timer) {
                                  if (_bloc.state.verifyTime == 0) {
                                    timer.cancel();
                                  } else {
                                    _bloc.add(LoginRequestVerifyCodeCountdown());
                                  }
                                },
                              );
                            },
                            child: BlocBuilder<LoginBloc, LoginState>(
                              buildWhen: (previous, current) => previous.verifyTime != current.verifyTime,
                              builder: (context, state) => state.verifyTime != 0
                                  ? () {
                                      int min = state.verifyTime ~/ 60; // 초를 분으로 변환
                                      int sec = state.verifyTime % 60; // 남은 초를 계산
                                      String displayTime =
                                          "${min.toString().padLeft(2, '0')}분 ${sec.toString().padLeft(2, '0')}초";
                                      return Text("$displayTime 뒤에 다시 인증번호 요청을 할 수 있습니다",
                                          style: ChipmunkTextStyle.body1Medium());
                                    }()
                                  : const SizedBox.shrink(),
                            ),
                          ),
                          const SizedBox(height: 20),
                          // 로그인 상태.
                          BlocBuilder<LoginBloc, LoginState>(
                            buildWhen: (previous, current) =>
                                previous.steppers != current.steppers ||
                                previous.phoneNumber != current.phoneNumber ||
                                previous.verifyCode != current.verifyCode ||
                                previous.isRequestVerifyCodeEnable != current.isRequestVerifyCodeEnable,
                            builder: (context, state) {
                              return Flexible(
                                child: AnimatedList(
                                  key: _stepperKey,
                                  physics: const BouncingScrollPhysics(),
                                  initialItemCount: state.steppers.length,
                                  itemBuilder: (context, index, animation) {
                                    return _createStep(
                                      state: state,
                                      context: context,
                                      index: index,
                                      animation: animation,
                                    );
                                  },
                                ),
                              );
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
                    left: isKeyboardVisible ? 0 : 20,
                    right: isKeyboardVisible ? 0 : 20,
                    bottom: isKeyboardVisible ? 0 : 20,
                  ),
                  curve: Curves.easeInOut,
                  child: BlocBuilder<LoginBloc, LoginState>(
                    buildWhen: (previous, current) => previous.isButtonEnabled != current.isButtonEnabled,
                    builder: (context, state) {
                      return LoginBottomButton(
                        isKeyboardVisible,
                        router,
                        isEnabled: state.isButtonEnabled,
                        onPressed: () {
                          _bloc.add(LoginBottomButtonClick());
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
    );
  }

  Widget _createStep({
    required LoginState state,
    required BuildContext context,
    required int index,
    required Animation<double> animation,
  }) {
    switch (state.steppers[index]) {
      case LoginStepper.phoneNumber:
        return SizeTransition(
          sizeFactor: animation,
          child: LoginPhoneNumber(
            phoneNumber: state.phoneNumber,
            phoneNumberController: _phoneNumberController,
            onTextChanged: (text) => _bloc.add(LoginPhoneNumberInput(text)),
          ),
        );

      case LoginStepper.signInWithOtp:
        return SizeTransition(
          sizeFactor: animation,
          child: LoginVerifyCodeNumber(
            verifyCodeController: _verifyCodeController,
            verifyCode: state.verifyCode,
            onTextChanged: (text) {
              _bloc.add(LoginVerifyCodeInput(verifyCode: text));
            },
            isRequestVerifyCodeEnable: state.isRequestVerifyCodeEnable,
            onRequestClick: () => _bloc.add(LoginRequestVerifyCode()),
          ),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
