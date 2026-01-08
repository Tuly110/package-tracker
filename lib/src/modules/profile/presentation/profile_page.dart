import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:my_tracker_app/src/modules/auth/presentation/cubit/auth_cubit.dart';

import '../../../../generated/colors.gen.dart';
import '../../app/app_router.dart';

@RoutePage()
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  // Trạng thái toggle cho Notifications, ban đầu là bật (FontAwesomeIcons.toggleOn)
  // Đã đảo ngược logic để `isToggle = true` hiển thị `toggleOn` (màu xanh)
  bool isToggle = true;

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthCubit>().state;
    final userId = authState.maybeWhen(
      authenticated: (userId) => userId,
      orElse: () => null,
    );
    if (userId != null) {
      context.read<AuthCubit>().getUserInfo();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Màu chủ đạo: Nền trắng, các thành phần chính màu xanh
    final Color primaryColor = ColorName.blue; // Màu xanh
    const Color backgroundColor = Colors.white; // Nền trắng
    const Color textColor = Colors.black87; // Màu chữ tối
    const Color secondaryTextColor = Colors.black54; // Màu chữ phụ

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        state.whenOrNull(
          loading: () {
            // Hiển thị dialog loading
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => Center(
                  child: CircularProgressIndicator(
                color: primaryColor,
              )),
            );
          },
          unauthenticated:
              (emailError, passwordError, usernameError, errorMessage) {
            // Đóng loading dialog nếu có
            if (Navigator.of(context, rootNavigator: true).canPop()) {
              Navigator.of(context, rootNavigator: true).pop();
            }

            // Điều hướng về Login và xóa stack
            context.router.replaceAll([const LoginRoute()]);
          },
          authenticated: (userId) {
            // Đóng loading
            if (Navigator.of(context, rootNavigator: true).canPop()) {
              Navigator.of(context, rootNavigator: true).pop();
            }
          },
          failure: (message) {
            // Đóng loading nếu còn
            if (Navigator.of(context, rootNavigator: true).canPop()) {
              Navigator.of(context, rootNavigator: true).pop();
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message)),
            );
          },
        );
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: Text(
            'Profile',
            style: TextStyle(
              color: primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 20.sp,
            ),
          ),
          backgroundColor: backgroundColor,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Phần thông tin người dùng
                BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
                  final user = state.maybeWhen(
                      userInfoLoaded: (user) => user, orElse: () => null);
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 30.r,
                        backgroundImage:
                            const NetworkImage('https://i.pravatar.cc/150?img=32'),
                        backgroundColor: primaryColor.withOpacity(0.1),
                      ),
                      Gap(16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              user?.username ?? 'User Name',
                              style: TextStyle(
                                color: textColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.sp,
                              ),
                            ),
                            Text(
                              user?.email ?? 'email@example.com',
                              style: TextStyle(
                                color: secondaryTextColor,
                                fontSize: 14.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Gap(12.w),
                      IconButton(
                        onPressed: () {
                          context.pushRoute(const EditProfileRoute());
                        },
                        icon: FaIcon(
                          FontAwesomeIcons.pencil,
                          color: primaryColor,
                          size: 18.sp,
                        ),
                      ),
                    ],
                  );
                }),

                Gap(25.h),
                // Các placeholder widgets (UpgradeWidget, ProcessWidget)
                Row(children: const [
                  // UpgradeWidget(),
                ]),
                Gap(15.h),
                Row(children: const [
                  // ProcessWidget(),
                ]),
                Gap(10.h),

                // --- Phần Features ---
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Features",
                        style: TextStyle(
                            fontSize: 18.sp,
                            color: primaryColor,
                            fontWeight: FontWeight.bold)),
                    Gap(10.h),
                    // Notifications
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: FaIcon(FontAwesomeIcons.bell,
                          color: primaryColor, size: 18.sp),
                      title: Text("Notifications",
                          style: TextStyle(
                              fontSize: 16.sp, color: textColor)),
                      trailing: Transform.scale(
                        scale: 0.8, // Giảm kích thước của Switch
                        child: Switch(
                          value: isToggle,
                          onChanged: (value) {
                            setState(() {
                              isToggle = value;
                            });
                          },
                          activeColor: primaryColor,
                        ),
                      ),
                    ),
                    const Divider(color: Colors.black12, height: 1.0),
                    // Archive
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: FaIcon(FontAwesomeIcons.archive,
                          color: primaryColor, size: 18.sp),
                      title: Text("Archive",
                          style: TextStyle(
                              fontSize: 16.sp, color: textColor)),
                      trailing: FaIcon(FontAwesomeIcons.chevronRight,
                          color: secondaryTextColor, size: 14.sp),
                      onTap: () {
                        // Thêm logic điều hướng đến ArchivePage
                      },
                    ),
                  ],
                ),

                Gap(20.h),
                const Divider(color: Colors.black12, thickness: 5.0),
                Gap(15.h),

                // --- Phần Support ---
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Support",
                        style: TextStyle(
                            fontSize: 18.sp,
                            color: primaryColor,
                            fontWeight: FontWeight.bold)),
                    Gap(10.h),
                    // Feedback
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: FaIcon(FontAwesomeIcons.solidMessage,
                          color: primaryColor, size: 18.sp),
                      title: Text("Feedback",
                          style: TextStyle(
                              fontSize: 16.sp, color: textColor)),
                      trailing: FaIcon(FontAwesomeIcons.chevronRight,
                          color: secondaryTextColor, size: 14.sp),
                      onTap: () {
                        // Thêm logic điều hướng đến FeedbackPage
                      },
                    ),
                    const Divider(color: Colors.black12, height: 1.0),
                    // About us
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: FaIcon(FontAwesomeIcons.building,
                          color: primaryColor, size: 18.sp),
                      title: Text("About us",
                          style: TextStyle(
                              fontSize: 16.sp, color: textColor)),
                      trailing: FaIcon(FontAwesomeIcons.chevronRight,
                          color: secondaryTextColor, size: 14.sp),
                      onTap: () {
                        // Thêm logic điều hướng đến AboutUsPage
                      },
                    ),
                    const Divider(color: Colors.black12, height: 1.0),
                    // Privacy
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: FaIcon(FontAwesomeIcons.userShield,
                          color: primaryColor, size: 18.sp),
                      title: Text("Privacy",
                          style: TextStyle(
                              fontSize: 16.sp, color: textColor)),
                      trailing: FaIcon(FontAwesomeIcons.chevronRight,
                          color: secondaryTextColor, size: 14.sp),
                      onTap: () {
                        // Thêm logic điều hướng đến PrivacyPage
                      },
                    ),
                    const Divider(color: Colors.black12, height: 1.0),
                    // Log out
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: FaIcon(FontAwesomeIcons.rightFromBracket, // Biểu tượng log out phù hợp hơn
                          color: Colors.redAccent, size: 18.sp),
                      title: Text("Log out",
                          style: TextStyle(
                              fontSize: 16.sp, color: Colors.redAccent, fontWeight: FontWeight.w500)),
                      trailing: FaIcon(FontAwesomeIcons.chevronRight,
                          color: secondaryTextColor, size: 14.sp),
                      onTap: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Confirm Log out'),
                            content: const Text('Are you sure you want to log out?'),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: Text('Cancel', style: TextStyle(color: primaryColor)),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: const Text('Log out', style: TextStyle(color: Colors.redAccent)),
                              ),
                            ],
                          ),
                        );
                        if (confirm == true) {
                          context.read<AuthCubit>().signout();
                        }
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}