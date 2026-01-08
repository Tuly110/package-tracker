import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:my_tracker_app/generated/colors.gen.dart';

class CategoryInfo {
  final IconData icon;
  final String text;

  const CategoryInfo({required this.icon, required this.text});
}

class HeaderSection extends StatelessWidget {
  const HeaderSection({
    super.key,
    required this.gapHeight,
    required this.categories,
    this.onSearchChanged,
    this.onCategorySelected,
    this.selectedCategoryIndex = 0,
  });

  final double gapHeight;
  final List<CategoryInfo> categories;
  final int selectedCategoryIndex;
  final ValueChanged<String>? onSearchChanged;
  final ValueChanged<int>? onCategorySelected;

  @override
  Widget build(BuildContext context) {
    // Giữ nền xanh cho phần trên của Header
    return Container(
      color: ColorName.blue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap(80.w),
          // Tiêu đề
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Text(
              "Let's Track Your Package",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: ColorName.white, // Giữ màu trắng cho chữ nổi bật trên nền xanh
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          Gap(12.h),
          // Thanh Search
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: TextField(
              onChanged: onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search your package',
                // Chỉnh màu hint text sáng hơn (ví dụ: ColorName.lightGray)
                hintStyle: const TextStyle(color: ColorName.lightGray),
                filled: true,
                // Nền TextField: Trắng
                fillColor: ColorName.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
                // Icon Prefix: Giữ màu xanh
                prefixIcon: const Icon(Icons.search, color: ColorName.blue),
                // Icon Suffix: Giữ màu xanh
                suffixIcon:
                    const Icon(FontAwesomeIcons.sliders, color: ColorName.blue),
              ),
              // Chữ nhập vào: Màu xanh
              style: const TextStyle(color: ColorName.blue),
            ),
          ),
          Gap(20.h),
          // Categories Section - nằm dưới và bo góc
          CategoriesSection(
            categories: categories,
            selectedIndex: selectedCategoryIndex,
            onCategorySelected: onCategorySelected,
          ),
        ],
      ),
    );
  }
}

class CategoriesSection extends StatelessWidget {
  const CategoriesSection({
    super.key,
    required this.categories,
    required this.selectedIndex,
    this.onCategorySelected,
  });

  final List<CategoryInfo> categories;
  final int selectedIndex;
  final ValueChanged<int>? onCategorySelected;

  @override
  Widget build(BuildContext context) {
    // Phần này vẫn giữ nguyên nền trắng với bo góc
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
          return InkWell(
            onTap: () {
              if (onCategorySelected != null) {
                onCategorySelected!(index);
              }
            },
            borderRadius: BorderRadius.circular(12.r),
            child: _buildCategoryItem(
              icon: categories[index].icon,
              text: categories[index].text,
              isSelected: index == selectedIndex,
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCategoryItem(
      {required IconData icon, required String text, bool isSelected = false}) {
    // Đã chỉnh lại màu:
    // - Icon: Xanh đậm khi được chọn (`ColorName.blue`) và Xám nhẹ khi không được chọn (`ColorName.lightGray`).
    // - Text: Màu chữ mặc định (Đen) và Xanh đậm khi được chọn.
    return Column(
      children: [
        FaIcon(icon,
            color: isSelected ? ColorName.blue : ColorName.lightGray,
            size: 24.sp),
        SizedBox(height: 8.h),
        Text(text,
            style: TextStyle(
                color: isSelected ? ColorName.blue : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 12.sp)),
      ],
    );
  }
}