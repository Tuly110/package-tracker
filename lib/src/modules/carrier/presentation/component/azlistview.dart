import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ISuspensionBeanExample implements ISuspensionBean {
  final String name;
  final String tag;
  bool _isShowSuspension = false;

  ISuspensionBeanExample(this.name, this.tag);

  @override
  String getSuspensionTag() => tag;

  @override
  bool get isShowSuspension => _isShowSuspension;

  @override
  set isShowSuspension(bool value) {
    _isShowSuspension = value;
  }
}

class Azlistview extends StatelessWidget {
  final List<ISuspensionBeanExample> data;
  final List<String> allTags = List.generate(26, (index) => String.fromCharCode(65 + index));
  
  Azlistview({super.key, required this.data});
  
  @override
  Widget build(BuildContext context) {
    // sort and set status
  
  SuspensionUtil.sortListBySuspensionTag(data);
  SuspensionUtil.setShowSuspensionStatus(data);

  return AzListView(
    data: data,
    itemCount: data.length,
    itemBuilder: (context, index) {
      final item = data[index];
      return ListTile(
        title: Text(item.name, style: TextStyle(color: Colors.white)),
      );
    },
    indexBarData: SuspensionUtil.getTagIndexList(data),
    indexBarOptions: IndexBarOptions(
      needRebuild: true,
      textStyle: TextStyle(color: Colors.white, fontSize: 12.sp),
      selectTextStyle: TextStyle(color: Colors.black),
      selectItemDecoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
      indexHintTextStyle: TextStyle(fontSize: 24.sp, color: Colors.white),
      indexHintDecoration: BoxDecoration(color: Colors.black87, shape: BoxShape.circle),
    ),
    susItemBuilder: (context, index) {
      final tag = data[index].getSuspensionTag();
      return Container(
        height: 40.h,
        color: Colors.grey[850],
        padding: EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.centerLeft,
        child: Text(tag, style: TextStyle(color: Colors.white, fontSize: 14.sp)),
      );
    },
  );


}

}
