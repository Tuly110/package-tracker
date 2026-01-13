import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_tracker_app/src/modules/notify/presentation/cubit/notify_cubit.dart';
import 'package:my_tracker_app/src/modules/notify/presentation/cubit/notify_state.dart';

import '../../../../generated/colors.gen.dart';

@RoutePage()
class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotifyCubit, NotifyState>(
        builder: (context, state) {
          final cubit = context.read<NotifyCubit>();
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Notifications',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: ColorName.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              backgroundColor: ColorName.blue,
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  onPressed: () => cubit.loadNotifications(),
                ),
              ],
              iconTheme: IconThemeData(color: ColorName.brandBlue),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context, state),
                    Divider(
                      color: ColorName.gray300,
                      thickness: 1,
                    ),
                    if (state is NotifyLoaded)
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.messages.length,
                        itemBuilder: (context, index) {
                          final notify = state.messages[index];

                          // Xác định trạng thái và màu chấm tròn
                          final isRead = notify.status == 'read';
                          final dotColor =
                              isRead ? ColorName.gray300 : ColorName.blue;
                          final dotSize = 8.0.r;

                          return Card(
                            color: isRead
                                ? Colors.white
                                : ColorName.blue
                                    .withOpacity(0.05), // Highlight unread
                            child: ListTile(
                              // Chấm tròn trạng thái
                              leading: Container(
                                width: dotSize,
                                height: dotSize,
                                margin: EdgeInsets.only(top: 6.r),
                                decoration: BoxDecoration(
                                  color: dotColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              title: Text(
                                notify.message ?? 'No title',
                                style: TextStyle(
                                  fontWeight: isRead
                                      ? FontWeight.normal
                                      : FontWeight.bold,
                                  color:
                                      isRead ? ColorName.gray : ColorName.black,
                                ),
                              ),
                              onTap: () {
                                if(notify.status != 'read'){
                                  cubit.markAsRead(notify.id.toString());
                                }
                              },
                              // Ẩn subtitle chứa status text
                              // subtitle: Text(notify.status ?? ''),
                              trailing: PopupMenuButton<String>(
                                onSelected: (value) {
                                  if (value == 'read') {
                                    cubit.markAsRead(notify.id.toString());
                                  } else if (value == 'delete') {
                                    cubit.removeNotification(
                                        notify.id.toString());
                                  }
                                },
                                itemBuilder: (context) => [
                                  if (notify.status != 'read')
                                    const PopupMenuItem(
                                      value: 'read',
                                      child: Text('Mark as read'),
                                    ),
                                  const PopupMenuItem(
                                    value: 'delete',
                                    child: Text('Delete'),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    if (state is NotifyLoading)
                      const Center(child: CircularProgressIndicator()),
                    if (state is NotifyError)
                      Text(
                        state.message,
                        style: const TextStyle(color: Colors.red),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      );
  }

  Widget _buildHeader(BuildContext context, NotifyState state) {
    int count = 0;
    if (state is NotifyLoaded) count = state.messages.length;

    return RichText(
      textAlign: TextAlign.start,
      text: TextSpan(
        text: 'You have ',
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: ColorName.gray,
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
            ),
        children: [
          TextSpan(
            text: '$count new notifications',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: ColorName.brandBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                ),
          ),
          TextSpan(
            text: ' today',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: ColorName.gray,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                ),
          ),
        ],
      ),
    );
  }
}
