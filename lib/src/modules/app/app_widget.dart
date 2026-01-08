import 'package:asuka/asuka.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_tracker_app/src/modules/auth/presentation/cubit/auth_cubit.dart';
import 'package:oktoast/oktoast.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../../common/utils/getit_utils.dart';
import 'app_router.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final router = getIt<AppRouter>();
    // final talker = getIt<Talker>();
    return OKToast(
      child: ScreenUtilInit(
        designSize: const Size(360, 802),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) => SafeArea(
          child: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light.copyWith(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.light,
            ),
            child: BlocProvider(
              create: (context) => getIt<AuthCubit>(),
              child: BlocListener<AuthCubit, AuthState>(
                listener: (context, state) async {
                  final prefs = await SharedPreferences.getInstance();
                  final bool onboardingCompleted =
                      prefs.getBool('onboarding_completed') ?? false;
                  state.whenOrNull(
                    authenticated: (userId) {
                      context.read<AuthCubit>().getUserInfo();
                      getIt<AppRouter>().replaceAll([const MainRoute()]);
                    },
                    unauthenticated: (emailError, usernameError, passwordError,
                        errorMessage) {
                      if (onboardingCompleted) {
                        getIt<AppRouter>().replaceAll([const LoginRoute()]);
                      } else {
                        getIt<AppRouter>().replaceAll([const SplashRoute()]);
                      }
                    },
                  );
                },
                child: MaterialApp.router(
                  theme: ThemeData(
                    fontFamily: 'Poppins',
                  ),
                  builder: (context, child) {
                    child = Asuka.builder(context, child);
                    return EasyLoading.init()(context, child);
                  },
                  debugShowCheckedModeBanner: false,
                  routerConfig: router.config(
                    navigatorObservers: () =>
                        [TalkerRouteObserver(getIt<Talker>())],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
