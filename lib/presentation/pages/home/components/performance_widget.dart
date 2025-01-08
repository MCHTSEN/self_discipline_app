import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:self_discipline_app/core/constants/paddings.dart';
import 'package:self_discipline_app/core/helper/gap.dart';

class PerformanceWidget extends ConsumerWidget {
  final String text;
  final IconData icon;
  const PerformanceWidget({
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(86, 255, 83, 226),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: ProjectPaddingType.xSmallPadding.allPadding,
              child: Icon(icon, color: Colors.black, size: 13),
            ),
            Gap.extraLow,
            Expanded(
              child: Text(
                text,
                style: TextStyle(color: Colors.black, fontSize: 13.sp),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
