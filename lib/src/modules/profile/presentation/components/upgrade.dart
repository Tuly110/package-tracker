import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../../../../generated/assets.gen.dart';
import '../../../../../generated/colors.gen.dart';

class UpgradeWidget extends StatelessWidget {
  const UpgradeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: 330.w,
        height: 100.h,
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: Assets.profileImages.upgrade.provider(),
            fit: BoxFit.fill,
          ),
        ),
        child: Row(
          children: [
            // Free
            Stack(
              alignment: Alignment.center, 
              children: [
                Image(
                  image: Assets.profileImages.free.provider(),
                  width: 37.w,
                  height: 42.h,
                ),
                Text(
                  'FREE',
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 2,
                        color: ColorName.black.withOpacity(0.6),
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Gap(10),

            // Text
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "50% off",
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        color: ColorName.white,
                      ),
                    ),
                    Gap(4),
                    Text(
                      "Get rid of ads, get more quotas.",
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: ColorName.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Button
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: 30.h,
              ),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  minimumSize: Size(0, 30.h), 
                  backgroundColor: ColorName.button,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3.r),
                  ),
                ),
                child: Text(
                  "Purchase now",
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: ColorName.textButton,
                  ),
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}
