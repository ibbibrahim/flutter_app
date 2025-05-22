import 'package:flutter/material.dart';
import 'package:login_portal/utils/size_utils.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../utils/custom_text_style.dart';
import '../../../widgets/custom_image_view.dart';

class DashboardCardItemWidget extends StatelessWidget {
  final String image;
  final String text;
  final Color color;
  final VoidCallback? onTap;

  DashboardCardItemWidget({
    Key? key,
    required this.image,
    required this.text,
    required this.color,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Expanded(
            child: Container(
              width: 62.h,
              padding: EdgeInsets.all(19.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.h),
                color: color,
              ),
              child: CustomImageView(
                imagePath: image,
                height: 24.v,
                width: 24.h,
                fit: BoxFit.contain,
              ),
            ),
          ),
          SizedBox(height: 7.v),
          Text(
            text,
            overflow: TextOverflow.ellipsis,
            style: CustomTextStyles.bodyMediumBlack900,
          ),
        ],
      ),
    );
  }
}
