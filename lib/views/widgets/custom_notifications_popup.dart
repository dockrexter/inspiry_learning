import 'package:flutter/material.dart';
import "package:flutter/cupertino.dart";
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:inspiry_learning/globals/global_exports.dart';

void customNotificationsPopup(BuildContext context) {
  showCupertinoDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => SafeArea(
      child: AlertDialog(
        insetPadding: EdgeInsets.only(bottom: 56.h, right: 64.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.r)),
        ),
        contentPadding: const EdgeInsets.all(0.0),
        content: Builder(builder: (context) {
          return Container(
            width: ScreenSize.width * 0.7,
            height: ScreenSize.height * 0.7,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.all(Radius.circular(20.r)),
            ),
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: ListView.builder(
                itemCount: 100,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) => InkWell(
                  onTap: () => debugPrint(index.toString()),
                  child: Container(
                    height: 65.h,
                    margin: EdgeInsets.only(bottom: 16.h),
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: AppColors.teal40065.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(8.r),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 12.r,
                          offset: const Offset(0, 4),
                          color: AppColors.teal900.withOpacity(0.08),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.notifications,
                          color: AppColors.teal900,
                          size: 24.w,
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Text(
                            "Notification Title",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.teal900,
                            ),
                          ),
                        ),
                        Text(
                          "12:00",
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.teal900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    ),
  );
}
