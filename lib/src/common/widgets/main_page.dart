import 'package:auto_route/auto_route.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_tracker_app/src/modules/notify/presentation/cubit/notify_state.dart';

import '../../../generated/colors.gen.dart';
import '../../modules/app/app_router.dart';
import '../../modules/notify/presentation/cubit/notify_cubit.dart';

@RoutePage()
class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return
       AutoTabsRouter(
      routes: const [
        HomeRoute(),
        NotificationRoute(),
        ProfileRoute(),
      ],
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);

        return Scaffold(
          body: child,
          bottomNavigationBar: BlocBuilder<NotifyCubit, NotifyState>(
            builder: (context, state){
              final count = context.read<NotifyCubit>().unreadCount;
              return CurvedNavigationBar(
                index: tabsRouter.activeIndex,
                items: <Widget>[
                  Image.asset('assets/icons/home.ico', width: 28.r, height: 28.r),
                  // Image.asset(
                  //   'assets/icons/truck.ico',
                  //   width: 28.r,
                  //   height: 28.r,
                  // ),
                  Badge(
                    label: Text(count.toString()),
                    isLabelVisible: count > 0, //chỉ hiển thị khi có thông báo chưa đọc > 0
                    backgroundColor: ColorName.red,
                    child: Image.asset(
                      'assets/icons/notify.ico',
                      width: 28.r,
                      height: 28.r,
                    ),
                  ),
                  Image.asset(
                    'assets/icons/setting.ico',
                    width: 28.r,
                    height: 28.r,
                  ),
                ],
                color: ColorName.white,
                buttonBackgroundColor: ColorName.white,
                backgroundColor: ColorName.brandBlue,
                animationCurve: Curves.easeInOut,
                animationDuration: const Duration(milliseconds: 600),
                onTap: tabsRouter.setActiveIndex,
                height: 50.h,
              );
            }
          )
        );
      },
  );
    
  }
}
