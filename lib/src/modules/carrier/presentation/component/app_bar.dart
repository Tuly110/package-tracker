import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_tracker_app/generated/colors.gen.dart';

class AppBar_App extends StatelessWidget {
  const AppBar_App({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: ColorName.blue,
      leading: IconButton(
        icon: FaIcon(
          FontAwesomeIcons.chevronLeft,
          color: ColorName.white,
          size: 18.sp,
        ),
        onPressed: () {},
      ),
      title: Text(
        'Carrier List',
        style: TextStyle(color: ColorName.white, fontSize: 18.sp),
      ),
      actions: [
        IconButton(
          icon: FaIcon(
            FontAwesomeIcons.magnifyingGlass,
            color: ColorName.white,
            size: 18.sp,
          ),
          onPressed: () {
            // Handle settings action
          },
        ),
      ],
      centerTitle: true,
    );
  }
}
