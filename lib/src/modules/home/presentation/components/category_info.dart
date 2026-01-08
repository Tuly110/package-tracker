import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_tracker_app/generated/colors.gen.dart';

class CategoryInfo {
  final IconData icon;
  final String text;

  const CategoryInfo({required this.icon, required this.text});
}

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({
    super.key,
    required this.categories,
    this.selectedIndex = 0,
  });

  final List<CategoryInfo> categories;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      decoration: BoxDecoration(
        color: ColorName.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(categories.length, (index) {
          return _buildCategoryItem(
            icon: categories[index].icon,
            text: categories[index].text,
            isSelected: index == selectedIndex,
          );
        }),
      ),
    );
  }

  Widget _buildCategoryItem(
      {required IconData icon, required String text, bool isSelected = false}) {
    return Column(
      children: [
        FaIcon(icon,
            color: isSelected ? ColorName.cyan : ColorName.lightGray,
            size: 24.sp),
        SizedBox(height: 8.h),
        Text(text,
            style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 12.sp)),
      ],
    );
  }
}
