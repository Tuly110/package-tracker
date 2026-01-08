import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_tracker_app/src/modules/auth/presentation/cubit/auth_cubit.dart';

import '../../../../../generated/colors.gen.dart';

class TextFieldWidget extends StatefulWidget {
  final TextEditingController? emailController;
  final TextEditingController passwordController;
  final TextEditingController? usernameController;

  final String? emailError;
  final String? usernameError;
  final String? passwordError;
  final bool isSignUp;

  const TextFieldWidget({
    super.key,
    this.emailController,
    required this.passwordController,
    this.usernameController,
    this.emailError,
    this.passwordError,
    this.usernameError,
    this.isSignUp = false,
  });

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  bool isObscure = true;

  // Định nghĩa màu và độ dày cho viền đen nhẹ
  final BorderSide lightBlackBorder = const BorderSide(
      color: Colors.black12, width: 1.0); // Màu đen mờ, độ dày 1.0
  final Color inputFillColor =
      Colors.grey.shade100; // Nền input màu xám rất nhạt

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.isSignUp) ...[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            child: Text(
              'Email',
              style: TextStyle(color: ColorName.black, fontSize: 16.sp),
            ),
          ),
          TextField(
            controller: widget.emailController,
            style: const TextStyle(color: ColorName.black),
            decoration: InputDecoration(
              errorText: widget.emailError?.isNotEmpty == true
                  ? widget.emailError
                  : null,
              filled: true,
              // CHỈNH SỬA: Đổi màu nền input thành xám nhạt
              fillColor: inputFillColor,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              // Loại bỏ border mặc định
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: lightBlackBorder, // Dùng viền đen nhẹ
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: lightBlackBorder, // Dùng viền đen nhẹ
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(
                    color: ColorName.brandBlue,
                    width: 2.0), // Viền xanh khi focus
              ),
            ),
            onChanged: (value) {
              context.read<AuthCubit>().onEmailChanged(value);
            },
          ),
        ],
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          child: Text(
            'Username',
            style: TextStyle(color: ColorName.black, fontSize: 16.sp),
          ),
        ),
        TextField(
          controller: widget.usernameController,
          style: const TextStyle(color: ColorName.black),
          decoration: InputDecoration(
            errorText: widget.usernameError?.isNotEmpty == true
                ? widget.usernameError
                : null,
            filled: true,
            // CHỈNH SỬA: Đổi màu nền input thành xám nhạt
            fillColor: inputFillColor,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            // Loại bỏ border mặc định
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: lightBlackBorder, // Dùng viền đen nhẹ
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: lightBlackBorder, // Dùng viền đen nhẹ
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(
                  color: ColorName.brandBlue,
                  width: 2.0), // Viền xanh khi focus
            ),
          ),
          onChanged: (value) {
            context.read<AuthCubit>().onUsernameChanged(value);
          },
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          child: Text(
            'Password',
            style: TextStyle(color: Colors.black, fontSize: 16.sp),
          ),
        ),
        TextField(
          // Gán controller cho password field
          controller: widget.passwordController,
          obscureText: isObscure,
          style: const TextStyle(color: ColorName.black),
          decoration: InputDecoration(
              errorText: widget.passwordError?.isNotEmpty == true
                  ? widget.passwordError
                  : null,
              filled: true,
              // CHỈNH SỬA: Đổi màu nền input thành xám nhạt
              fillColor: inputFillColor,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              // Loại bỏ border mặc định
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: lightBlackBorder, // Dùng viền đen nhẹ
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: lightBlackBorder, // Dùng viền đen nhẹ
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(
                    color: ColorName.brandBlue,
                    width: 2.0), // Viền xanh khi focus
              ),
              suffixIcon: IconButton(
                icon: FaIcon(
                  isObscure ? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye,
                  color: Colors.black,
                  size: 16,
                ),
                onPressed: () {
                  setState(() {
                    isObscure = !isObscure;
                  });
                },
              )),
          onChanged: (value) =>
              {context.read<AuthCubit>().onPasswordChanged(value)},
        ),
      ],
    );
  }
}
