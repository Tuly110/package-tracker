import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:my_tracker_app/generated/colors.gen.dart';
import 'package:my_tracker_app/src/modules/trackingDetail/presentation/tracking_detail_page.dart';

import '../../../tracking/domain/entities/tracking_entity.dart';
import '../../../tracking/presentation/cubit/tracking_cubit.dart';

class RecentShipment extends StatelessWidget {
  final List<TrackingEntity> recentShipmentsData;
  const RecentShipment({super.key, required this.recentShipmentsData});

  @override
  Widget build(BuildContext context) {
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
                'Recent Shipment',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Gap(10.h),
          if (recentShipmentsData.isEmpty)
            Center(child: Text("No recent shipments found"))
          else
            Column(
              children: recentShipmentsData.map((tracking) {
                return _buildShipmentItem(
                  context,
                  tracking.id,
                  tracking.number,
                  tracking.status!,
                  tracking.carrier.toString()
                );
              }).toList(),
            )
        ],
      ),
    );
  }

  Widget _buildShipmentItem(
      BuildContext context,
      int? id,
      String trackingNumber,
      String status,
      String carrierCode,
      ) {
    return Slidable(
      key: Key(id?.toString() ?? UniqueKey().toString()),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.25,
        children: [
          SlidableAction(
            onPressed: (_) async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Confirm'),
                  content: const Text('Do you want to delete this shipment?'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel')),
                    TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Ok')),
                  ],
                ),
              );
              if (confirm == true) {
                if (id == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('ID not available')));
                  return;
                }
                await context
                    .read<TrackingCubit>()
                    .deleteTrackingById(id);
              }
            },
            backgroundColor: Colors.white,
            foregroundColor: Colors.red,
            icon: FontAwesomeIcons.trash,
            label: 'Delete',
          ),
        ],
      ),
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 8.h),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r)),
        elevation: 0.5,
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: ColorName.cyan.withAlpha(25),
            child: FaIcon(FontAwesomeIcons.boxOpen,
                color: ColorName.cyan, size: 20.r),
          ),
          title: Text(
            trackingNumber,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            'status: $status',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: ColorName.textSecondary,
                  fontSize: 12.sp,
                ),
          ),
          onTap: () async {
            final either =
                await context.read<TrackingCubit>().trackingDetailsUsecase.call(
                      trackingNumber: trackingNumber,
                      carrierCode: carrierCode,
                    );

            either.fold(
              (failure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: ${failure.message}'))
                );
              },
              (details){
                Navigator.push(context, 
                  MaterialPageRoute(builder: (_)=> TrackingDetailPage(detail: details))
                );
              },
            );
          },
        ),
      ),
    );
  }
}
