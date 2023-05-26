import 'package:chipmunk_flutter/core/error/chipmunk_error_dialog.dart';
import 'package:chipmunk_flutter/core/gen/assets.gen.dart';
import 'package:chipmunk_flutter/core/util/textstyle.dart';
import 'package:chipmunk_flutter/core/widgets/button/chipmunk_scale_button.dart';
import 'package:chipmunk_flutter/core/widgets/checkbox/chipmunk_check_box.dart';
import 'package:chipmunk_flutter/domain/entity/agree_terms_entity.dart';
import 'package:chipmunk_flutter/init.dart';
import 'package:chipmunk_flutter/presentation/agreeterms/bloc/agree_terms.dart';
import 'package:chipmunk_flutter/presentation/chipmunk_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

class AgreeTermsBottomSheet extends StatelessWidget {
  final List<AgreeTermsEntity> terms;
  final String phoneNumber;

  const AgreeTermsBottomSheet(
    this.terms,
    this.phoneNumber, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<AgreeTermsBloc>()
        ..add(
          AgreeTermsInit(
            terms,
            phoneNumber,
          ),
        ),
      child: _AgreeTermsBottomSheet(terms),
    );
  }
}

class _AgreeTermsBottomSheet extends StatefulWidget {
  final List<AgreeTermsEntity> terms;

  const _AgreeTermsBottomSheet(
    this.terms, {
    super.key,
  });

  @override
  State<_AgreeTermsBottomSheet> createState() => _AgreeTermsBottomSheetState();
}

class _AgreeTermsBottomSheetState extends State<_AgreeTermsBottomSheet> {
  late AgreeTermsBloc _bloc;
  final router = serviceLocator<ChipmunkRouter>().router;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<AgreeTermsBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocSideEffectListener<AgreeTermsBloc, AgreeTermsSideEffect>(
      listener: (BuildContext context, AgreeTermsSideEffect sideEffect) {
        if (sideEffect is AgreeTermsPop) {
          router.pop(context, sideEffect.flag);
        } else if (sideEffect is AgreeTermsError) {
          context.handleError(
            sideEffect.error,
            btnOkOnPress: () {
              router.pop(context, false);
            },
          );
        }
      },
      child: BlocBuilder<AgreeTermsBloc, AgreeTermsState>(
        buildWhen: (previous, current) => previous.agreeTerms != current.agreeTerms,
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(width: 24),
                  Text(
                    "본인인증을 위해\n약관에 동의해주세요",
                    style: ChipmunkTextStyle.headLine3(),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemCount: state.agreeTerms.length,
                shrinkWrap: true,
                separatorBuilder: (context, index) => const SizedBox(height: 24),
                itemBuilder: (context, index) {
                  final item = state.agreeTerms[index];
                  return Bounceable(
                    onTap: () => _bloc.add(AgreeTermsTermClick(item)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(width: 24),
                        ChipmunkCheckBox(
                          onCheck: (isCheck) => _bloc.add(AgreeTermsTermClick(item)),
                          state: item.isChecked,
                        ),
                        const SizedBox(width: 12),
                        Text(item.title, style: ChipmunkTextStyle.body1Medium()),
                        const Spacer(),
                        Assets.icons.icArrowRight16.svg(),
                        const SizedBox(width: 24),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ChipmunkScaleButton(
                  text: "모두 동의하기",
                  isEnabled: true,
                  press: () => _bloc.add(AgreeTermsAllClick()),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
