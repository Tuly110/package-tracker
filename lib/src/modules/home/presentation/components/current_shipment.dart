import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_tracker_app/generated/colors.gen.dart';
import 'package:my_tracker_app/src/modules/home/presentation/components/timeline_widgets.dart';
import 'package:my_tracker_app/src/modules/tracking/domain/entities/tracking_entity.dart';

class CurrentShipment extends StatelessWidget {
  final TrackingEntity? lastestTracking;
  final VoidCallback? onTap;

  const CurrentShipment({
    super.key, 
    this.lastestTracking,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    String normalizeStatus(String? s) {
      if (s == null) return '';
      return s.trim().toLowerCase().replaceAll(RegExp(r'[\s_-]+'), '');
    }

    List<bool> getStepsFromStatus(String? status) {
      final normalized = normalizeStatus(status);

      if (normalized.contains('deliver')) {
        return [true, true, true]; // Delivered
      } else if (normalized.contains('transit')) {
        return [true, true, false]; // InTransit
      } else {
        return [true, false, false]; // Pending
      }
    }

    final steps = lastestTracking == null
        ? [false, false, false]
        : getStepsFromStatus(lastestTracking?.status);

    final Color primaryColor = ColorName.cyan;

    return Container(
      color: ColorName.white,
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Current Shipment',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          InkWell(
            child: Card(
              margin: EdgeInsets.symmetric(vertical: 8.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              elevation: 2,
              shadowColor: ColorName.black.withAlpha(25),
              child: Padding(
                padding: EdgeInsets.all(12.h),
                child: Column(
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundColor: ColorName.cyan.withAlpha(25),
                        child: FaIcon(FontAwesomeIcons.boxOpen,
                            color: ColorName.cyan, size: 20.r),
                      ),
                      title: Text(
                        lastestTracking != null ? '#${lastestTracking!.number}' : 'No shipment',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lastestTracking != null 
                              ? 'Status: ${lastestTracking!.status }' : 'Status: N/A',
                          ),
                        ],
                      ),
                      trailing: Icon(Icons.arrow_forward_ios, size: 16.r),
                    ),
                    TimeLine(
                      steps: steps,
                      primaryColor: primaryColor,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Pending',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          'Intransit',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          'Delivered',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
