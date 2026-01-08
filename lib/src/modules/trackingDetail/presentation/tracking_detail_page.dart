import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_tracker_app/src/modules/tracking/domain/entities/tracking_details_entity.dart';
import 'package:my_tracker_app/src/modules/trackingDetail/presentation/components/today_notify.dart';

import '../../../../generated/colors.gen.dart';

@RoutePage()
class TrackingDetailPage extends StatelessWidget {
  final TrackingDetailEntity detail;
  const TrackingDetailPage({super.key, required this.detail});

  @override
  Widget build(BuildContext context) {
    final latest = detail.latestStatus ?? 'N/A';
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "$latest",
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(color: ColorName.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: ColorName.blue,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: FaIcon(
              FontAwesomeIcons.chevronLeft,
              color: ColorName.white,
              size: 18.sp,
            )),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Tracking number: ${detail.trackingNumber ?? ''} ",
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: ColorName.gray,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp),
                ),
              ),
              Divider(
                color: ColorName.gray300,
                thickness: 1,
              ),
              TodayNotifications(
                detail: detail,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
