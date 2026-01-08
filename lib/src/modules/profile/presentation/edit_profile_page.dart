import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_tracker_app/src/modules/auth/presentation/cubit/auth_cubit.dart';
import 'package:my_tracker_app/src/modules/profile/presentation/components/textfield.dart';
import 'package:my_tracker_app/src/modules/profile/presentation/cubit/profile_state.dart';

import '../../../../generated/colors.gen.dart';
import 'cubit/profile_cubit.dart';

@RoutePage()
class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePage();
}

class _EditProfilePage extends State<EditProfilePage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  // Màu chủ đạo
  final Color primaryColor = ColorName.blue;
  final Color backgroundColor = Colors.white;
  final Color textColor = Colors.black87; // Màu chữ chính

  @override
  void dispose() {
    emailController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthCubit>().state.maybeWhen(
          userInfoLoaded: (user) => user,
          orElse: () => null,
        );

    if (user != null) {
      if (emailController.text.isEmpty) {
        emailController.text = user.email ?? '';
      }
      if (usernameController.text.isEmpty) {
        usernameController.text = user.username ?? '';
      }
    }

    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        state.maybeWhen(
          loaded: (message) {
            final authCubit = context.read<AuthCubit>();

            final currentUser = authCubit.state.maybeWhen(
              userInfoLoaded: (user) => user,
              orElse: () => null,
            );

            if (currentUser != null) {
              authCubit.emit(AuthState.userInfoLoaded(
                currentUser.copyWith(
                  username: usernameController.text,
                  email: emailController.text,
                ),
              ));
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message)),
            );
            context.router.pop();
          },
          error: (errorMessage) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(errorMessage)),
            );
          },
          orElse: () {},
        );
      },
      builder: (context, state) {
        final isLoading = state.maybeWhen(
          loading: () => true,
          orElse: () => false,
        );
        return Scaffold(
          backgroundColor: backgroundColor, // Nền trắng
          appBar: AppBar(
            backgroundColor: backgroundColor, // Nền trắng
            elevation: 0,
            title: Text('Edit Profile',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: primaryColor, // Tiêu đề màu xanh
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold)),
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: FaIcon(
                FontAwesomeIcons.chevronLeft,
                color: primaryColor, // Icon điều hướng màu xanh
                size: 18.sp,
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Avatar and User Info Section ---
                  BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
                    final currentUserInfo = state.maybeWhen(
                        userInfoLoaded: (user) => user, orElse: () => null);
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                            child: CircleAvatar(
                              radius: 50.r,
                              backgroundImage: const NetworkImage(
                                  'https://i.pravatar.cc/150?img=32'),
                              backgroundColor: primaryColor.withOpacity(0.1),
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            currentUserInfo?.username ?? 'Username',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                    fontSize: 16.sp,
                                    color: textColor, // ✅ ĐÃ SỬA: Màu đen trên nền trắng
                                    fontWeight: FontWeight.bold),
                          ),
                        ),
                        Center(
                          child: Text(currentUserInfo?.email ?? 'Email',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                      fontSize: 14.sp,
                                      color: Colors.black54)), // ✅ ĐÃ SỬA: Màu xám trên nền trắng
                        ),
                      ],
                    );
                  }),

                  Padding(padding: EdgeInsets.only(top: 30.h)),

                  // --- Input Fields ---
                  TextfieldProfile(
                    hintText: 'Email',
                    controller: emailController,
                  ),
                  TextfieldProfile(
                    hintText: 'Username',
                    controller: usernameController,
                  ),

                  // --- Update Button ---
                  Padding(
                      padding: EdgeInsets.only(top: 16.sp),
                      child: SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  final email = emailController.text.trim();
                                  final username =
                                      usernameController.text.trim();
                                  final authState =
                                      context.read<AuthCubit>().state;

                                  authState.maybeWhen(
                                    userInfoLoaded: (user) {
                                      final userId = user.id;
                                      final tokenDevice = user.tokenDevice;
                                      context
                                          .read<ProfileCubit>()
                                          .updateProfile(
                                            userId,
                                            tokenDevice ?? '',
                                            username,
                                            email,
                                          );
                                    },
                                    orElse: () {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  "User information not available.")));
                                    },
                                  );
                                },
                          child: isLoading
                              ? SizedBox(
                                  width: 24.w,
                                  height: 24.w,
                                  child: const CircularProgressIndicator(
                                    color: ColorName.white,
                                    strokeWidth: 3.0,
                                  ),
                                )
                              : Text(
                                  'Update',
                                  style: TextStyle(
                                      color: ColorName.white,
                                      fontSize: 15.sp),
                                ),
                          style: TextButton.styleFrom(
                            backgroundColor:
                                primaryColor, // Nút màu xanh làm điểm nhấn
                            minimumSize: Size(100.w, 50.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            disabledBackgroundColor:
                                primaryColor.withOpacity(0.5),
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}