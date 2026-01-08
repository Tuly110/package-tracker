import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:my_tracker_app/generated/colors.gen.dart';
import 'package:my_tracker_app/src/modules/notify/domain/entities/notify_entity.dart';

class TodayNotifications extends StatelessWidget {
  final List<NotifyEntity> notifies; 

  const TodayNotifications({
    super.key,
    required this.notifies,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Today',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(color: ColorName.black, fontWeight: FontWeight.bold),
        ),
        Gap(8.h),
        // list notify
        ...notifies.map((notify) => Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: _buildNotificationCard(
                icon: FontAwesomeIcons.bell, // lấy icon theo loại notify
                text: notify.message ?? 'No content',
                iconColor: ColorName.brandBlue,
                backgroundColor: ColorName.sky,
                isUnread: notify.status == 'unread', // đánh dấu notify chưa đọc
              ),
            )),
      ],
    );
  }

  IconData _getIcon(String type) {
    switch (type) {
      case 'order':
        return FontAwesomeIcons.listCheck;
      case 'message':
        return FontAwesomeIcons.envelope;
      default:
        return FontAwesomeIcons.bell;
    }
  }

  Widget _buildNotificationCard({
    required IconData icon,
    required String text,
    required Color iconColor,
    required Color backgroundColor,
    required bool isUnread,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      elevation: 2,
      shadowColor: ColorName.black.withAlpha(25),
      clipBehavior: Clip.antiAlias,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: backgroundColor,
          child: FaIcon(icon, color: iconColor, size: 20.r),
        ),
        title: Text(
          text,
          style: TextStyle(fontSize: 14.sp, color: ColorName.black),
        ),
        trailing: isUnread
            ? Container(
                width: 10.w,
                height: 10.h,
                decoration: const BoxDecoration(
                  color: ColorName.red,
                  shape: BoxShape.circle,
                ),
              )
            : null,
        onTap: () {
          print('Thông báo đã được nhấn: $text');
        },
      ),
    );
  }
}
