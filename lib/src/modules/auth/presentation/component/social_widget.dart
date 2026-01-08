import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_tracker_app/generated/colors.gen.dart';
import 'package:my_tracker_app/src/modules/auth/presentation/cubit/auth_cubit.dart';

import '../../../../../generated/assets.gen.dart';

class SocialWidget extends StatelessWidget {
  const SocialWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal:
              15.w), // Thêm padding ngang để căn chỉnh với các trường input
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
              child: GestureDetector(
            child: Container(
              width: double.infinity,
              height: 50.h,
              decoration: BoxDecoration(
                // CHỈNH SỬA MÀU NỀN: Đổi từ Colors.white10 sang trắng tinh hoặc xám nhạt
                color: Colors.grey.shade100, // Nền xám nhạt
                borderRadius: BorderRadius.circular(6),
                // THÊM VIỀN: Thêm viền xám nhẹ để nút nổi bật trên nền trắng
                border: Border.all(color: Colors.grey.shade300, width: 1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Assets.authImages.google.image(
                    width: 24.w,
                    height: 24.h,
                  ),
                  Gap(10),
                  Text(
                    "Continue with Google",
                    style: TextStyle(
                      // CHỈNH SỬA MÀU CHỮ: Đổi từ ColorName.white sang màu đen/xám đậm
                      color: Colors.grey.shade800,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500, // Làm chữ đậm hơn một chút
                    ),
                  )
                ],
              ),
            ),
            onTap: () {
              context.read<AuthCubit>().signInWithGoogle();
            },
          ))
        ],
      ),
    );
  }
}
