import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../generated/colors.gen.dart';

class AppBarPackage extends StatelessWidget {
  const AppBarPackage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // 1. Change AppBar background color to ColorName.blue or any other color
      backgroundColor: ColorName.blue,

      // Ensure icons are white
      iconTheme: IconThemeData(
        color: ColorName.white,
      ),

      title: Text("Add Package"),
      // Ensure title text is white
      titleTextStyle: TextStyle(
          color: ColorName.white, fontSize: 18.sp, fontWeight: FontWeight.bold),
      centerTitle: true,
      leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: FaIcon(
            FontAwesomeIcons.chevronLeft,
            color: ColorName
                .white, // Explicitly set icon color (though iconTheme handles it)
            size: 18.sp,
          )),
    );
  }
}
