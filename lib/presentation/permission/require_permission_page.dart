import 'package:chipmunk_flutter/core/gen/assets.gen.dart';
import 'package:chipmunk_flutter/core/gen/colors.gen.dart';
import 'package:chipmunk_flutter/core/util/permission.dart';
import 'package:chipmunk_flutter/core/util/textstyle.dart';
import 'package:chipmunk_flutter/core/widgets/button/chipmunk_scale_button.dart';
import 'package:chipmunk_flutter/core/widgets/chipmunk_scaffold.dart';
import 'package:chipmunk_flutter/core/widgets/dialog/default_dialog.dart';
import 'package:chipmunk_flutter/init.dart';
import 'package:chipmunk_flutter/presentation/chipmunk_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import 'bloc/request_permission.dart';

class _RequestPermissionEntity {
  final SvgPicture icon;
  final String title;
  final String subTitle;

  _RequestPermissionEntity({
    required this.title,
    required this.subTitle,
    required this.icon,
  });
}

class RequestPermissionPage extends StatelessWidget {
  const RequestPermissionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<RequestPermissionBloc>()..add(RequestPermissionInit()),
      child: ChipmunkScaffold(
        appBar: ChipmunkCustomAppBar.leadingAppBar(context, title: ''),
        child: const _RequestPermissionPage(),
      ),
    );
  }
}

class _RequestPermissionPage extends StatefulWidget {
  const _RequestPermissionPage({Key? key}) : super(key: key);

  @override
  State<_RequestPermissionPage> createState() => _RequestPermissionPageState();
}

class _RequestPermissionPageState extends State<_RequestPermissionPage> {
  final _router = serviceLocator<ChipmunkRouter>().router;
  late RequestPermissionBloc _bloc;

  final _permissionItems = [
    _RequestPermissionEntity(
      icon: Assets.icons.icPhone.svg(),
      title: "전화/SMS(필수)",
      subTitle: "휴대폰 번호 본인 인증",
    ),
    _RequestPermissionEntity(
      icon: Assets.icons.icMappin.svg(),
      title: "위치(필수)",
      subTitle: "현재 위치 확인 및 메인서비스 이용",
    ),
    _RequestPermissionEntity(
      icon: Assets.icons.icImage.svg(),
      title: "사진(선택)",
      subTitle: "프로필 이미지 설정",
    ),
    _RequestPermissionEntity(
      icon: Assets.icons.icBell.svg(),
      title: "알림(선택)",
      subTitle: "알림 수신",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<RequestPermissionBloc>(context);
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocSideEffectListener<RequestPermissionBloc, RequestPermissionSideEffect>(
      listener: (context, sideEffect) async {
        if (sideEffect is RequestPermissionStart) {
          ChipmunkPermissionUtil.requestPermission(_bloc.state.permissions);
        } else if (sideEffect is RequestPermissionFail) {
          context.showChipmunkDialog(
            title: '권한 요청',
            subTitle: '허용하지 않은 필수 권한이 있어요.',
            btnOkText: '이동',
            btnOkPressed: () {
              openAppSettings();
            },
          );
        } else if (sideEffect is RequestPermissionSuccess) {
          _router.navigateTo(
            context,
            _bloc.state.nextLandingRoute,
            clearStack: true,
          );
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "서비스 이용을 위해\n권한 허용이 필요해요",
            style: ChipmunkTextStyle.headLine3(),
            textAlign: TextAlign.start,
          ),
          const SizedBox(height: 40),
          ListView.separated(
            physics: const BouncingScrollPhysics(),
            itemCount: _permissionItems.length,
            shrinkWrap: true,
            separatorBuilder: (context, index) => const SizedBox(height: 32),
            itemBuilder: (context, index) => _itemPermission(_permissionItems[index]),
          ),
          const SizedBox(height: 40),
          Text(
            "선택 권한의 경우 허용하지 않으셔도 서비스를 이용하실 수 있으나, "
            "일부 서비스 이용이 제한될 수 있습니다.",
            style: ChipmunkTextStyle.body3Regular(fontColor: ColorName.activeDark),
          ),
          const Spacer(),
          ChipmunkScaleButton(
            text: 'next'.tr(),
            press: () => _bloc.add(RequestPermissionNext()),
          )
        ],
      ),
    );
  }

  Row _itemPermission(_RequestPermissionEntity permissionItem) {
    return Row(
      children: [
        permissionItem.icon,
        const SizedBox(width: 28),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              permissionItem.title,
              style: ChipmunkTextStyle.body2Regular(),
            ),
            const SizedBox(height: 4),
            Text(
              permissionItem.subTitle,
              style: ChipmunkTextStyle.body2Regular(fontColor: ColorName.activeDark),
            ),
          ],
        )
      ],
    );
  }
}
