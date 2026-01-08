import 'package:auto_route/auto_route.dart';
import 'package:flutter/semantics.dart';
import 'package:injectable/injectable.dart';
import 'package:my_tracker_app/src/modules/carrier/presentation/carrier_page.dart';

import '../../common/widgets/main_page.dart';
import '../OTP/presentation/OTP_page.dart';
import '../add_package/presentation/add_package_page.dart';
import '../auth/presentation/screen/login_page.dart';
import '../auth/presentation/screen/signup_page.dart';
import '../home/presentation/home_page.dart';
import '../notify/presentation/notification_page.dart';
import '../onBoarding/presentation/onboarding_page.dart';
import '../profile/presentation/edit_profile_page.dart';
import '../profile/presentation/profile_page.dart'; //
import '../scan/presentation/scan_page.dart';
import '../tracking/domain/entities/tracking_details_entity.dart';
import '../tracking/presentation/presentation/tracking_page.dart';
import '../trackingDetail/presentation/tracking_detail_page.dart';
import 'splash_page.dart';

part 'app_router.gr.dart';

@singleton
@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: SplashRoute.page, path: '/'),
        AutoRoute(page: HomeRoute.page),
        AutoRoute(page: OnBoardingRoute.page),
        AutoRoute(page: MobileScannerRoute.page),
        AutoRoute(page: LoginRoute.page),
        AutoRoute(page: SignupRoute.page),
        AutoRoute(page: TrackingRoute.page),
        
        AutoRoute(
          page: ProfileRoute.page
        ),
        AutoRoute(
          page: TrackingDetailRoute.page
        ),
        AutoRoute(
          page: EditProfileRoute.page
        ),
        AutoRoute(
          page: CarrierRoute.page,
        ),
        AutoRoute(

          page: OtpRoute.page,
        ),
        AutoRoute(

          page: MainRoute.page,
          initial: true,
          children: [
            AutoRoute(page: HomeRoute.page, path: 'home'),
            AutoRoute(page: NotificationRoute.page),
            AutoRoute(page: ProfileRoute.page, path: 'profile'),
            AutoRoute(page: CarrierRoute.page),
            AutoRoute(page: LoginRoute.page),
            AutoRoute(page: TrackingRoute.page, path: 'tracking'),
          ],
        ),
      ];
}
