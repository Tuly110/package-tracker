import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

import '../../../../generated/colors.gen.dart';
import '../../app/app_router.dart';
import 'components/app_bar_package.dart';

@RoutePage()
class AddPackagePage extends StatefulWidget {
  const AddPackagePage({super.key});

  @override
  State<AddPackagePage> createState() => _AddPackagePageState();
}

class _AddPackagePageState extends State<AddPackagePage> {
  String selectedValue = 'SPX';
  final List<String> options = ['SPX, GHN, J&T'];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      color: ColorName.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            AppBarPackage(),
            // Divider(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 16.h),
              child: Column(
                children: [
                  TextField(
                    style: TextStyle(color: ColorName.white),
                    decoration: InputDecoration(
                      hintText: "Your tracking number",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: Colors.grey), // tương đương mặc định
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: Colors.grey), // không đổi khi focus
                      ),
                      suffixIcon: IconButton(
                        icon: FaIcon(
                          FontAwesomeIcons.qrcode,
                          color: ColorName.white,
                          size: 24.r,
                        ),
                        onPressed: () {
                          context.router.push(MobileScannerRoute());
                        },
                      ),
                    ),
                  ),
                  Gap(15),
                  TextField(
                    style: TextStyle(color: ColorName.white),
                    decoration: InputDecoration(
                      hintText: "Auto detect carrier(Optional)",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      suffixIcon: IconButton(
                        icon: FaIcon(
                          FontAwesomeIcons.angleDown,
                          color: ColorName.white,
                          size: 24.sp,
                        ),
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) => ListView(
                                    children: options.map((option) {
                                      return ListTile(
                                        title: Text(option),
                                        onTap: () {
                                          setState(() {
                                            selectedValue = option;
                                          });
                                          Navigator.pop(context);
                                        },
                                      );
                                    }).toList(),
                                  ));
                        },
                      ),
                    ),
                  ),
                  Gap(15),
                  TextField(
                    style: TextStyle(color: ColorName.white),
                    decoration: InputDecoration(
                      hintText: "Your memo(Optional)",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                  Gap(15),
                  Padding(
                      padding: EdgeInsets.only(top: 0),
                      child: SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            'Track',
                            style: TextStyle(
                                color: ColorName.white, fontSize: 15.sp),
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor: ColorName.white,
                            minimumSize: Size(100.w, 50.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
