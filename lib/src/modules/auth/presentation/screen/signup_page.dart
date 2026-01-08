import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_tracker_app/src/common/utils/getit_utils.dart';
import 'package:my_tracker_app/src/modules/app/app_router.dart';
import 'package:my_tracker_app/src/modules/auth/presentation/component/social_widget.dart';
import 'package:my_tracker_app/src/modules/auth/presentation/component/textfield.dart';
import 'package:my_tracker_app/src/modules/auth/presentation/cubit/auth_cubit.dart';

import '../../../../../generated/assets.gen.dart';
import '../../../../../generated/colors.gen.dart';
import '../component/loading.dart';

@RoutePage()
class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  // KHAI BÁO ScrollController
  final ScrollController _scrollController = ScrollController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Cuộn đến cuối sau khi frame đầu tiên được render
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose(); // Bổ sung dispose cho usernameController
    _scrollController.dispose(); // DISPOSE controller
    super.dispose();
  }

  // --- Cải thiện giao diện Light Theme ---
  // Đặt các màu chữ cố định sang màu đen
  final Color _textColor = Colors.black87; // Màu chữ chính
  final Color _hintColor = Colors.grey.shade600; // Màu chữ phụ/hint
  final Color _linkTextColor = ColorName.brandBlue; // Màu link

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AuthCubit>(),
      child: Scaffold(
        // Đặt Scaffold background thành ColorName.white
        backgroundColor: ColorName.white,
        body: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            state.whenOrNull(
              authenticated: (userId) {
                context.router.replaceAll([const MainRoute()]);
              },
              failure: (message) {},
            );
          },
          builder: (context, state) {
            return Stack(
              children: [
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
                          // 2. TEXT: Sign Up
                          Center(
                            child: Text(
                              'Sign Up',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(
                                    // ĐỔI MÀU CHỮ THÀNH ĐEN
                                    color: _textColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30.sp,
                                  ),
                            ),
                          ),
                          // 3. TEXT: Create account
                          Center(
                            child: Text(
                              'Create account',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(
                                    // ĐỔI MÀU CHỮ THÀNH XÁM NHẸ
                                    color: _hintColor,
                                    fontSize: 16.sp,
                                  ),
                            ),
                          ),
                          // 4. FORM FIELDS
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15.w),
                            child: Form(
                              key: formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Gap(20.h), // Thêm khoảng cách sau tiêu đề
                                  TextFieldWidget(
                                    isSignUp: true,
                                    emailController: _emailController,
                                    passwordController: _passwordController,
                                    usernameController: _usernameController,
                                    // Logic hiển thị lỗi giữ nguyên
                                    emailError: state.maybeWhen(
                                      unauthenticated:
                                          (emailError, _, __, ___) =>
                                              emailError,
                                      orElse: () => null,
                                    ),
                                    usernameError: state.maybeWhen(
                                      unauthenticated:
                                          (_, __, usernameError, ___) =>
                                              usernameError,
                                      orElse: () => null,
                                    ),
                                    passwordError: state.maybeWhen(
                                      unauthenticated:
                                          (_, passwordError, __, ___) =>
                                              passwordError,
                                      orElse: () => null,
                                    ),
                                  ),
                                  Gap(40.h),
                                  // 5. SIGN UP BUTTON
                                  SizedBox(
                                    width: double.infinity,
                                    child: TextButton(
                                      onPressed: () {
                                        context.read<AuthCubit>().signUp(
                                              email: _emailController.text,
                                              username:
                                                  _usernameController.text,
                                              password:
                                                  _passwordController.text,
                                            );
                                      },
                                      child: Text(
                                        'Sign Up',
                                        style: TextStyle(
                                            color: ColorName.white,
                                            fontSize: 16.sp),
                                      ),
                                      style: TextButton.styleFrom(
                                        backgroundColor: ColorName.brandBlue,
                                        minimumSize: Size(100.w, 50.h),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // 6. HAVE AN ACCOUNT? LINK
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10.w, vertical: 7.h),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: RichText(
                                        text: TextSpan(
                                          text: "Have an account? ",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall
                                              ?.copyWith(
                                                fontSize: 16.sp,
                                                // ĐỔI MÀU CHỮ THÀNH XÁM/ĐEN
                                                color: _hintColor,
                                              ),
                                          children: [
                                            TextSpan(
                                              text: "Access now",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall
                                                  ?.copyWith(
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.bold,
                                                    // ĐỔI MÀU LINK
                                                    color: _linkTextColor,
                                                  ),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  context.pushRoute(
                                                      const LoginRoute());
                                                },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  // 7. OR LOGIN WITH EMAIL
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "or login with email",
                                      style: TextStyle(
                                          // ĐỔI MÀU CHỮ THÀNH XÁM/ĐEN
                                          color: _hintColor,
                                          fontSize: 14.sp),
                                    ),
                                  ),
                                  Gap(10.h),
                                  // 8. SOCIAL LOGIN
                                  const SocialWidget(),
                                  Gap(20.h), // Thêm khoảng cách cuối cùng
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                if (state == const AuthState.loading()) const LoadingWidget()
              ],
            );
          },
        ),
      ),
    );
  }
}
