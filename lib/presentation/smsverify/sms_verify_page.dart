import 'package:alt_sms_autofill/alt_sms_autofill.dart';
import 'package:chipmunk_flutter/core/error/chipmunk_error_dialog.dart';
import 'package:chipmunk_flutter/core/util/permission.dart';
import 'package:chipmunk_flutter/core/util/textstyle.dart';
import 'package:chipmunk_flutter/core/widgets/dialog/default_dialog.dart';
import 'package:chipmunk_flutter/init.dart';
import 'package:chipmunk_flutter/presentation/chipmunk_router.dart';
import 'package:chipmunk_flutter/presentation/smsverify/component/sms_verfiy_bottom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'bloc/sms_verify.dart';
import 'component/text_field_pin.dart';

/// 번호 및 국가번호 정보.
class SmsVerifyArgs {
  final String phoneNumber;

  SmsVerifyArgs({
    required this.phoneNumber,
  });
}

class SmsVerifyPage extends StatelessWidget {
  final String phoneNumber;

  const SmsVerifyPage({
    Key? key,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<SmsVerifyBloc>()
        ..add(
          SmsVerifyInit(
            phoneNumber: phoneNumber,
          ),
        ),
      child: const _SmsVerifyPage(),
    );
  }
}

class _SmsVerifyPage extends StatefulWidget {
  const _SmsVerifyPage({Key? key}) : super(key: key);

  @override
  State<_SmsVerifyPage> createState() => _SmsVerifyPageState();
}

class _SmsVerifyPageState extends State<_SmsVerifyPage> with WidgetsBindingObserver {
  late TextEditingController textEditingController;
  late SmsVerifyBloc bloc;
  final router = serviceLocator<ChipmunkRouter>().router;
  bool _detectPermission = false;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    textEditingController = TextEditingController();
    bloc = BlocProvider.of<SmsVerifyBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    AltSmsAutofill().unregisterListener();
    bloc.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        PermissionStatus status = await Permission.sms.status;
        if (_detectPermission) {
          if (!status.isGranted) {
            bloc.add(
              SmsVerifyInit(
                phoneNumber: bloc.state.phoneNumber,
              ),
            );
            _detectPermission = false;
          } else {
            _detectPermission = false;
          }
        }
        break;
      case AppLifecycleState.paused:
        PermissionStatus status = await Permission.sms.status;
        if (!status.isGranted) {
          _detectPermission = true;
        }
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocSideEffectListener<SmsVerifyBloc, SmsVerifySideEffect>(
      listener: (context, sideEffect) {
        if (sideEffect is SmsVerifyError) {
          context.handleError(sideEffect.error, needToFinish: false);
        } else if (sideEffect is SmsVerifyMovePage) {
          router.navigateTo(
            context,
            Routes.homeRoute,
            clearStack: true,
          );
        } else if (sideEffect is SmsVerifyOpenSetting) {
          context.showChipmunkDialog(
            title: '권한요청',
            subTitle: 'SMS 권한이 필요합니다.',
            btnOkText: '이동',
            btnOkPressed: () => openAppSettings(),
          );
        } else if (sideEffect is SmsVerifyStartListening) {
          ChipmunkPermissionUtil().startSmsListening(
            (verifyCode) {
              textEditingController.text = verifyCode;
              bloc.add(SmsVerifyInput(verifyCode: verifyCode, auto: true));
            },
          );
        }
      },
      child: Scaffold(
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 100.h),
                              Text("문자로 전송된\n인증번호를 입력해주세요", style: ChipmunkTextStyle.headLine3()),
                              SizedBox(height: 40.h),
                              TextFieldPin(
                                context: context,
                                onChanged: (value) {
                                  bloc.add(SmsVerifyInput(verifyCode: value, auto: false));
                                },
                                textEditingController: textEditingController,
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
                      child: SmsVerifyBottomButton(
                        onPress: () {
                          bloc.add(SmsVerifyBottomButtonPressed());
                        },
                        isKeyboardVisible: isKeyboardVisible,
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
