import 'package:auto_route/auto_route.dart';
import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:my_tracker_app/generated/colors.gen.dart';
import 'package:my_tracker_app/src/modules/carrier/presentation/component/app_bar.dart';

import '../data/models/carrier_model.dart';
import 'component/azlistview.dart';
import 'cubit/carrier_cubit.dart';
import 'cubit/carrier_state.dart';

@RoutePage()
class CarrierPage extends StatefulWidget {
  const CarrierPage({super.key});

  @override
  State<CarrierPage> createState() => _CarrierPage();
}

class _CarrierPage extends State<CarrierPage> {
  int selectedIndex = 0; // 0: Global postal, 1: Cooperation, 2: International

  List<String> menuItems = ['Global postal', 'Cooperation', 'International'];

  @override
  void initState() {
    super.initState();
    context.read<CarrierCubit>().getCarriers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorName.blue,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppBar_App(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(menuItems.length, (index) {
                  bool isSelected = index == selectedIndex;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: Text(
                      menuItems[index],
                      style: TextStyle(
                        color: isSelected ? Colors.blue : ColorName.white,
                        fontSize: 15.sp,
                        decoration: isSelected
                            ? TextDecoration.underline
                            : TextDecoration.none,
                      ),
                    ),
                  );
                }),
              ),
            ),
            Gap(10),
            Expanded(
              child: BlocBuilder<CarrierCubit, CarrierState>(
                builder: (context, state) {
                  if (state is CarrierLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is CarrierError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  } else if (state is CarrierSuccess) {
                    // 1️⃣ Lọc dữ liệu chỉ A–Z
                    final azList = state.carriers.where((c) {
                      if (c.name == null || c.name!.isEmpty) return false;
                      final firstChar = c.name![0].toUpperCase();
                      return RegExp(r'^[A-Z]$').hasMatch(firstChar);
                    }).map((c) {
                      final tag = c.name![0].toUpperCase();
                      return ISuspensionBeanExample(c.name!, tag);
                    }).toList();
                    SuspensionUtil.sortListBySuspensionTag(azList);
                    SuspensionUtil.setShowSuspensionStatus(azList);

                    return AzListView(
                      data: azList,
                      itemCount: azList.length,
                      itemBuilder: (context, index) {
                        final item = azList[index];
                        return ListTile(
                          title: Text(
                            item.name,
                            style: const TextStyle(color: Colors.white),
                            overflow: TextOverflow.ellipsis, // cắt nếu quá dài
                            maxLines: 1,
                          ),
                        );
                      },
                      indexBarData:
                          List.generate(26, (i) => String.fromCharCode(65 + i)),
                      indexBarOptions: IndexBarOptions(
                        needRebuild: true,
                        textStyle:
                            TextStyle(color: Colors.white, fontSize: 12.sp),
                        selectTextStyle: const TextStyle(color: Colors.black),
                        selectItemDecoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.white),
                        indexHintTextStyle:
                            TextStyle(fontSize: 24.sp, color: Colors.white),
                        indexHintDecoration: const BoxDecoration(
                            color: Colors.black87, shape: BoxShape.circle),
                      ),
                      susItemBuilder: (context, index) {
                        final tag = azList[index].getSuspensionTag();
                        return Container(
                          height: 40.h,
                          color: Colors.grey[850],
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            tag,
                            style:
                                TextStyle(color: Colors.white, fontSize: 14.sp),
                          ),
                        );
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  List<ISuspensionBeanExample> _convertToAzList(List<CarrierModel> carriers) {
    return carriers.where((c) {
      if (c.name == null || c.name!.isEmpty) return false;
      final firstChar = c.name![0].toUpperCase();
      return RegExp(r'^[A-Z]$').hasMatch(firstChar);
    }).map((c) {
      final tag = c.name![0].toUpperCase();
      return ISuspensionBeanExample(c.name!, tag);
    }).toList();
  }
}
