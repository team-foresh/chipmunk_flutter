import 'package:chipmunk_flutter/core/util/theme.dart';
import 'package:chipmunk_flutter/init.dart';
import 'package:chipmunk_flutter/presentation/chipmunk_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SupanotesApp extends StatelessWidget {
  static const supabaseGreen = Color.fromRGBO(101, 217, 165, 1.0);
  final String startRoute;

  const SupanotesApp({
    super.key,
    required this.startRoute,
  });

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      splitScreenMode: false,
      minTextAdapt: true,
      rebuildFactor: RebuildFactors.all,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Chipmunk",
          theme: theme(),
          onGenerateRoute: serviceLocator<ChipmunkRouter>().router.generator,
          initialRoute: startRoute,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
        );
      },
    );
  }
}
