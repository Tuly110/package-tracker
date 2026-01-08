import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';
import '../../../../generated/assets.gen.dart';
import '../../../../generated/colors.gen.dart';
import '../../app/app_router.dart';
import '../../../common/utils/getit_utils.dart';
import 'package:cupertino_onboarding/cupertino_onboarding.dart';

@RoutePage()
class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({super.key});
  Future<void> _onOnboardingCompleted(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);
    if (context.mounted) {
      getIt<AppRouter>().replaceAll([const LoginRoute()]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoOnboarding(
      backgroundColor: ColorName.white, // ✅ Đã sửa: Nền trắng
      onPressedOnLastPage: () => _onOnboardingCompleted(context),
      bottomButtonColor: ColorName.brandBlue,
      pages: [
        CupertinoOnboardingPage(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: 'My',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 32.sp,
                            fontWeight: FontWeight.bold,
                            color: ColorName.blue, // ✅ Đã sửa: Màu xanh đậm
                          ),
                    ),
                    TextSpan(
                      text: 'Tracker',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 32.sp,
                            fontWeight: FontWeight.bold,
                            color: ColorName
                                .brandBlue, // Giữ nguyên màu xanh chính
                          ),
                    ),
                  ],
                ),
              ),
              const Gap(34),
              Assets.appImages.delivery.image(
                width: 200.h,
                fit: BoxFit.cover,
              ),
            ],
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Welcome to MyTracker!",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: ColorName.brandBlue, // Giữ nguyên màu xanh chính
                    ),
              ),
              const Gap(14),
              Text(
                "Track your packages with ease and receive real-time updates directly to your device.",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 14.sp,
                      color: ColorName.lightGray, // Giữ nguyên màu xám
                      fontWeight: FontWeight.w600,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        CupertinoOnboardingPage(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Gap(34),
              Assets.appImages.carier.image(
                width: 200.h,
                fit: BoxFit.cover,
              ),
            ],
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Global Coverage",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: ColorName.brandBlue, // Giữ nguyên màu xanh chính
                    ),
              ),
              const Gap(14),
              Text(
                "Easily track your packages from over 1000 carriers around the world, all in one app.",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 14.sp,
                      color: ColorName.lightGray, // Giữ nguyên màu xám
                      fontWeight: FontWeight.w600,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        CupertinoOnboardingPage(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Gap(34),
              Assets.appImages.logo.image(
                width: 200.h,
                fit: BoxFit.cover,
              ),
            ],
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Start For Free",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: ColorName.brandBlue, // Giữ nguyên màu xanh chính
                    ),
              ),
              const Gap(14),
              Text(
                "Get 10 free package trackings every month. Upgrade anytime you need more.",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 14.sp,
                      color: ColorName.lightGray, // Giữ nguyên màu xám
                      fontWeight: FontWeight.w600,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
