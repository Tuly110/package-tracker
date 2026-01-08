import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../generated/colors.gen.dart';

class TextfieldProfile extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final bool isNumber;

  const TextfieldProfile(
      {super.key,
      required this.hintText,
      this.controller,
      this.isNumber = false});

  @override
  Widget build(BuildContext context) {
    const defaultBorderSide = BorderSide(
      color: Colors.grey, // Màu xám cho border mặc định
      width: 1.0,
    );

    const focusedBorderSide = BorderSide(
      color: ColorName.brandBlue, // Màu xanh cho border khi focus
      width: 2.0,
    );

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: TextField(
        controller: controller,
        style: TextStyle(color: ColorName.black),
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        inputFormatters:
            isNumber ? [FilteringTextInputFormatter.digitsOnly] : [],
        decoration: InputDecoration(
          hintText: hintText,
          filled: true,
          fillColor: ColorName.input,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: defaultBorderSide,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: defaultBorderSide,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide:
                focusedBorderSide, // ⬅️ ĐÃ CHỈNH SỬA: Thêm borderSide và tăng độ dày/màu
          ),
          hintStyle: TextStyle(color: Colors.grey.shade600),
        ),
        onChanged: (value) {},
      ),
    );
  }
}
