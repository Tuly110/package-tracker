import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:my_tracker_app/generated/colors.gen.dart';

import '../../../tracking/domain/entities/tracking_details_entity.dart';

class TodayNotifications extends StatelessWidget {
  final TrackingDetailEntity detail;

  const TodayNotifications({
    super.key,
    required this.detail,
  });

  @override
  Widget build(BuildContext context) {
    final tracks = detail.tracks; // Lấy danh sách hành trình
    final carrier = detail.carrierName ?? 'Unknown Carrier';

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tiêu đề Nhà vận chuyển
          Center(
            child: Text(
              carrier,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: ColorName.black,
                    fontWeight: FontWeight.w800,
                    fontSize: 18.sp,
                  ),
            ),
          ),
          Gap(16.h),

          // Dùng ListView.builder/Separated thay cho Column với ... nếu danh sách dài
          // Ở đây giữ nguyên ...map vì thường danh sách tracking không quá dài.
          ...tracks.map(
            (track) {
              final index = tracks.indexOf(track);
              final isLatest =
                  index == 0; // Đánh dấu cái mới nhất (vị trí đầu tiên)
              final isLast =
                  index == tracks.length - 1; // Đánh dấu cái cuối cùng

              return _buildTimelineItem(
                context,
                text: track['description'] ?? 'No description',
                time: track['time_iso'] ?? '',
                isLatest: isLatest,
                isLast: isLast,
              );
            },
          ).toList(),
        ],
      ),
    );
  }

  // Hàm helper định dạng thời gian
  String _formatTime(String isoTime) {
    try {
      final dateTime = DateTime.parse(isoTime).toLocal();
      // Ví dụ: "20/09/2025 - 10:30"
      return DateFormat('dd/MM/yyyy - HH:mm').format(dateTime);
    } catch (e) {
      return isoTime;
    }
  }

  // Widget xây dựng từng mục trong Timeline
  Widget _buildTimelineItem(
    BuildContext context, {
    required String text,
    required String time,
    required bool isLatest,
    required bool isLast,
  }) {
    String formattedTime = time.isNotEmpty ? _formatTime(time) : 'Unknown time';

    // Màu sắc và kiểu dáng cho điểm timeline
    final timelineColor = isLatest ? ColorName.blue : Colors.grey.shade400;
    final dotSize = isLatest ? 10.w : 8.w;

    return IntrinsicHeight(
      // Đảm bảo chiều cao của Row dựa trên nội dung
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Cột 1: Timeline Dot và Line
          Container(
            width: 20.w,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Line phía trên (chỉ hiển thị từ item thứ 2)
                Expanded(
                  child: Container(
                    width: 2,
                    color: isLatest ? Colors.transparent : Colors.grey.shade300,
                  ),
                ),
                // Dot
                Container(
                  width: dotSize,
                  height: dotSize,
                  decoration: BoxDecoration(
                      color: timelineColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: isLatest
                              ? ColorName.red.withOpacity(0.5)
                              : Colors.transparent,
                          width: isLatest ? 2 : 0)),
                ),
                // Line phía dưới (không hiển thị ở item cuối cùng)
                Expanded(
                  child: Container(
                    width: 2,
                    color: isLast ? Colors.transparent : Colors.grey.shade300,
                  ),
                ),
              ],
            ),
          ),

          Gap(12.w),

          // Cột 2: Nội dung thông báo
          Expanded(
            child: Container(
              margin: EdgeInsets.only(bottom: 16.h), // Khoảng cách giữa các mục
              padding: EdgeInsets.symmetric(vertical: 8.h),
              decoration: BoxDecoration(
                // Thêm viền nhẹ hoặc màu nền cho item mới nhất (tùy chọn)
                color: isLatest
                    ? Colors.blue.withOpacity(0.03)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: InkWell(
                onTap: () {
                  print('Thông báo đã được nhấn: $text');
                },
                child: Padding(
                  padding: EdgeInsets.only(left: 4.w, right: 8.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        text,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: ColorName.black,
                          fontWeight:
                              isLatest ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                      Gap(4.h),
                      Text(
                        formattedTime,
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: Color.fromARGB(255, 120, 120, 120),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
