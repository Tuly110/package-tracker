import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProcessWidget extends StatefulWidget {
  const ProcessWidget({super.key});

  @override
  State<ProcessWidget> createState() => _ProcessWidgetState();
}

class _ProcessWidgetState extends State<ProcessWidget> {


  @override
  Widget build(BuildContext context) {


    return Expanded(
      child: ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 330.w), // Giới hạn chiều rộng tối đa
      child: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 10.w, vertical: 0),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: 0.2,
              minHeight: 6.h,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
              backgroundColor: Colors.grey[800],
            ),
          ),
          // const Gap(4),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    counterText: "",
                    hintText: "Tracking number",
                    border: InputBorder.none,
                    hintStyle: TextStyle(fontSize: 12.sp)
                  ),
                ),
              ),
              Text(
                "25/70",
                style: TextStyle(color: Colors.grey, fontSize: 12.sp),
              ),
            ],
          ),
        ],
      ),
      )
    )
    );
  }

}

