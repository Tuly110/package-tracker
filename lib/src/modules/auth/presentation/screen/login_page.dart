import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_tracker_app/src/modules/auth/presentation/component/social_widget.dart';
import 'package:my_tracker_app/src/modules/auth/presentation/cubit/auth_cubit.dart';

import '../../../../../generated/assets.gen.dart';
import '../../../../../generated/colors.gen.dart';
import '../../../app/app_router.dart';
import '../component/loading.dart';
import '../component/textfield.dart';

@RoutePage()
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  // KHAI BÁO ScrollController
  final ScrollController _scrollController = ScrollController();

  bool isObscure = true;
  bool isLoading = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final String methodLogin = 'email';
  final TextEditingController _forgotPasswordEmailController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        if (_scrollController.hasClients && _scrollController.position.hasContentDimensions) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      } catch (e) {
        debugPrint("Scroll error during logout/login: $e");
      }
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _forgotPasswordEmailController.dispose();
    _scrollController.dispose(); // ⚠️ DISPOSE ScrollController
    super.dispose();
  }

  void _showForgotPasswordSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      // CHỈNH SỬA MÀU: Đổi từ ColorName.black sang ColorName.white
      backgroundColor: ColorName.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
            left: 20.w,
            right: 20.w,
            top: 20.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Forgot Password',
                style: TextStyle(
                  // CHỈNH SỬA MÀU: Đổi từ ColorName.white sang ColorName.black cho nền trắng
                  color: ColorName.black,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Gap(10.h),
              Text(
                'Enter your email address to receive a password reset link.',
                style: TextStyle(color: ColorName.black, fontSize: 14.sp),
              ),
              Gap(20.h),
              TextFormField(
                controller: _forgotPasswordEmailController,
                style: const TextStyle(color: ColorName.black),
                decoration: InputDecoration(
                  labelText: 'Email',
                  // CHỈNH SỬA MÀU: Đổi màu label sang đen
                  labelStyle: const TextStyle(color: ColorName.black),
                  filled: true,
                  // CHỈNH SỬA MÀU: Đổi màu input sang xám nhạt trên nền trắng
                  fillColor: Colors.grey.shade200,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    // Thêm border màu xanh khi focus
                    borderSide:
                        BorderSide(color: ColorName.brandBlue, width: 2),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              Gap(20.h),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    // Cần đọc AuthCubit từ context của widget cha
                    context.read<AuthCubit>().resetPassword(
                          email: _forgotPasswordEmailController.text,
                        );
                    Navigator.pop(sheetContext);
                  },
                  style: TextButton.styleFrom(
                    // Giữ màu brandBlue cho nút nhấn
                    backgroundColor: ColorName.brandBlue,
                    minimumSize: Size(double.infinity, 50.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: Text(
                    'Send Reset Email',
                    style: TextStyle(color: ColorName.white, fontSize: 15.sp),
                  ),
                ),
              ),
              Gap(20.h),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorName.white,
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          state.whenOrNull(
            authenticated: (userId) {
              context.read<AuthCubit>().getUserInfo();
            },
            userInfoLoaded: (user) {
              // just navigator to main route after login success
              if (context.router.current.name != MainRoute.name) {
                context.router.replaceAll([const MainRoute()]);
              }
            },
            failure: (message) {
              print("Login failed: $message");
            },
          );
        },
        builder: (context, state) {
          return Stack(children: [
            SingleChildScrollView(
              // GÁN ScrollController VÀO SingleChildScrollView
              controller: _scrollController,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. HEADER IMAGE
                      SizedBox(
                        width: double.infinity,
                        child: Center(
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Assets.authImages.auth.image(
                              fit: BoxFit.cover,
                              height: 220.h,
                            ),
                          ),
                        ),
                      ),
                      // 2. TEXT: Login
                      Center(
                        child: Text(
                          'Login',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                  // CHỈNH SỬA MÀU: Đổi từ ColorName.white sang ColorName.black
                                  color: ColorName.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30.sp),
                        ),
                      ),
                      // 3. TEXT: Access account
                      Center(
                        child: Text(
                          'Access account',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                  // CHỈNH SỬA MÀU: Đổi từ ColorName.white sang Colors.grey.shade700
                                  color: Colors.grey.shade700,
                                  fontSize: 16.sp),
                        ),
                      ),
                      // 4. MAIN CONTENT
                      Expanded(
                        child: SingleChildScrollView(
                            // Note: Nên dùng Column/Padding trực tiếp trong SingleChildScrollView chính
                            // thay vì SingleChildScrollView lồng (như trong code gốc) để tránh
                            // các vấn đề về cuộn. Tôi đã xóa SingleChildScrollView lồng.
                            child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.w),
                          child: Form(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // căn giữa theo chiều ngang
                            children: [
                              Gap(20.h), // Thêm khoảng cách sau tiêu đề
                              // 5. INPUT FIELDS
                              TextFieldWidget(
                                isSignUp: false,
                                usernameController: _usernameController,
                                passwordController: _passwordController,
                                usernameError: state.mapOrNull(
                                  unauthenticated: (s) => s.usernameError,
                                ),
                                passwordError: state.mapOrNull(
                                    unauthenticated: (s) =>
                                        s.passwordError),
                              ),
                              // 6. FORGOT PASSWORD LINK
                              Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10.w, vertical: 10.h),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: GestureDetector(
                                      onTap: () {
                                        _showForgotPasswordSheet(context);
                                      },
                                      child: Text(
                                        'Forgot password?',
                                        style: TextStyle(
                                            fontSize: 14.sp,
                                            // CHỈNH SỬA MÀU: Đổi từ ColorName.white sang Colors.grey.shade700
                                            color: Colors.grey.shade700),
                                      ),
                                    ),
                                  )),
                              // 7. LOGIN BUTTON
                              Padding(
                                  padding: EdgeInsets.only(top: 0),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: TextButton(
                                      onPressed: () {
                                        context.read<AuthCubit>().signIn(
                                            username:
                                                _usernameController.text,
                                            password:
                                                _passwordController.text,
                                            methodLogin: methodLogin);
                                      },
                                      child: Text(
                                        'Login',
                                        style: TextStyle(
                                            color: ColorName.white,
                                            fontSize: 15.sp),
                                      ),
                                      style: TextButton.styleFrom(
                                        backgroundColor:
                                            ColorName.brandBlue,
                                        minimumSize: Size(100.w, 50.h),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                      ),
                                    ),
                                  )),
                              // 8. REGISTER LINK
                              Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10.w, vertical: 7.h),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: RichText(
                                      text: TextSpan(
                                          text: "Don't have an account? ",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall
                                              ?.copyWith(
                                                  fontSize: 16.sp,
                                                  // CHỈNH SỬA MÀU: Đổi từ Colors.white sang ColorName.black
                                                  color: ColorName.black),
                                          children: [
                                            TextSpan(
                                              text: "Register",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall
                                                  ?.copyWith(
                                                      fontSize: 16.sp,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      // Giữ màu brandBlue
                                                      color: ColorName
                                                          .brandBlue),
                                              recognizer:
                                                  TapGestureRecognizer()
                                                    ..onTap = () {
                                                      context.pushRoute(
                                                          const SignupRoute());
                                                    },
                                            ),
                                          ]),
                                    ),
                                  )),
                              // 9. OR DIVIDER
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "or",
                                  style: TextStyle(
                                      // CHỈNH SỬA MÀU: Đổi từ ColorName.white sang ColorName.black
                                      color: ColorName.black,
                                      fontSize: 14.sp),
                                ),
                              ),
                              Gap(10.h),
                              // 10. SOCIAL WIDGET
                              const SocialWidget(),
                              Gap(20.h), // Thêm khoảng cách cuối cùng
                            ],
                          )),
                        )),
                      )
                    ],
                  ),
                ),
              ),
            ),
            if (state == const AuthState.loading() && _usernameController.text.isNotEmpty) 
              const LoadingWidget()
          ]);
        },
      )
    );
  }
}