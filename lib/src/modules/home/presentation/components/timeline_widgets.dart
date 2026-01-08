import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_tracker_app/generated/colors.gen.dart';
import 'package:timelines_plus/timelines_plus.dart';

class TimeLine extends StatelessWidget {
  const TimeLine({
    super.key,
    this.steps = const [true, true, false],
    this.primaryColor = ColorName.cyan,
  });

  final List<bool> steps;
  final Color primaryColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(steps.length, (index) {
        final bool isCompleted = steps[index];
        final bool isFirst = index == 0;
        final bool isLast = index == steps.length - 1;

        return Expanded(
          child: TimelineNode(
            direction: Axis.horizontal,
            indicator: _buildStatusIcon(isCompleted, primaryColor),
            startConnector: isFirst
                ? null
                : _buildConnector(steps[index - 1], primaryColor),
            endConnector:
                isLast ? null : _buildConnector(isCompleted, primaryColor),
          ),
        );
      }),
    );
  }

  Widget _buildConnector(bool isCompleted, Color color) {
    return isCompleted
        ? SolidLineConnector(color: color, thickness: 2)
        : DashedLineConnector(
            gap: 4.0, dash: 4.0, color: ColorName.gray300, thickness: 2);
  }

  Widget _buildStatusIcon(bool isCompleted, Color color) {
    return Container(
      width: 20.r,
      height: 20.r,
      margin: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isCompleted ? color : ColorName.inkWell,
        border: Border.all(
          color: isCompleted ? ColorName.inkWell : ColorName.gray300,
          width: 2,
        ),
      ),
      child: isCompleted
          ? Icon(Icons.check, color: ColorName.white, size: 14.r)
          : null,
    );
  }
}
