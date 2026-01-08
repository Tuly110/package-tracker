import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:my_tracker_app/src/modules/carrier/data/models/carrier_model.dart';
import 'package:my_tracker_app/src/modules/carrier/presentation/cubit/carrier_state.dart';

import '../../../../../generated/colors.gen.dart';
import '../../../add_package/presentation/components/app_bar_package.dart';
import '../../../app/app_router.dart';
import '../../../carrier/presentation/cubit/carrier_cubit.dart';
import '../../domain/entities/tracking_details_entity.dart';
import '../cubit/tracking_cubit.dart';
import '../cubit/tracking_state.dart';

@RoutePage()
class TrackingPage extends StatefulWidget {
  // 1. Add the optional trackingNumber parameter to the constructor
  final String? initialTrackingNumber;
  const TrackingPage({
    @pathParam this.initialTrackingNumber, // Make it a path/query parameter for auto_route if needed, or just remove @pathParam
    super.key,
  });

  @override
  State<TrackingPage> createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> {
  String selectedCarrierValue = '';
  String selectedCategoryValue = '';
  List<CarrierModel> carriers = [];
  
  // Initialize controllers without text here, will set in initState
  final TextEditingController trackingController = TextEditingController();
  final TextEditingController carrierController = TextEditingController();
  final TextEditingController memoController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();

  final List<String> categories = [
    'Electronics',
    'Clothing',
    'Books',
    'Home Goods',
    'Other'
  ];

  @override
  void initState() {
    super.initState();
    // 2. Set the initial text for the trackingController
    // It will be null or an empty string if nothing was passed
    if (widget.initialTrackingNumber != null) {
      trackingController.text = widget.initialTrackingNumber!;
    }
  }

  @override
  void dispose() {
    trackingController.dispose();
    carrierController.dispose();
    memoController.dispose();
    categoryController.dispose();
    super.dispose();
  }

  // ... (Your _showCategorySelectionSheet function remains the same)
  void _showCategorySelectionSheet(BuildContext context) {
    TextEditingController searchController = TextEditingController();
    List<String> filteredCategories = List.from(categories);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final double height = MediaQuery.of(context).size.height * 0.75;

            return SizedBox(
              height: height,
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Select Category',
                      style: TextStyle(
                          fontSize: 18.sp, fontWeight: FontWeight.bold),
                    ),
                    const Gap(10),
                    TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'Search category...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onChanged: (value) {
                        setModalState(() {
                          filteredCategories = categories
                              .where((c) =>
                                  c.toLowerCase().contains(value.toLowerCase()))
                              .toList();
                        });
                      },
                    ),
                    const Gap(16),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredCategories.length,
                        itemBuilder: (context, index) {
                          final category = filteredCategories[index];
                          return ListTile(
                            title: Text(category),
                            onTap: () {
                              setState(() {
                                selectedCategoryValue = category;
                                categoryController.text = selectedCategoryValue;
                              });
                              Navigator.pop(context);
                            },
                            selected: category == selectedCategoryValue,
                            selectedTileColor: ColorName.blue.withOpacity(0.1),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TrackingCubit, TrackingState>(
      listener: (context, state) {
        state.maybeWhen(
          success: (tracking) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text("Successfull Register: ${tracking.number}")),
            );
            final detailEntity = TrackingDetailEntity(
              rawData: tracking.toJson(), 
            );

            // 3. Chuyển hướng sang trang chi tiết đơn hàng
            // detail là tham số mà TrackingDetailPage yêu cầu
            context.router.push(TrackingDetailRoute(detail: detailEntity));
          },
          error: (message) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Error: $message")),
            );
          },
          orElse: () {},
        );
      },
      builder: (context, state) {
        return SafeArea(
            child: Container(
          color: ColorName.white,
          child: SingleChildScrollView(
            child: Column(
              children: [
                AppBarPackage(),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 16.h),
                  child: Column(
                    children: [
                      // Tracking Number Field
                      TextField(
                        controller: trackingController,
                        style: TextStyle(color: ColorName.black),
                        decoration: InputDecoration(
                          hintText: "Your tracking number",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
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
                              FontAwesomeIcons.qrcode,
                              color: ColorName.blue, // Changed icon color from white to blue for visibility
                              size: 24.r,
                            ),
                            onPressed: () {
                              context.router.push(MobileScannerRoute());
                            },
                          ),
                        ),
                      ),
                      Gap(15),

                      // Carrier Selection Field
                      BlocBuilder<CarrierCubit, CarrierState>(
                        builder: (context, carrierState) {
                          return GestureDetector(
                            onTap: () {
                              if (carrierState is CarrierSuccess) {
                                final carriers = carrierState.carriers;
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (context) {
                                    TextEditingController searchController =
                                        TextEditingController();
                                    List<CarrierModel> filteredCarriers =
                                        List.from(carriers);

                                    return StatefulBuilder(
                                      builder: (context, setModalState) {
                                        return Padding(
                                          padding: EdgeInsets.all(16.w),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                'Select Carrier',
                                                style: TextStyle(
                                                    fontSize: 18.sp,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              const Gap(10),
                                              TextField(
                                                controller: searchController,
                                                decoration: InputDecoration(
                                                  hintText: 'Search carrier...',
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                ),
                                                onChanged: (value) {
                                                  setModalState(() {
                                                    filteredCarriers = carriers
                                                        .where((c) => c.name!
                                                            .toLowerCase()
                                                            .contains(value
                                                                .toLowerCase()))
                                                        .toList();
                                                  });
                                                },
                                              ),
                                              SizedBox(height: 16),
                                              Expanded(
                                                child: ListView.builder(
                                                  itemCount:
                                                      filteredCarriers.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    final carrier =
                                                        filteredCarriers[index];
                                                    return ListTile(
                                                      title: Text(
                                                          carrier.name ?? ''),
                                                      onTap: () {
                                                        setState(() {
                                                          selectedCarrierValue =
                                                              carrier.name ??
                                                                  '';
                                                          carrierController
                                                                  .text =
                                                              selectedCarrierValue;
                                                        });
                                                        Navigator.pop(context);
                                                      },
                                                      selected: carrier.name ==
                                                          selectedCarrierValue,
                                                      selectedTileColor:
                                                          ColorName.blue
                                                              .withOpacity(0.1),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                );
                              } else if (carrierState is CarrierLoading) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Loading carrier list...")),
                                );
                              } else if (carrierState is CarrierError) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          "Error: ${carrierState.message}")),
                                );
                              }
                            },
                            child: AbsorbPointer(
                              child: TextField(
                                controller: carrierController,
                                style: TextStyle(color: ColorName.black),
                                decoration: InputDecoration(
                                  hintText: "Auto detect carrier (Optional)",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                   enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  suffixIcon: const Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.grey, 
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      Gap(15),

                      // New: Category Selection Field
                      GestureDetector(
                        onTap: () => _showCategorySelectionSheet(context),
                        child: AbsorbPointer(
                          child: TextField(
                            controller: categoryController,
                            style: TextStyle(color: ColorName.black), // Text color is now black
                            decoration: InputDecoration(
                              hintText: selectedCategoryValue.isEmpty
                                  ? "Select package category (Optional)"
                                  : selectedCategoryValue,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              suffixIcon: const Icon(
                                Icons.arrow_drop_down,
                                color: Colors.grey, // Icon color is grey
                              ),
                            ),
                          ),
                        ),
                      ),
                      Gap(15),

                      // Memo Field
                      TextField(
                        controller: memoController,
                        style: TextStyle(color: ColorName.black),
                        decoration: InputDecoration(
                          hintText: "Your memo (Optional)",
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

                      // Track Button
                      Padding(
                          padding: EdgeInsets.only(top: 0),
                          child: SizedBox(
                            width: double.infinity,
                            child: TextButton(
                              onPressed: state.maybeWhen(
                                loading: () => null, // Disable button when loading
                                orElse: () {
                                  return () {
                                    final trackingNumber =
                                        trackingController.text.trim();
                                    final carrierName =
                                        carrierController.text.trim();
                                    final memo = memoController.text.trim();
                                    final categoryName =
                                        categoryController.text.trim();

                                    if (trackingNumber.isEmpty) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                "Vui lòng nhập mã vận đơn")),
                                      );
                                      return;
                                    }
                                    context
                                      .read<TrackingCubit>()
                                      .registerTracking(
                                        trackingNumber, 
                                        selectedCarrierValue, // Đây là giá trị carrierCode bạn chọn từ BottomSheet
                                        memoController.text.trim(),
                                        selectedCategoryValue,
                                      )
                                      .then((_) {
                                        // success is handled by the listener
                                      }).catchError((error) {
                                        // Handle potential errors
                                      });
                                  };
                                },
                              ),
                              child: state.maybeWhen(
                                loading: () => const CircularProgressIndicator(
                                    color: Colors.white),
                                orElse: () => Text(
                                  'Track',
                                  style: TextStyle(
                                      color: ColorName.white,
                                      fontSize: 15.sp),
                                ),
                              ),
                              style: TextButton.styleFrom(
                                backgroundColor: ColorName.blue,
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
      },
    );
  }
}