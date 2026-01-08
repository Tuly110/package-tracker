import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_tracker_app/src/common/extensions/int_duration.dart';
import 'package:my_tracker_app/src/common/utils/getit_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../generated/assets.gen.dart';
import '../../../generated/colors.gen.dart';
import '../../modules/app/app_router.dart';
import '../../modules/auth/presentation/cubit/auth_cubit.dart';

@RoutePage()
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    final authCubit = getIt<AuthCubit>();
    final prefs = await SharedPreferences.getInstance();
    final router = getIt<AppRouter>();
    await Future.delayed(3.seconds);

    authCubit.state.whenOrNull(
      authenticated: (userId) {
        router.replaceAll([MainRoute()]);
      },
      unauthenticated: (emailError, passeordError, errorMessage, usernameError) {
        final bool onboardingCompleted =
            prefs.getBool('onboarding_completed') ?? false;

        if (onboardingCompleted) {
          router.replaceAll([const LoginRoute()]);
        } else {
          router.replaceAll([const OnBoardingRoute()]);
        }
      },
      failure: (_) {
        router.replaceAll([OnBoardingRoute()]);
      },
      loading: () {
        router.replaceAll([OnBoardingRoute()]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorName.white,
      body: Center(
        child: SizedBox(
          width: 250.w,
          child: Assets.appImages.logo.image(
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
