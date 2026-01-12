import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:my_tracker_app/generated/colors.gen.dart';
import 'package:my_tracker_app/src/modules/app/app_router.dart';
import 'package:my_tracker_app/src/modules/auth/presentation/cubit/auth_cubit.dart';
import 'package:my_tracker_app/src/modules/home/presentation/components/current_shipment.dart';
import 'package:my_tracker_app/src/modules/home/presentation/components/header_section.dart';
import 'package:my_tracker_app/src/modules/tracking/domain/entities/tracking_entity.dart';
import 'package:my_tracker_app/src/modules/tracking/presentation/cubit/tracking_cubit.dart';

import '../../tracking/domain/entities/tracking_details_entity.dart';
import '../../tracking/presentation/cubit/tracking_state.dart';
import 'components/recent_shipment.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<TrackingEntity> filteredTrackings = [];
  int selectedCategoryIndex = 0; // 0= all, 1= intransit, 2= delivered

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TrackingCubit>().getTrackingList();
      final authState = context.read<AuthCubit>().state;

      authState.maybeWhen(
        userInfoLoaded: (_) {
        },
        orElse: () {
          context.read<AuthCubit>().getUserInfo();
        },
      );
    });
  }

  void filterTracking(String query, List<TrackingEntity> listTracking) {
    setState(() {
      if (query.isEmpty) {
        filteredTrackings.clear();
      } else {
        filteredTrackings = listTracking
            .where((tracking) =>
                tracking.number.toLowerCase().contains(query.toLowerCase()))
            .toList();
        print("Filtered list length: ${filteredTrackings.length}");
      }
    });
  }

  List<TrackingEntity> filterByCategory(
      int index, List<TrackingEntity> trackings) {
    if (index == 0) return trackings;
    if (index == 1) {
      return trackings
          .where((t) => t.status!.toLowerCase() == 'intransit')
          .toList();
    }
    if (index == 2) {
      return trackings
          .where((t) => t.status!.toLowerCase() == 'delivered')
          .toList();
    }
    return trackings;
  }

  String _normalizeStatus(String? s) {
    if (s == null) return '';
    return s.trim().toLowerCase().replaceAll(RegExp(r'[\s_-]+'), '');
  }

  List<TrackingEntity> applyFilters(
    int categoryIndex,
    List<TrackingEntity> allTrackings,
    List<TrackingEntity> searchedTrackings,
  ) {
    final source =
        searchedTrackings.isNotEmpty ? searchedTrackings : allTrackings;

    if (categoryIndex == 0) return source; // All

    if (categoryIndex == 1) {
      final filtered = source.where((t) {
        final n = _normalizeStatus(t.status);
        return n.contains('transit') ||
            n.contains('ship') ||
            n.contains('intransit');
      }).toList();
      return filtered;
    }

    if (categoryIndex == 2) {
      final filtered = source.where((t) {
        final n = _normalizeStatus(t.status);
        return n.contains('deliver');
      }).toList();
      return filtered;
    }

    return source;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorName.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 70.w,
        backgroundColor: ColorName.blue,
        elevation: 0,
        flexibleSpace: SafeArea(
            child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Column(children: [
                  BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
                    final user = state.maybeWhen(
                        userInfoLoaded: (user) => user, orElse: () => null);
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 24.r,
                          backgroundImage:
                              NetworkImage('https://i.pravatar.cc/150?img=32'),
                        ),
                        Gap(12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                user?.username ?? '',
                                style: TextStyle(
                                  color: ColorName.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.sp,
                                ),
                              ),
                              Text(
                                user?.email ?? '',
                                style: TextStyle(
                                  color: ColorName.lightGray,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Gap(12.w),
                        IconButton(
                          icon: FaIcon(
                            FontAwesomeIcons.qrcode,
                            color: ColorName.white,
                            size: 24.r,
                          ),
                          onPressed: () {
                            context.router.push(MobileScannerRoute());
                          },
                        ),
                        IconButton(
                          icon: Container(
                            height: 32.r,
                            width: 32.r,
                            decoration: const BoxDecoration(
                              color: ColorName.cyan,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: FaIcon(
                                FontAwesomeIcons.plus,
                                color: ColorName.white,
                                size: 16.r,
                              ),
                            ),
                          ),
                          onPressed: () async {
                            final result =
                                await context.router.push(TrackingRoute());
                            if (result == true) {
                              context.read<TrackingCubit>().getTrackingList();
                            }
                          },
                        ),
                      ],
                    );
                  })
                ]))),
      ),
      body: BlocBuilder<TrackingCubit, TrackingState>(
        builder: (context, state) {
          List<TrackingEntity> trackings = [];
          bool isLoading = false;
          String? errorMessage;

          state.maybeWhen(
            successList: (data) {
              trackings = data;
            },
            loading: () {
              isLoading = true;
            },
            error: (msg) {
              errorMessage = msg;
            },
            orElse: () {},
          );

          // tính categories
          final allCount = trackings.length;
          final shippingCount = trackings.where((t) {
            final n = _normalizeStatus(t.status);
            return n.contains('transit') ||
                n.contains('ship') ||
                n.contains('intransit');
          }).length;
          final deliveredCount = trackings
              .where((t) => _normalizeStatus(t.status).contains('deliver'))
              .length;

          final categories = [
            CategoryInfo(
                icon: FontAwesomeIcons.boxOpen, text: 'All($allCount)'),
            CategoryInfo(
                icon: FontAwesomeIcons.truckFast,
                text: 'InTransit($shippingCount)'),
            CategoryInfo(
                icon: FontAwesomeIcons.houseCircleCheck,
                text: 'Delivered($deliveredCount)'),
          ];

          final dataToShow = applyFilters(
            selectedCategoryIndex,
            trackings,
            filteredTrackings,
          );

          return Column(
            children: [
              HeaderSection(
                gapHeight: MediaQuery.of(context).padding.top + 70.w + 16.h,
                categories: categories,
                selectedCategoryIndex: selectedCategoryIndex,
                onCategorySelected: (index) {
                  setState(() {
                    selectedCategoryIndex = index;
                  });
                },
                onSearchChanged: (query) {
                  final listTracking =
                      context.read<TrackingCubit>().state.maybeWhen(
                            successList: (trackings) => trackings,
                            orElse: () => <TrackingEntity>[],
                          );
                  filterTracking(query, listTracking);
                },
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (isLoading) const CircularProgressIndicator(),
                      if (errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text("Error: $errorMessage"),
                        ),
                      if (!isLoading && errorMessage == null) ...[
                        Builder(
                          builder: (_) {
                            final sorted = List.from(dataToShow)
                              ..sort((a, b) =>
                                  b.register_time.compareTo(a.register_time));

                            final lastestTracking =
                                sorted.isNotEmpty ? sorted.first : null;

                            return CurrentShipment(
                                lastestTracking: lastestTracking,
                                onTap: (){
                                  if (lastestTracking != null) {
                                    final Map<String, dynamic> rawData = {
                                      ...lastestTracking!.toJson(),
                                      'tracking_info': lastestTracking!.tracking_info, // Ép dữ liệu vào đây
                                    };
                                    final detailEntity = TrackingDetailEntity(
                                      rawData: rawData,
                                    );
                                    context.router.push(
                                      TrackingDetailRoute(detail: detailEntity),
                                    );
                                  }
                                },
                              );
                          },
                        ),
                        RecentShipment(
                          recentShipmentsData: List.from(dataToShow)
                            ..sort((a, b) =>
                                b.register_time.compareTo(a.register_time)),
                        ),
                      ],
                    ],
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
